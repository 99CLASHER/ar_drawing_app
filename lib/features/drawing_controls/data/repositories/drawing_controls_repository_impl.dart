import 'package:dartz/dartz.dart';
import '../../domain/entities/drawing_tool_entity.dart';
import '../../domain/entities/drawing_settings_entity.dart';
import '../../domain/repositories/drawing_controls_repository.dart';
import '../datasources/drawing_controls_local_datasource.dart';
import '../../../../core/errors/failures.dart';

class DrawingControlsRepositoryImpl implements DrawingControlsRepository {
  final DrawingControlsLocalDataSource _dataSource;

  DrawingControlsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<DrawingToolEntity>>> getDrawingTools() async {
    try {
      final tools = await _dataSource.getDrawingTools();
      return Right(tools);
    } catch (e) {
      return Left(CacheFailure('Failed to get drawing tools: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, DrawingToolEntity>> updateDrawingTool(DrawingToolEntity tool) async {
    try {
      final updatedTool = await _dataSource.updateDrawingTool(tool);
      return Right(updatedTool);
    } catch (e) {
      return Left(CacheFailure('Failed to update drawing tool: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, DrawingToolEntity>> selectDrawingTool(String toolId) async {
    try {
      final selectedTool = await _dataSource.selectDrawingTool(toolId);
      return Right(selectedTool);
    } catch (e) {
      return Left(CacheFailure('Failed to select drawing tool: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, DrawingSettingsEntity>> getDrawingSettings() async {
    try {
      final settings = await _dataSource.getDrawingSettings();
      return Right(settings);
    } catch (e) {
      return Left(CacheFailure('Failed to get drawing settings: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, DrawingSettingsEntity>> updateDrawingSettings(DrawingSettingsEntity settings) async {
    try {
      final updatedSettings = await _dataSource.updateDrawingSettings(settings);
      return Right(updatedSettings);
    } catch (e) {
      return Left(CacheFailure('Failed to update drawing settings: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> resetToDefaults() async {
    try {
      await _dataSource.resetToDefaults();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to reset to defaults: ${e.toString()}'));
    }
  }
}
