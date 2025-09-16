// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'polygon_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PolygonModelAdapter extends TypeAdapter<PolygonModel> {
  @override
  final int typeId = 1;

  @override
  PolygonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PolygonModel(
      coordinates: (fields[0] as List)
          .map((dynamic e) => (e as List).cast<double>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, PolygonModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.coordinates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PolygonModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
