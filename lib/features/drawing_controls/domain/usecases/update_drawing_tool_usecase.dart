import 'package:dartz/dartz.dart';
import '../entities/drawing_tool_entity.dart';
import '../repositories/drawing_controls_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateDrawingToolUseCase implements UseCase<DrawingToolEntity, DrawingToolEntity> {
  final DrawingControlsRepository _repository;

  UpdateDrawingToolUseCase(this._repository);

  @override
  Future<Either<Failure, DrawingToolEntity>> call(DrawingToolEntity tool) async {
    return await _repository.updateDrawingTool(tool);
  }
}
