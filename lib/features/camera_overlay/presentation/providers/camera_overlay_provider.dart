import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/camera_overlay_entity.dart';
import '../../domain/repositories/camera_overlay_repository.dart';
import '../../domain/usecases/get_overlay_state_usecase.dart';
import '../../domain/usecases/update_overlay_opacity_usecase.dart';
import '../../domain/usecases/update_overlay_scale_usecase.dart';
import '../../domain/usecases/toggle_overlay_visibility_usecase.dart';
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

  CameraOverlayNotifier(
    this._getOverlayStateUseCase,
    this._updateOpacityUseCase,
    this._updateScaleUseCase,
    this._toggleVisibilityUseCase,
  ) : super(const CameraOverlayState()) {
    _initializeOverlay();
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
        AppLogger.info('Overlay state loaded successfully');
      },
    );
  }

  Future<void> updateOpacity(double opacity) async {
    state = state.copyWith(isLoading: true);
    
    final result = await _updateOpacityUseCase(opacity);
    
    result.fold(
      (failure) {
        AppLogger.error('Failed to update opacity', error: failure.message);
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (_) {
        if (state.overlay != null) {
          final updatedOverlay = state.overlay!.copyWithUpdatedOpacity(opacity);
          state = state.copyWith(isLoading: false, overlay: updatedOverlay);
        }
      },
    );
  }

  Future<void> updateScale(double scale) async {
    state = state.copyWith(isLoading: true);
    
    final result = await _updateScaleUseCase(scale);
    
    result.fold(
      (failure) {
        AppLogger.error('Failed to update scale', error: failure.message);
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (_) {
        if (state.overlay != null) {
          final updatedOverlay = state.overlay!.copyWithUpdatedScale(scale);
          state = state.copyWith(isLoading: false, overlay: updatedOverlay);
        }
      },
    );
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

  void setOverlay(CameraOverlayEntity overlay) {
    state = state.copyWith(overlay: overlay);
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
  );
});
