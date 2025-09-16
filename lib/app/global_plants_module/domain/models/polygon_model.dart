import 'package:hive/hive.dart';

part 'polygon_model.g.dart';

@HiveType(typeId: 1)
class PolygonModel {
  @HiveField(0)
  final List<List<num>> coordinates;

  PolygonModel({required this.coordinates});

  factory PolygonModel.fromMap(List<dynamic> rawList) {
    return PolygonModel(
      coordinates: rawList.map<List<num>>((coord) {
        final casted = List<num>.from(coord as List<dynamic>);
        return casted;
      }).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coordinates': coordinates,
    };
  }
}
