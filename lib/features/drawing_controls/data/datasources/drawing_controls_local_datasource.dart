import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/drawing_tool_entity.dart';
import '../../domain/entities/drawing_settings_entity.dart';

abstract class DrawingControlsLocalDataSource {
  Future<List<DrawingToolEntity>> getDrawingTools();
  Future<DrawingToolEntity> updateDrawingTool(DrawingToolEntity tool);
  Future<DrawingToolEntity> selectDrawingTool(String toolId);
  Future<DrawingSettingsEntity> getDrawingSettings();
  Future<DrawingSettingsEntity> updateDrawingSettings(DrawingSettingsEntity settings);
  Future<void> resetToDefaults();
}

class DrawingControlsLocalDataSourceImpl implements DrawingControlsLocalDataSource {
  final SharedPreferences _prefs;
  static const String _toolsKey = 'drawing_tools';
  static const String _settingsKey = 'drawing_settings';
  static const String _selectedToolKey = 'selected_drawing_tool';

  DrawingControlsLocalDataSourceImpl(this._prefs);

  @override
  Future<List<DrawingToolEntity>> getDrawingTools() async {
    try {
      final toolsJson = _prefs.getString(_toolsKey);
      if (toolsJson == null) {
        return _getDefaultTools();
      }

      final List<dynamic> toolsList = json.decode(toolsJson);
      return toolsList.map((toolJson) => _toolFromJson(toolJson)).toList();
    } catch (e) {
      return _getDefaultTools();
    }
  }

  @override
  Future<DrawingToolEntity> updateDrawingTool(DrawingToolEntity tool) async {
    try {
      final tools = await getDrawingTools();
      final updatedTools = tools.map((t) => t.id == tool.id ? tool : t).toList();
      
      final toolsJson = json.encode(updatedTools.map((t) => _toolToJson(t)).toList());
      await _prefs.setString(_toolsKey, toolsJson);
      
      return tool;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DrawingToolEntity> selectDrawingTool(String toolId) async {
    try {
      final tools = await getDrawingTools();
      final updatedTools = tools.map((tool) => 
        tool.copyWith(isActive: tool.id == toolId)
      ).toList();
      
      final toolsJson = json.encode(updatedTools.map((t) => _toolToJson(t)).toList());
      await _prefs.setString(_toolsKey, toolsJson);
      await _prefs.setString(_selectedToolKey, toolId);
      
      return updatedTools.firstWhere((tool) => tool.id == toolId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DrawingSettingsEntity> getDrawingSettings() async {
    try {
      final settingsJson = _prefs.getString(_settingsKey);
      if (settingsJson == null) {
        return const DrawingSettingsEntity();
      }

      final settingsMap = json.decode(settingsJson);
      return _settingsFromJson(settingsMap);
    } catch (e) {
      return const DrawingSettingsEntity();
    }
  }

  @override
  Future<DrawingSettingsEntity> updateDrawingSettings(DrawingSettingsEntity settings) async {
    try {
      final settingsJson = json.encode(_settingsToJson(settings));
      await _prefs.setString(_settingsKey, settingsJson);
      return settings;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetToDefaults() async {
    await _prefs.remove(_toolsKey);
    await _prefs.remove(_settingsKey);
    await _prefs.remove(_selectedToolKey);
  }

  List<DrawingToolEntity> _getDefaultTools() {
    return [
      DrawingToolEntity.create(
        type: DrawingToolType.pen,
        color: const Color(0xFF000000),
        strokeWidth: 2.0,
        name: 'Pen',
      ),
      DrawingToolEntity.create(
        type: DrawingToolType.brush,
        color: const Color(0xFF0000FF),
        strokeWidth: 4.0,
        name: 'Brush',
      ),
      DrawingToolEntity.create(
        type: DrawingToolType.eraser,
        color: const Color(0xFFFFFFFF),
        strokeWidth: 10.0,
        name: 'Eraser',
      ),
      DrawingToolEntity.create(
        type: DrawingToolType.line,
        color: const Color(0xFFFF0000),
        strokeWidth: 2.0,
        name: 'Line',
      ),
      DrawingToolEntity.create(
        type: DrawingToolType.rectangle,
        color: const Color(0xFF00FF00),
        strokeWidth: 2.0,
        name: 'Rectangle',
      ),
      DrawingToolEntity.create(
        type: DrawingToolType.circle,
        color: const Color(0xFFFF00FF),
        strokeWidth: 2.0,
        name: 'Circle',
      ),
    ];
  }

  Map<String, dynamic> _toolToJson(DrawingToolEntity tool) {
    return {
      'id': tool.id,
      'type': tool.type.name,
      'color': tool.color.value,
      'strokeWidth': tool.strokeWidth,
      'opacity': tool.opacity,
      'isActive': tool.isActive,
      'name': tool.name,
      'customProperties': tool.customProperties,
    };
  }

  DrawingToolEntity _toolFromJson(Map<String, dynamic> json) {
    return DrawingToolEntity(
      id: json['id'],
      type: DrawingToolType.values.firstWhere((type) => type.name == json['type']),
      color: Color(json['color']),
      strokeWidth: json['strokeWidth'].toDouble(),
      opacity: json['opacity'].toDouble(),
      isActive: json['isActive'] ?? false,
      name: json['name'],
      customProperties: json['customProperties'],
    );
  }

  Map<String, dynamic> _settingsToJson(DrawingSettingsEntity settings) {
    return {
      'showGrid': settings.showGrid,
      'gridColor': settings.gridColor.value,
      'gridOpacity': settings.gridOpacity,
      'gridSize': settings.gridSize,
      'snapToGrid': settings.snapToGrid,
      'showRuler': settings.showRuler,
      'rulerColor': settings.rulerColor.value,
      'rulerOpacity': settings.rulerOpacity,
      'enableSmoothing': settings.enableSmoothing,
      'smoothingLevel': settings.smoothingLevel,
      'autoSave': settings.autoSave,
      'autoSaveInterval': settings.autoSaveInterval,
    };
  }

  DrawingSettingsEntity _settingsFromJson(Map<String, dynamic> json) {
    return DrawingSettingsEntity(
      showGrid: json['showGrid'] ?? false,
      gridColor: Color(json['gridColor'] ?? 0xFF808080),
      gridOpacity: (json['gridOpacity'] ?? 0.3).toDouble(),
      gridSize: (json['gridSize'] ?? 20.0).toDouble(),
      snapToGrid: json['snapToGrid'] ?? false,
      showRuler: json['showRuler'] ?? false,
      rulerColor: Color(json['rulerColor'] ?? 0xFF0000FF),
      rulerOpacity: (json['rulerOpacity'] ?? 0.5).toDouble(),
      enableSmoothing: json['enableSmoothing'] ?? true,
      smoothingLevel: (json['smoothingLevel'] ?? 0.5).toDouble(),
      autoSave: json['autoSave'] ?? true,
      autoSaveInterval: json['autoSaveInterval'] ?? 30,
    );
  }
}
