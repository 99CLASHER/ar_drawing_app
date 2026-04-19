import 'package:dartz/dartz.dart';
import '../entities/drawing_tool_entity.dart';
import '../entities/drawing_settings_entity.dart';
import '../../../../core/errors/failures.dart';

abstract class DrawingControlsRepository {
  Future<Either<Failure, List<DrawingToolEntity>>> getDrawingTools();
  Future<Either<Failure, DrawingToolEntity>> updateDrawingTool(DrawingToolEntity tool);
  Future<Either<Failure, DrawingToolEntity>> selectDrawingTool(String toolId);
  Future<Either<Failure, DrawingSettingsEntity>> getDrawingSettings();
  Future<Either<Failure, DrawingSettingsEntity>> updateDrawingSettings(DrawingSettingsEntity settings);
  Future<Either<Failure, void>> resetToDefaults();
}
