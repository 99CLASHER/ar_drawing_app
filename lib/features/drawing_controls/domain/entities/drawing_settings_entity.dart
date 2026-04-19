import 'package:flutter/material.dart';

class DrawingSettingsEntity {
  final bool showGrid;
  final Color gridColor;
  final double gridOpacity;
  final double gridSize;
  final bool snapToGrid;
  final bool showRuler;
  final Color rulerColor;
  final double rulerOpacity;
  final bool enableSmoothing;
  final double smoothingLevel;
  final bool autoSave;
  final int autoSaveInterval;

  const DrawingSettingsEntity({
    this.showGrid = false,
    this.gridColor = Colors.grey,
    this.gridOpacity = 0.3,
    this.gridSize = 20.0,
    this.snapToGrid = false,
    this.showRuler = false,
    this.rulerColor = Colors.blue,
    this.rulerOpacity = 0.5,
    this.enableSmoothing = true,
    this.smoothingLevel = 0.5,
    this.autoSave = true,
    this.autoSaveInterval = 30,
  });

  DrawingSettingsEntity copyWith({
    bool? showGrid,
    Color? gridColor,
    double? gridOpacity,
    double? gridSize,
    bool? snapToGrid,
    bool? showRuler,
    Color? rulerColor,
    double? rulerOpacity,
    bool? enableSmoothing,
    double? smoothingLevel,
    bool? autoSave,
    int? autoSaveInterval,
  }) {
    return DrawingSettingsEntity(
      showGrid: showGrid ?? this.showGrid,
      gridColor: gridColor ?? this.gridColor,
      gridOpacity: gridOpacity ?? this.gridOpacity,
      gridSize: gridSize ?? this.gridSize,
      snapToGrid: snapToGrid ?? this.snapToGrid,
      showRuler: showRuler ?? this.showRuler,
      rulerColor: rulerColor ?? this.rulerColor,
      rulerOpacity: rulerOpacity ?? this.rulerOpacity,
      enableSmoothing: enableSmoothing ?? this.enableSmoothing,
      smoothingLevel: smoothingLevel ?? this.smoothingLevel,
      autoSave: autoSave ?? this.autoSave,
      autoSaveInterval: autoSaveInterval ?? this.autoSaveInterval,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrawingSettingsEntity &&
           other.showGrid == showGrid &&
           other.gridColor == gridColor &&
           other.gridOpacity == gridOpacity &&
           other.gridSize == gridSize &&
           other.snapToGrid == snapToGrid &&
           other.showRuler == showRuler &&
           other.rulerColor == rulerColor &&
           other.rulerOpacity == rulerOpacity &&
           other.enableSmoothing == enableSmoothing &&
           other.smoothingLevel == smoothingLevel &&
           other.autoSave == autoSave &&
           other.autoSaveInterval == autoSaveInterval;
  }

  @override
  int get hashCode {
    return showGrid.hashCode ^
           gridColor.hashCode ^
           gridOpacity.hashCode ^
           gridSize.hashCode ^
           snapToGrid.hashCode ^
           showRuler.hashCode ^
           rulerColor.hashCode ^
           rulerOpacity.hashCode ^
           enableSmoothing.hashCode ^
           smoothingLevel.hashCode ^
           autoSave.hashCode ^
           autoSaveInterval.hashCode;
  }

  @override
  String toString() {
    return 'DrawingSettingsEntity(showGrid: $showGrid, gridColor: $gridColor, gridOpacity: $gridOpacity, gridSize: $gridSize, snapToGrid: $snapToGrid, showRuler: $showRuler, rulerColor: $rulerColor, rulerOpacity: $rulerOpacity, enableSmoothing: $enableSmoothing, smoothingLevel: $smoothingLevel, autoSave: $autoSave, autoSaveInterval: $autoSaveInterval)';
  }
}
