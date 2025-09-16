import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/models/global_plant_model.dart';
import '../controllers/global_plant_controller.dart';

class GlobalPlantsPage extends StatefulWidget {
  const GlobalPlantsPage({super.key});

  @override
  State<GlobalPlantsPage> createState() => _GlobalPlantsPageState();
}

class _GlobalPlantsPageState extends State<GlobalPlantsPage> {
  final controller = Modular.get<GlobalPlantsController>();

  @override
  void initState() {
    super.initState();
    controller.loadingAll.value = true;
    controller.getCurrentPosition();

    controller.loadPlants().then((_) {
      controller.onMatchButtonPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plantas Globais')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<bool>(
            valueListenable: controller.loadingAll,
            builder: (_, loading, ___) {
              if (loading) {
                return const Center(child: LinearProgressIndicator());
              }
              return Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.my_location),
                    label: const Text('Localizar Planta'),
                    onPressed: controller.onMatchButtonPressed,
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder(
                    valueListenable: controller.matchedPlants,
                    builder: (_, __, ___) {
                      final lines = <String>[];
                      if (controller.listarDuration != null) {
                        lines.add('⏱ Listar plantas: ${controller.listarDuration!.inMilliseconds} ms');
                      }
                      if (controller.cacheDuration != null) {
                        lines.add('⏱ Salvar no cache: ${controller.cacheDuration!.inMilliseconds} ms');
                      }
                      if (controller.matchDuration != null) {
                        lines.add('⏱ Match localização: ${controller.matchDuration!.inMilliseconds} ms');
                      }
                      if (controller.allPlants.isNotEmpty) {
                        lines.add('⏱ Quantidade de Plantas Globais: ${controller.allPlants.length}');
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: lines.map((t) => Text(t)).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<LatLng?>(
                    valueListenable: controller.currentPosition,
                    builder: (_, pos, __) {
                      if (pos == null) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: Text('Obtendo localização...')),
                        );
                      }
                      return SizedBox(
                        height: 200,
                        child: FlutterMap(
                          options: MapOptions(center: pos, zoom: 16),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: const ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: pos,
                                  width: 50,
                                  height: 50,
                                  builder: (_) => const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<LatLng?>(
                    valueListenable: controller.currentPosition,
                    builder: (_, pos, __) {
                      if (pos == null) return const SizedBox();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.gps_fixed, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Lat: ${pos.latitude.toStringAsFixed(5)}, '
                            'Lon: ${pos.longitude.toStringAsFixed(5)}',
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<List<GlobalPlantModel>>(
                    valueListenable: controller.matchedPlants,
                    builder: (_, matches, __) {
                      if (matches.isEmpty && controller.currentPosition.value != null) {
                        return const Text(
                          'Nenhuma Planta Global corresponde à localização atual.',
                          style: TextStyle(color: Colors.red),
                        );
                      } else if (matches.length == 1) {
                        return Text(
                          'Você está na planta: ${matches.first.name}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        );
                      } else if (matches.length > 1) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Selecione a planta:'),
                            ValueListenableBuilder<GlobalPlantModel?>(
                              valueListenable: controller.selectedPlant,
                              builder: (_, selected, __) {
                                return DropdownButton<GlobalPlantModel>(
                                  isExpanded: true,
                                  value: selected,
                                  hint: const Text('Escolha...'),
                                  items: matches
                                      .map((p) => DropdownMenuItem(
                                            value: p,
                                            child: Text(p.name),
                                          ))
                                      .toList(),
                                  onChanged: (p) {
                                    controller.selectedPlant.value = p;
                                  },
                                );
                              },
                            )
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }
}
