import 'package:dartz/dartz.dart';
import '../entities/camera_overlay_entity.dart';
import '../repositories/camera_overlay_repository.dart';
import '../../../../core/errors/failures.dart';

class GetOverlayStateUseCase {
  final CameraOverlayRepository _repository;

  GetOverlayStateUseCase(this._repository);

  Future<Either<Failure, CameraOverlayEntity>> call() async {
    return await _repository.getOverlayState();
  }
}
