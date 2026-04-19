import 'package:dartz/dartz.dart';
import '../entities/drawing_tool_entity.dart';
import '../repositories/drawing_controls_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetDrawingToolsUseCase implements UseCase<List<DrawingToolEntity>, NoParams> {
  final DrawingControlsRepository _repository;

  GetDrawingToolsUseCase(this._repository);

  @override
  Future<Either<Failure, List<DrawingToolEntity>>> call(NoParams params) async {
    return await _repository.getDrawingTools();
  }
}
