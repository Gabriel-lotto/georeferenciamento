import 'package:poc_geo/app/global_plants_module/domain/models/global_plant_model.dart';

abstract class IGlobaPlantRepository {
  Future<List<GlobalPlantModel>> getGlobalPlants();
}
