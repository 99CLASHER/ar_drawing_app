import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/camera_overlay_entity.dart';
import '../../domain/repositories/camera_overlay_repository.dart';
import '../../domain/usecases/get_overlay_state_usecase.dart';
import '../../domain/usecases/update_overlay_opacity_usecase.dart';
import '../../domain/usecases/update_overlay_scale_usecase.dart';
import '../../domain/usecases/toggle_overlay_visibility_usecase.dart';
import '../../domain/usecases/save_overlay_usecase.dart';
import '../../data/datasources/camera_overlay_local_datasource.dart';
import '../../data/repositories/camera_overlay_repository_impl.dart';
import '../../../../core/utils/logger.dart';

class CameraOverlayState {
  final bool isLoading;
  final CameraOverlayEntity? overlay;
  final String? errorMessage;

  const CameraOverlayState({
    this.isLoading = false,
    this.overlay,
    this.errorMessage,
  });

  CameraOverlayState copyWith({
    bool? isLoading,
    CameraOverlayEntity? overlay,
    String? errorMessage,
  }) {
    return CameraOverlayState(
      isLoading: isLoading ?? this.isLoading,
      overlay: overlay ?? this.overlay,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CameraOverlayNotifier extends StateNotifier<CameraOverlayState> {
  final GetOverlayStateUseCase _getOverlayStateUseCase;
  final UpdateOverlayOpacityUseCase _updateOpacityUseCase;
  final UpdateOverlayScaleUseCase _updateScaleUseCase;
  final ToggleOverlayVisibilityUseCase _toggleVisibilityUseCase;
  final SaveOverlayUseCase _saveOverlayUseCase;

  CameraOverlayNotifier(
    this._getOverlayStateUseCase,
    this._updateOpacityUseCase,
    this._updateScaleUseCase,
    this._toggleVisibilityUseCase,
    this._saveOverlayUseCase,
  ) : super(const CameraOverlayState());

  Future<void> init() async {
    await _initializeOverlay();
  }

  Future<void> _initializeOverlay() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final result = await _getOverlayStateUseCase();
    
    result.fold(
      (failure) {
        AppLogger.error('Failed to load overlay state', error: failure.message);
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (overlay) {
        state = state.copyWith(isLoading: false, overlay: overlay);
        AppLogger.info('Overlay state loaded successfully: ${overlay.imagePath}');
      },
    );
  }

  Future<void> updateOpacity(double opacity) async {
    // Optimistic update: apply immediately so the slider feels live
    if (state.overlay != null) {
      final updatedOverlay = state.overlay!.copyWithUpdatedOpacity(opacity);
      state = state.copyWith(overlay: updatedOverlay);
    }

    // Persist in the background (no loading spinner)
    final result = await _updateOpacityUseCase(opacity);
    result.fold(
      (failure) {
        AppLogger.error('Failed to persist opacity', error: failure.message);
      },
      (_) {},
    );
  }

  /// Updates opacity in-memory only (instant, no I/O). Call this during live slider drag.
  void updateOpacityInMemory(double opacity) {
    if (state.overlay != null) {
      state = state.copyWith(overlay: state.overlay!.copyWithUpdatedOpacity(opacity));
    }
  }

  Future<void> updateScale(double scale) async {
    // Optimistic update: apply immediately so the slider feels live
    if (state.overlay != null) {
      final updatedOverlay = state.overlay!.copyWithUpdatedScale(scale);
      state = state.copyWith(overlay: updatedOverlay);
    }

    // Persist in the background (no loading spinner)
    final result = await _updateScaleUseCase(scale);
    result.fold(
      (failure) {
        AppLogger.error('Failed to persist scale', error: failure.message);
      },
      (_) {},
    );
  }

  /// Updates scale in-memory only (instant, no I/O). Call this during live slider drag.
  void updateScaleInMemory(double scale) {
    if (state.overlay != null) {
      state = state.copyWith(overlay: state.overlay!.copyWithUpdatedScale(scale));
    }
  }

  Future<void> toggleVisibility() async {
    state = state.copyWith(isLoading: true);
    
    final result = await _toggleVisibilityUseCase();
    
    result.fold(
      (failure) {
        AppLogger.error('Failed to toggle visibility', error: failure.message);
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (_) {
        if (state.overlay != null) {
          final updatedOverlay = state.overlay!.toggleVisibility();
          state = state.copyWith(isLoading: false, overlay: updatedOverlay);
        }
      },
    );
  }

  Future<void> clearError() async {
    state = state.copyWith(errorMessage: null);
  }

  void clearOverlay() {
    state = state.copyWith(overlay: null);
  }

  Future<void> setOverlay(CameraOverlayEntity overlay) async {
    AppLogger.info('Setting overlay: ${overlay.imagePath}');
    state = state.copyWith(overlay: overlay);
    
    // Also save to repository to persist the overlay
    final result = await _saveOverlayUseCase(overlay);
    result.fold(
      (failure) {
        AppLogger.error('Failed to save overlay', error: failure.message);
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        AppLogger.info('Overlay saved successfully to Hive');
      },
    );
  }
}

// Providers
final getOverlayStateUseCase = Provider<GetOverlayStateUseCase>((ref) {
  return GetOverlayStateUseCase(ref.read(cameraOverlayRepositoryProvider));
});

final updateOverlayOpacityUseCase = Provider<UpdateOverlayOpacityUseCase>((ref) {
  return UpdateOverlayOpacityUseCase(ref.read(cameraOverlayRepositoryProvider));
});

final updateOverlayScaleUseCase = Provider<UpdateOverlayScaleUseCase>((ref) {
  return UpdateOverlayScaleUseCase(ref.read(cameraOverlayRepositoryProvider));
});

final toggleOverlayVisibilityUseCase = Provider<ToggleOverlayVisibilityUseCase>((ref) {
  return ToggleOverlayVisibilityUseCase(ref.read(cameraOverlayRepositoryProvider));
});

final saveOverlayUseCase = Provider<SaveOverlayUseCase>((ref) {
  return SaveOverlayUseCase(ref.read(cameraOverlayRepositoryProvider));
});

final cameraOverlayRepositoryProvider = Provider<CameraOverlayRepository>((ref) {
  return CameraOverlayRepositoryImpl(ref.read(cameraOverlayDataSourceProvider));
});

final cameraOverlayDataSourceProvider = Provider<CameraOverlayLocalDataSource>((ref) {
  return CameraOverlayLocalDataSourceImpl();
});


final cameraOverlayProvider = StateNotifierProvider<CameraOverlayNotifier, CameraOverlayState>((ref) {
  return CameraOverlayNotifier(
    ref.read(getOverlayStateUseCase),
    ref.read(updateOverlayOpacityUseCase),
    ref.read(updateOverlayScaleUseCase),
    ref.read(toggleOverlayVisibilityUseCase),
    ref.read(saveOverlayUseCase),
  );
});
