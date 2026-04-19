import 'package:dartz/dartz.dart';
import 'dart:ui';
import '../../domain/entities/camera_overlay_entity.dart';
import '../../domain/repositories/camera_overlay_repository.dart';
import '../datasources/camera_overlay_local_datasource.dart';
import '../../../../core/errors/failures.dart';

class CameraOverlayRepositoryImpl implements CameraOverlayRepository {
  final CameraOverlayLocalDataSource _dataSource;

  CameraOverlayRepositoryImpl(this._dataSource);
  CameraOverlayRepositoryImpl.withDataSource(CameraOverlayLocalDataSource dataSource) : _dataSource = dataSource;

  @override
  Future<Either<Failure, CameraOverlayEntity>> getOverlayState() async {
    try {
      final overlay = await _dataSource.getOverlayState();
      
      if (overlay == null) {
        return left(const CacheFailure('No overlay state found'));
      }
      
      return right(overlay);
    } catch (e) {
      return left(CacheFailure('Failed to load overlay state: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateOverlayState(CameraOverlayEntity overlay) async {
    try {
      await _dataSource.saveOverlayState(overlay);
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to update overlay state: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveOverlayState(CameraOverlayEntity overlay) async {
    try {
      await _dataSource.saveOverlayState(overlay);
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to save overlay state: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> resetOverlayState() async {
    try {
      await _dataSource.resetOverlayState();
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to reset overlay state: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleOverlayVisibility() async {
    try {
      final currentOverlay = await _dataSource.getOverlayState();
      
      if (currentOverlay == null) {
        return left(const CacheFailure('No overlay state found'));
      }
      
      final updatedOverlay = currentOverlay.toggleVisibility();
      await _dataSource.saveOverlayState(updatedOverlay);
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to toggle overlay visibility: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateOpacity(double opacity) async {
    try {
      final currentOverlay = await _dataSource.getOverlayState();
      
      if (currentOverlay == null) {
        return left(const CacheFailure('No overlay state found'));
      }
      
      final updatedOverlay = currentOverlay.copyWithUpdatedOpacity(opacity);
      await _dataSource.saveOverlayState(updatedOverlay);
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to update opacity: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateScale(double scale) async {
    try {
      final currentOverlay = await _dataSource.getOverlayState();
      
      if (currentOverlay == null) {
        return left(const CacheFailure('No overlay state found'));
      }
      
      final updatedOverlay = currentOverlay.copyWithUpdatedScale(scale);
      await _dataSource.saveOverlayState(updatedOverlay);
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to update scale: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePosition(Offset position) async {
    try {
      final currentOverlay = await _dataSource.getOverlayState();
      
      if (currentOverlay == null) {
        return left(const CacheFailure('No overlay state found'));
      }
      
      final updatedOverlay = currentOverlay.copyWithUpdatedPosition(position);
      await _dataSource.saveOverlayState(updatedOverlay);
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to update position: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateRotation(double rotation) async {
    try {
      final currentOverlay = await _dataSource.getOverlayState();
      
      if (currentOverlay == null) {
        return left(const CacheFailure('No overlay state found'));
      }
      
      final updatedOverlay = currentOverlay.copyWithUpdatedRotation(rotation);
      await _dataSource.saveOverlayState(updatedOverlay);
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to update rotation: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearOverlay() async {
    try {
      await _dataSource.clearOverlay();
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to clear overlay: ${e.toString()}'));
    }
  }
}
