import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/entities/image_source.dart';
import '../../domain/usecases/pick_image_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../../../shared/providers/selected_image_provider.dart';
import 'get_it_provider.dart';

class ImagePickerState {
  final bool isLoading;
  final ImageEntity? selectedImage;
  final String? errorMessage;
  final bool hasPermission;

  const ImagePickerState({
    this.isLoading = false,
    this.selectedImage,
    this.errorMessage,
    this.hasPermission = true,
  });

  ImagePickerState copyWith({
    bool? isLoading,
    ImageEntity? selectedImage,
    String? errorMessage,
    bool? hasPermission,
  }) {
    return ImagePickerState(
      isLoading: isLoading ?? this.isLoading,
      selectedImage: selectedImage ?? this.selectedImage,
      errorMessage: errorMessage,
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }
}

class ImagePickerNotifier extends StateNotifier<ImagePickerState> {
  final PickImageUseCase _pickImageUseCase;
  final Ref _ref;

  ImagePickerNotifier(this._pickImageUseCase, this._ref) : super(const ImagePickerState());

  Future<void> pickImage(ImageSource source) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _pickImageUseCase(source);
      
      result.fold(
        (failure) {
          AppLogger.error('Failed to pick image', error: failure.message);
          state = state.copyWith(
            isLoading: false,
            errorMessage: _mapFailureToMessage(failure),
          );
        },
        (image) {
          AppLogger.info('Image picked successfully: ${image.name}');
          state = state.copyWith(
            isLoading: false,
            selectedImage: image,
          );
          // Also update the shared selected image provider
          _ref.read(selectedImageProvider.notifier).selectImage(image);
        },
      );
    } catch (e) {
      AppLogger.error('Unexpected error picking image', error: e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSelectedImage() {
    state = state.copyWith(selectedImage: null);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ImagePickerFailure _:
        return 'Failed to pick image. Please try again.';
      case PermissionFailure _:
        return 'Permission denied. Please grant camera/storage permissions.';
      case StorageFailure _:
        return 'Storage error. Please check your device storage.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}

// Provider
final imagePickerProvider = StateNotifierProvider<ImagePickerNotifier, ImagePickerState>((ref) {
  return ImagePickerNotifier(ref.watch(pickImageUseCaseProvider), ref);
});

// Use case provider
final pickImageUseCaseProvider = Provider<PickImageUseCase>((ref) {
  return ref.watch(getItProvider).get<PickImageUseCase>();
});

// GetIt provider
final getItProvider = Provider((ref) => ref.watch(getItInstanceProvider));
