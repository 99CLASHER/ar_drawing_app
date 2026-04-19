import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/image_picker/domain/entities/image_entity.dart';

class SelectedImageNotifier extends StateNotifier<ImageEntity?> {
  SelectedImageNotifier() : super(null);

  void selectImage(ImageEntity image) {
    state = image;
  }

  void clearImage() {
    state = null;
  }

  bool hasSelectedImage() {
    return state != null;
  }
}

// Provider for the selected image state
final selectedImageProvider = StateNotifierProvider<SelectedImageNotifier, ImageEntity?>((ref) {
  return SelectedImageNotifier();
});

// Provider to check if an image is selected
final hasSelectedImageProvider = Provider<bool>((ref) {
  return ref.watch(selectedImageProvider) != null;
});

// Provider to get the selected image path
final selectedImagePathProvider = Provider<String?>((ref) {
  return ref.watch(selectedImageProvider)?.path;
});
