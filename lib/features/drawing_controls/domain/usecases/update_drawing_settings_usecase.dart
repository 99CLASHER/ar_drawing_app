import 'package:dartz/dartz.dart';
import '../entities/drawing_settings_entity.dart';
import '../repositories/drawing_controls_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateDrawingSettingsUseCase implements UseCase<DrawingSettingsEntity, DrawingSettingsEntity> {
  final DrawingControlsRepository _repository;

  UpdateDrawingSettingsUseCase(this._repository);

  @override
  Future<Either<Failure, DrawingSettingsEntity>> call(DrawingSettingsEntity settings) async {
    return await _repository.updateDrawingSettings(settings);
  }
}
