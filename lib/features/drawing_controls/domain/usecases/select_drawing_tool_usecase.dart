import 'package:dartz/dartz.dart';
import '../entities/drawing_tool_entity.dart';
import '../repositories/drawing_controls_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class SelectDrawingToolUseCase implements UseCase<DrawingToolEntity, String> {
  final DrawingControlsRepository _repository;

  SelectDrawingToolUseCase(this._repository);

  @override
  Future<Either<Failure, DrawingToolEntity>> call(String toolId) async {
    return await _repository.selectDrawingTool(toolId);
  }
}
