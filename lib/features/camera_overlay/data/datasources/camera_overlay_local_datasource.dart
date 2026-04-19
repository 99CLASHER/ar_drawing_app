import 'dart:async';
import 'dart:ui';
import 'package:hive/hive.dart';
import '../../domain/entities/camera_overlay_entity.dart';
import '../models/camera_overlay_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class CameraOverlayLocalDataSource {
  Future<CameraOverlayEntity?> getOverlayState();
  Future<void> saveOverlayState(CameraOverlayEntity overlay);
  Future<void> resetOverlayState();
  Future<void> clearOverlay();
}

class CameraOverlayLocalDataSourceImpl implements CameraOverlayLocalDataSource {
  static const String _boxName = 'camera_overlay';

  CameraOverlayLocalDataSourceImpl();

  @override
  Future<CameraOverlayEntity?> getOverlayState() async {
    try {
      final box = await Hive.openBox<CameraOverlayModel>(_boxName);
      final overlayModel = box.get('current_overlay');
      
      if (overlayModel == null) return null;
      
      return overlayModel.toEntity();
    } catch (e) {
      throw const CacheException('Failed to load overlay state');
    }
  }

  @override
  Future<void> saveOverlayState(CameraOverlayEntity overlay) async {
    try {
      final box = await Hive.openBox<CameraOverlayModel>(_boxName);
      final overlayModel = CameraOverlayModel.fromEntity(overlay);
      
      await box.put('current_overlay', overlayModel);
    } catch (e) {
      throw const CacheException('Failed to save overlay state');
    }
  }

  @override
  Future<void> resetOverlayState() async {
    try {
      final box = await Hive.openBox<CameraOverlayModel>(_boxName);
      await box.delete('current_overlay');
    } catch (e) {
      throw const CacheException('Failed to reset overlay state');
    }
  }

  @override
  Future<void> clearOverlay() async {
    try {
      final box = await Hive.openBox<CameraOverlayModel>(_boxName);
      await box.delete('current_overlay');
    } catch (e) {
      throw const CacheException('Failed to clear overlay state');
    }
  }
}
