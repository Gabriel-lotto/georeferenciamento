// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_plant_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GlobalPlantModelAdapter extends TypeAdapter<GlobalPlantModel> {
  @override
  final int typeId = 0;

  @override
  GlobalPlantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GlobalPlantModel(
      id: fields[0] as int,
      name: fields[1] as String,
      polygon: fields[2] as PolygonModel,
    );
  }

  @override
  void write(BinaryWriter writer, GlobalPlantModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.polygon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlobalPlantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
