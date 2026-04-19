import 'package:dartz/dartz.dart';
import '../entities/drawing_settings_entity.dart';
import '../repositories/drawing_controls_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetDrawingSettingsUseCase implements UseCase<DrawingSettingsEntity, NoParams> {
  final DrawingControlsRepository _repository;

  GetDrawingSettingsUseCase(this._repository);

  @override
  Future<Either<Failure, DrawingSettingsEntity>> call(NoParams params) async {
    return await _repository.getDrawingSettings();
  }
}
