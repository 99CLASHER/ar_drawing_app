import 'package:dartz/dartz.dart';
import '../repositories/camera_overlay_repository.dart';
import '../../../../core/errors/failures.dart';

class UpdateOverlayScaleUseCase {
  final CameraOverlayRepository _repository;

  UpdateOverlayScaleUseCase(this._repository);

  Future<Either<Failure, void>> call(double scale) async {
    return await _repository.updateScale(scale);
  }
}
