import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/drawing_tool_entity.dart';
import '../../domain/entities/drawing_settings_entity.dart';
import '../../domain/repositories/drawing_controls_repository.dart';
import '../../domain/usecases/get_drawing_tools_usecase.dart';
import '../../domain/usecases/update_drawing_tool_usecase.dart';
import '../../domain/usecases/select_drawing_tool_usecase.dart';
import '../../domain/usecases/get_drawing_settings_usecase.dart';
import '../../domain/usecases/update_drawing_settings_usecase.dart';
import '../../data/datasources/drawing_controls_local_datasource.dart';
import '../../data/repositories/drawing_controls_repository_impl.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/providers/shared_preferences_provider.dart';

class DrawingControlsState {
  final bool isLoading;
  final List<DrawingToolEntity> drawingTools;
  final DrawingToolEntity? selectedTool;
  final DrawingSettingsEntity settings;
  final String? errorMessage;

  const DrawingControlsState({
    this.isLoading = false,
    this.drawingTools = const [],
    this.selectedTool,
    this.settings = const DrawingSettingsEntity(),
    this.errorMessage,
  });

  DrawingControlsState copyWith({
    bool? isLoading,
    List<DrawingToolEntity>? drawingTools,
    DrawingToolEntity? selectedTool,
    DrawingSettingsEntity? settings,
    String? errorMessage,
  }) {
    return DrawingControlsState(
      isLoading: isLoading ?? this.isLoading,
      drawingTools: drawingTools ?? this.drawingTools,
      selectedTool: selectedTool ?? this.selectedTool,
      settings: settings ?? this.settings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DrawingControlsNotifier extends StateNotifier<DrawingControlsState> {
  late final GetDrawingToolsUseCase _getDrawingToolsUseCase;
  late final UpdateDrawingToolUseCase _updateDrawingToolUseCase;
  late final SelectDrawingToolUseCase _selectDrawingToolUseCase;
  late final GetDrawingSettingsUseCase _getDrawingSettingsUseCase;
  late final UpdateDrawingSettingsUseCase _updateDrawingSettingsUseCase;

  DrawingControlsNotifier() : super(const DrawingControlsState()) {
    _initializeDrawingControls();
  }

  Future<void> _initializeDrawingControls() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final toolsResult = await _getDrawingToolsUseCase(const NoParams());
      final settingsResult = await _getDrawingSettingsUseCase(const NoParams());
      
      toolsResult.fold(
        (failure) {
          AppLogger.error('Failed to load drawing tools', error: failure.message);
          state = state.copyWith(isLoading: false, errorMessage: failure.message);
        },
        (tools) {
          final selectedTool = tools.where((tool) => tool.isActive).firstOrNull;
          
          settingsResult.fold(
            (failure) {
              AppLogger.error('Failed to load drawing settings', error: failure.message);
              state = state.copyWith(
                isLoading: false,
                drawingTools: tools,
                selectedTool: selectedTool,
                errorMessage: failure.message,
              );
            },
            (settings) {
              state = state.copyWith(
                isLoading: false,
                drawingTools: tools,
                selectedTool: selectedTool,
                settings: settings,
              );
              AppLogger.info('Drawing controls initialized successfully');
            },
          );
        },
      );
    } catch (e) {
      AppLogger.error('Failed to initialize drawing controls', error: e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to initialize drawing controls: ${e.toString()}',
      );
    }
  }

  Future<void> selectTool(String toolId) async {
    state = state.copyWith(isLoading: true);
    
    final result = await _selectDrawingToolUseCase(toolId);
    
    result.fold(
      (failure) {
        AppLogger.error('Failed to select drawing tool', error: failure.message);
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (selectedTool) {
        final updatedTools = state.drawingTools.map((tool) => 
          tool.copyWith(isActive: tool.id == toolId)
        ).toList();
        
        state = state.copyWith(
          isLoading: false,
          drawingTools: updatedTools,
          selectedTool: selectedTool,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> updateTool(DrawingToolEntity tool) async {
    state = state.copyWith(isLoading: true);
    
    final result = await _updateDrawingToolUseCase(tool);
    
    result.fold(
      (failure) {
        AppLogger.error('Failed to update drawing tool', error: failure.message);
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (updatedTool) {
        final updatedTools = state.drawingTools.map((t) => 
          t.id == updatedTool.id ? updatedTool : t
        ).toList();
        
        state = state.copyWith(
          isLoading: false,
          drawingTools: updatedTools,
          selectedTool: state.selectedTool?.id == updatedTool.id ? updatedTool : state.selectedTool,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> updateSettings(DrawingSettingsEntity settings) async {
    state = state.copyWith(isLoading: true);
    
    final result = await _updateDrawingSettingsUseCase(settings);
    
    result.fold(
      (failure) {
        AppLogger.error('Failed to update drawing settings', error: failure.message);
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (updatedSettings) {
        state = state.copyWith(
          isLoading: false,
          settings: updatedSettings,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> clearError() async {
    state = state.copyWith(errorMessage: null);
  }
}

// Providers
final getDrawingToolsUseCase = Provider<GetDrawingToolsUseCase>((ref) {
  return GetDrawingToolsUseCase(ref.read(drawingControlsRepositoryProvider));
});

final updateDrawingToolUseCase = Provider<UpdateDrawingToolUseCase>((ref) {
  return UpdateDrawingToolUseCase(ref.read(drawingControlsRepositoryProvider));
});

final selectDrawingToolUseCase = Provider<SelectDrawingToolUseCase>((ref) {
  return SelectDrawingToolUseCase(ref.read(drawingControlsRepositoryProvider));
});

final getDrawingSettingsUseCase = Provider<GetDrawingSettingsUseCase>((ref) {
  return GetDrawingSettingsUseCase(ref.read(drawingControlsRepositoryProvider));
});

final updateDrawingSettingsUseCase = Provider<UpdateDrawingSettingsUseCase>((ref) {
  return UpdateDrawingSettingsUseCase(ref.read(drawingControlsRepositoryProvider));
});

final drawingControlsRepositoryProvider = Provider<DrawingControlsRepository>((ref) {
  return DrawingControlsRepositoryImpl(ref.read(drawingControlsDataSourceProvider));
});

final drawingControlsDataSourceProvider = Provider<DrawingControlsLocalDataSource>((ref) {
  return DrawingControlsLocalDataSourceImpl(ref.read(sharedPreferencesProvider));
});

final drawingControlsProvider = StateNotifierProvider<DrawingControlsNotifier, DrawingControlsState>((ref) {
  return DrawingControlsNotifier();
});
