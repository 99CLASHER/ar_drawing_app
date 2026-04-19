import 'dart:ui';
import 'package:dartz/dartz.dart';
import '../entities/camera_overlay_entity.dart';
import '../../../../core/errors/failures.dart';

abstract class CameraOverlayRepository {
  Future<Either<Failure, CameraOverlayEntity>> getOverlayState();
  Future<Either<Failure, void>> updateOverlayState(CameraOverlayEntity overlay);
  Future<Either<Failure, void>> saveOverlayState(CameraOverlayEntity overlay);
  Future<Either<Failure, void>> resetOverlayState();
  Future<Either<Failure, void>> toggleOverlayVisibility();
  Future<Either<Failure, void>> updateOpacity(double opacity);
  Future<Either<Failure, void>> updateScale(double scale);
  Future<Either<Failure, void>> updatePosition(Offset position);
  Future<Either<Failure, void>> updateRotation(double rotation);
  Future<Either<Failure, void>> clearOverlay();
}
