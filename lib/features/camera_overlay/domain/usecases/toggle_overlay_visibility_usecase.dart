import 'package:dartz/dartz.dart';
import '../repositories/camera_overlay_repository.dart';
import '../../../../core/errors/failures.dart';

class ToggleOverlayVisibilityUseCase {
  final CameraOverlayRepository _repository;

  ToggleOverlayVisibilityUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.toggleOverlayVisibility();
  }
}
