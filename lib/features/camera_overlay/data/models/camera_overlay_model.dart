import 'package:hive/hive.dart';
import 'dart:ui';
import '../../domain/entities/camera_overlay_entity.dart';

part 'camera_overlay_model.g.dart';

@HiveType(typeId: 0)
class CameraOverlayModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String imagePath;
  
  @HiveField(2)
  final double opacity;
  
  @HiveField(3)
  final double scale;
  
  @HiveField(4)
  final double positionDx;
  
  @HiveField(5)
  final double positionDy;
  
  @HiveField(6)
  final double rotation;
  
  @HiveField(7)
  final bool isVisible;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final String? description;

  CameraOverlayModel({
    required this.id,
    required this.imagePath,
    required this.opacity,
    required this.scale,
    required this.positionDx,
    required this.positionDy,
    required this.rotation,
    required this.isVisible,
    required this.createdAt,
    this.description,
  });

  Offset get position => Offset(positionDx, positionDy);

  factory CameraOverlayModel.fromEntity(CameraOverlayEntity entity) {
    return CameraOverlayModel(
      id: entity.id,
      imagePath: entity.imagePath,
      opacity: entity.opacity,
      scale: entity.scale,
      positionDx: entity.position.dx,
      positionDy: entity.position.dy,
      rotation: entity.rotation,
      isVisible: entity.isVisible,
      createdAt: entity.createdAt,
      description: entity.description,
    );
  }

  CameraOverlayEntity toEntity() {
    return CameraOverlayEntity(
      id: id,
      imagePath: imagePath,
      opacity: opacity,
      scale: scale,
      position: position,
      rotation: rotation,
      isVisible: isVisible,
      createdAt: createdAt,
      description: description,
    );
  }

  CameraOverlayModel copyWith({
    String? id,
    String? imagePath,
    double? opacity,
    double? scale,
    double? positionDx,
    double? positionDy,
    double? rotation,
    bool? isVisible,
    DateTime? createdAt,
    String? description,
  }) {
    return CameraOverlayModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      opacity: opacity ?? this.opacity,
      scale: scale ?? this.scale,
      positionDx: positionDx ?? this.positionDx,
      positionDy: positionDy ?? this.positionDy,
      rotation: rotation ?? this.rotation,
      isVisible: isVisible ?? this.isVisible,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'CameraOverlayModel(id: $id, imagePath: $imagePath, opacity: $opacity, scale: $scale, position: $position, rotation: $rotation, isVisible: $isVisible, createdAt: $createdAt, description: $description)';
  }
}
