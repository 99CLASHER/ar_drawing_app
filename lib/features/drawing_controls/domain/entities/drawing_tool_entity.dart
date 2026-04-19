import 'package:flutter/material.dart';

enum DrawingToolType {
  pen,
  brush,
  eraser,
  line,
  rectangle,
  circle,
  text,
}

class DrawingToolEntity {
  final String id;
  final DrawingToolType type;
  final Color color;
  final double strokeWidth;
  final double opacity;
  final bool isActive;
  final String? name;
  final Map<String, dynamic>? customProperties;

  const DrawingToolEntity({
    required this.id,
    required this.type,
    required this.color,
    required this.strokeWidth,
    required this.opacity,
    this.isActive = false,
    this.name,
    this.customProperties,
  });

  factory DrawingToolEntity.create({
    required DrawingToolType type,
    Color color = Colors.black,
    double strokeWidth = 2.0,
    double opacity = 1.0,
    String? name,
    Map<String, dynamic>? customProperties,
  }) {
    return DrawingToolEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      color: color,
      strokeWidth: strokeWidth,
      opacity: opacity,
      isActive: true,
      name: name ?? type.name,
      customProperties: customProperties,
    );
  }

  DrawingToolEntity copyWith({
    String? id,
    DrawingToolType? type,
    Color? color,
    double? strokeWidth,
    double? opacity,
    bool? isActive,
    String? name,
    Map<String, dynamic>? customProperties,
  }) {
    return DrawingToolEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      opacity: opacity ?? this.opacity,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      customProperties: customProperties ?? this.customProperties,
    );
  }

  DrawingToolEntity toggleActive() {
    return copyWith(isActive: !isActive);
  }

  DrawingToolEntity updateColor(Color newColor) {
    return copyWith(color: newColor);
  }

  DrawingToolEntity updateStrokeWidth(double newWidth) {
    return copyWith(strokeWidth: newWidth.clamp(1.0, 50.0));
  }

  DrawingToolEntity updateOpacity(double newOpacity) {
    return copyWith(opacity: newOpacity.clamp(0.0, 1.0));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrawingToolEntity &&
           other.id == id &&
           other.type == type &&
           other.color == color &&
           other.strokeWidth == strokeWidth &&
           other.opacity == opacity &&
           other.isActive == isActive &&
           other.name == name &&
           other.customProperties == customProperties;
  }

  @override
  int get hashCode {
    return id.hashCode ^
           type.hashCode ^
           color.hashCode ^
           strokeWidth.hashCode ^
           opacity.hashCode ^
           isActive.hashCode ^
           name.hashCode ^
           customProperties.hashCode;
  }

  @override
  String toString() {
    return 'DrawingToolEntity(id: $id, type: $type, color: $color, strokeWidth: $strokeWidth, opacity: $opacity, isActive: $isActive, name: $name, customProperties: $customProperties)';
  }
}
