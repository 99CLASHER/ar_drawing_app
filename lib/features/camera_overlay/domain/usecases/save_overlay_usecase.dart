import 'package:dartz/dartz.dart';
import '../entities/camera_overlay_entity.dart';
import '../repositories/camera_overlay_repository.dart';
import '../../../../core/errors/failures.dart';

class SaveOverlayUseCase {
  final CameraOverlayRepository _repository;

  SaveOverlayUseCase(this._repository);

  Future<Either<Failure, void>> call(CameraOverlayEntity overlay) async {
    return await _repository.saveOverlayState(overlay);
  }
}
