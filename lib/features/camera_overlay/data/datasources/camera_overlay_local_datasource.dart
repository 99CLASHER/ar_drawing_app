import 'dart:async';
import 'package:hive/hive.dart';
import '../../domain/entities/camera_overlay_entity.dart';
import '../models/camera_overlay_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';

abstract class CameraOverlayLocalDataSource {
  Future<CameraOverlayEntity?> getOverlayState();
  Future<void> saveOverlayState(CameraOverlayEntity overlay);
  Future<void> resetOverlayState();
  Future<void> clearOverlay();
}

class CameraOverlayLocalDataSourceImpl implements CameraOverlayLocalDataSource {
  static const String _boxName = 'camera_overlay';
  static const String _overlayKey = 'current_overlay';

  Future<Box<CameraOverlayModel>> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<CameraOverlayModel>(_boxName);
    }
    
    final box = await Hive.openBox<CameraOverlayModel>(_boxName);
    AppLogger.info('Hive box opened successfully');
    return box;
  }

  @override
  Future<CameraOverlayEntity?> getOverlayState() async {
    try {
      final box = await _getBox();
      final overlayModel = box.get(_overlayKey);
      
      if (overlayModel == null) {
        AppLogger.info('No overlay found in Hive box');
        return null;
      }
      
      AppLogger.info('Loading overlay from Hive: ${overlayModel.imagePath}');
      return overlayModel.toEntity();
    } catch (e) {
      AppLogger.error('Failed to load overlay state from Hive', error: e);
      throw const CacheException('Failed to load overlay state');
    }
  }

  @override
  Future<void> saveOverlayState(CameraOverlayEntity overlay) async {
    try {
      final box = await _getBox();
      final overlayModel = CameraOverlayModel.fromEntity(overlay);
      
      AppLogger.info('Saving overlay to Hive: ${overlay.imagePath}');
      await box.put(_overlayKey, overlayModel);
      AppLogger.info('Overlay saved successfully to Hive');
    } catch (e) {
      AppLogger.error('Failed to save overlay state to Hive', error: e);
      throw const CacheException('Failed to save overlay state');
    }
  }

  @override
  Future<void> resetOverlayState() async {
    try {
      final box = await _getBox();
      await box.delete(_overlayKey);
    } catch (e) {
      throw const CacheException('Failed to reset overlay state');
    }
  }

  @override
  Future<void> clearOverlay() async {
    try {
      final box = await _getBox();
      await box.delete(_overlayKey);
    } catch (e) {
      throw const CacheException('Failed to clear overlay state');
    }
  }

  }
