import 'package:dartz/dartz.dart';
import '../repositories/camera_overlay_repository.dart';
import '../../../../core/errors/failures.dart';

class UpdateOverlayOpacityUseCase {
  final CameraOverlayRepository _repository;

  UpdateOverlayOpacityUseCase(this._repository);

  Future<Either<Failure, void>> call(double opacity) async {
    return await _repository.updateOpacity(opacity);
  }
}
