import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/models/global_plant_model.dart';
import '../../domain/repositories/global_plant_repository_interface.dart';

class GlobalPlantsController extends ChangeNotifier {
  final IGlobaPlantRepository repository;

  final loadingPlants = ValueNotifier<bool>(false);
  final currentPosition = ValueNotifier<LatLng?>(null);
  final matchedPlants = ValueNotifier<List<GlobalPlantModel>>([]);
  final selectedPlant = ValueNotifier<GlobalPlantModel?>(null);
  final errorMessage = ValueNotifier<String?>(null);
  final loadingAll = ValueNotifier<bool>(false);

  final Map<String, Duration> actionDurations = {};
  late Box<GlobalPlantModel> _plantsBox;
  List<GlobalPlantModel> allPlants = [];

  GlobalPlantsController(this.repository) {
    _plantsBox = Hive.box<GlobalPlantModel>('global_plants_box');
  }

  Duration? get listarDuration => actionDurations['listar plantas'];
  Duration? get cacheDuration => actionDurations['salvar no cache'];
  Duration? get matchDuration => actionDurations['match localização'];

  Future<void> loadPlants() async {
    loadingPlants.value = true;
    errorMessage.value = null;

    final sw = Stopwatch()..start();
    try {
      allPlants = await repository.getGlobalPlants();

      final original = List<GlobalPlantModel>.from(allPlants);
      for (var i = 1; i < 40; i++) {
        allPlants.addAll(original);
      }

      sw.stop();
      actionDurations['listar plantas'] = sw.elapsed;

      if (allPlants.isNotEmpty) {
        await _savePlantsInCache();
      }
    } catch (e) {
      sw.stop();
      actionDurations['listar plantas'] = sw.elapsed;
      errorMessage.value = 'Falha ao carregar plantas: $e';
    }

    loadingPlants.value = false;
  }

  Future<void> _savePlantsInCache() async {
    final sw = Stopwatch()..start();

    await _plantsBox.clear();

    final entries = {
      for (var planta in allPlants) planta.id: planta,
    };

    await _plantsBox.putAll(entries);

    sw.stop();
    actionDurations['salvar no cache'] = sw.elapsed;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        errorMessage.value = 'Permissão de localização negada.';
        return null;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = LatLng(pos.latitude, pos.longitude);
      return pos;
    } catch (e) {
      errorMessage.value = 'Erro ao obter localização: $e';
      return null;
    }
  }

  Future<bool> matchPlantForCurrentLocation() async {
    errorMessage.value = null;
    matchedPlants.value = [];
    selectedPlant.value = null;

    if (allPlants.isEmpty) {
      await loadPlants();
      if (allPlants.isEmpty) return false;
    }

    final pos = await getCurrentPosition();
    if (pos == null) return false;

    final sw = Stopwatch()..start();
    final lon = pos.longitude;
    final lat = pos.latitude;
    final matches = <GlobalPlantModel>[];

    for (var planta in allPlants) {
      if (_pointInPolygon(lon, lat, planta.polygon.coordinates)) {
        matches.add(planta);
      }
    }
    sw.stop();
    actionDurations['match localização'] = sw.elapsed;

    matchedPlants.value = matches;
    return matches.isNotEmpty;
  }

  bool _pointInPolygon(double x, double y, List<List<num>> poly) {
    var inside = false;
    for (var i = 0, j = poly.length - 1; i < poly.length; j = i++) {
      final xi = poly[i][0], yi = poly[i][1];
      final xj = poly[j][0], yj = poly[j][1];
      final intersect = ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
      if (intersect) inside = !inside;
    }
    return inside;
  }

  Future<void> onMatchButtonPressed() async {
    loadPlants();
    loadingAll.value = true;

    try {
      if (allPlants.isEmpty || loadingPlants.value) {
        await loadPlants();
      }

      final found = await matchPlantForCurrentLocation();
      if (found && matchedPlants.value.length == 1) {
        selectedPlant.value = matchedPlants.value.first;
      } else if (!found) {
        errorMessage.value = 'Nenhuma Planta Global corresponde à localização atual.';
      }
    } catch (e) {
      errorMessage.value = 'Erro inesperado: $e';
    } finally {
      loadingAll.value = false;
    }
  }
}
