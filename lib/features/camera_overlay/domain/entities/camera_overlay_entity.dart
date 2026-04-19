import 'dart:ui';

class CameraOverlayEntity {
  final String id;
  final String imagePath;
  final double opacity;
  final double scale;
  final Offset position;
  final double rotation;
  final bool isVisible;
  final DateTime createdAt;
  final String? description;

  const CameraOverlayEntity({
    required this.id,
    required this.imagePath,
    required this.opacity,
    required this.scale,
    required this.position,
    required this.rotation,
    required this.isVisible,
    required this.createdAt,
    this.description,
  });

  factory CameraOverlayEntity.create({
    required String imagePath,
    double opacity = 0.7,
    double scale = 1.0,
    Offset position = Offset.zero,
    double rotation = 0.0,
    bool isVisible = true,
    String? description,
  }) {
    return CameraOverlayEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: imagePath,
      opacity: opacity,
      scale: scale,
      position: position,
      rotation: rotation,
      isVisible: isVisible,
      createdAt: DateTime.now(),
      description: description,
    );
  }

  CameraOverlayEntity copyWithUpdatedOpacity(double newOpacity) {
    return copyWith(opacity: newOpacity.clamp(0.0, 1.0));
  }

  CameraOverlayEntity copyWithUpdatedScale(double newScale) {
    return copyWith(scale: newScale.clamp(0.1, 3.0));
  }

  CameraOverlayEntity copyWithUpdatedPosition(Offset newPosition) {
    return copyWith(position: newPosition);
  }

  CameraOverlayEntity copyWithUpdatedRotation(double newRotation) {
    return copyWith(rotation: newRotation);
  }

  CameraOverlayEntity toggleVisibility() {
    return copyWith(isVisible: !isVisible);
  }

  CameraOverlayEntity copyWith({
    String? id,
    String? imagePath,
    double? opacity,
    double? scale,
    Offset? position,
    double? rotation,
    bool? isVisible,
    DateTime? createdAt,
    String? description,
  }) {
    return CameraOverlayEntity(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      opacity: opacity ?? this.opacity,
      scale: scale ?? this.scale,
      position: position ?? this.position,
      rotation: rotation ?? this.rotation,
      isVisible: isVisible ?? this.isVisible,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CameraOverlayEntity &&
           other.id == id &&
           other.imagePath == imagePath &&
           other.opacity == opacity &&
           other.scale == scale &&
           other.position == position &&
           other.rotation == rotation &&
           other.isVisible == isVisible &&
           other.createdAt == createdAt &&
           other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
           imagePath.hashCode ^
           opacity.hashCode ^
           scale.hashCode ^
           position.hashCode ^
           rotation.hashCode ^
           isVisible.hashCode ^
           createdAt.hashCode ^
           description.hashCode;
  }

  @override
  String toString() {
    return 'CameraOverlayEntity(id: $id, imagePath: $imagePath, opacity: $opacity, scale: $scale, position: $position, rotation: $rotation, isVisible: $isVisible, createdAt: $createdAt, description: $description)';
  }
}
