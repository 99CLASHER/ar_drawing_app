// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_overlay_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CameraOverlayModelAdapter extends TypeAdapter<CameraOverlayModel> {
  @override
  final int typeId = 0;

  @override
  CameraOverlayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CameraOverlayModel(
      id: fields[0] as String,
      imagePath: fields[1] as String,
      opacity: fields[2] as double,
      scale: fields[3] as double,
      positionDx: fields[4] as double,
      positionDy: fields[5] as double,
      rotation: fields[6] as double,
      isVisible: fields[7] as bool,
      createdAt: fields[8] as DateTime,
      description: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CameraOverlayModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.opacity)
      ..writeByte(3)
      ..write(obj.scale)
      ..writeByte(4)
      ..write(obj.positionDx)
      ..writeByte(5)
      ..write(obj.positionDy)
      ..writeByte(6)
      ..write(obj.rotation)
      ..writeByte(7)
      ..write(obj.isVisible)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CameraOverlayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
