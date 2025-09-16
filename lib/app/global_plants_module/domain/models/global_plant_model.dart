import 'package:hive/hive.dart';

import 'polygon_model.dart';

part 'global_plant_model.g.dart';

@HiveType(typeId: 0)
class GlobalPlantModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  /// Cada planta contém exatamente um polígono.
  @HiveField(2)
  final PolygonModel polygon;

  GlobalPlantModel({
    required this.id,
    required this.name,
    required this.polygon,
  });

  factory GlobalPlantModel.fromMap(Map<String, dynamic> map) {
    return GlobalPlantModel(
      id: map['id'] as int,
      name: map['name'] as String,
      polygon: PolygonModel.fromMap(map['polygon'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'polygon': polygon.coordinates,
    };
  }
}
