import 'dart:io';
import 'package:image_picker/image_picker.dart' as image_picker_pkg;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/entities/image_source.dart';
import '../../../../core/errors/exceptions.dart';

abstract class ImageLocalDataSource {
  Future<ImageEntity> pickImageFromSource(ImageSource source);
  Future<List<ImageEntity>> getGalleryImages();
  Future<void> deleteImage(String imagePath);
  Future<String> saveImageToAppStorage(String imagePath);
}

class ImageLocalDataSourceImpl implements ImageLocalDataSource {
  final image_picker_pkg.ImagePicker _imagePicker;

  ImageLocalDataSourceImpl(this._imagePicker);

  @override
  Future<ImageEntity> pickImageFromSource(ImageSource source) async {
    try {
      final pickerSource = source == ImageSource.camera 
          ? image_picker_pkg.ImageSource.camera 
          : image_picker_pkg.ImageSource.gallery;

      final pickedFile = await _imagePicker.pickImage(
        source: pickerSource,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        throw const ImagePickerException('No image selected');
      }

      final file = File(pickedFile.path);
      final fileSize = await file.length();
      final fileName = path.basename(pickedFile.path);

      return ImageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        path: pickedFile.path,
        name: fileName,
        size: fileSize,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      if (e is ImagePickerException) {
        rethrow;
      }
      throw ImagePickerException('Failed to pick image: ${e.toString()}');
    }
  }

  @override
  Future<List<ImageEntity>> getGalleryImages() async {
    try {
      // For now, return empty list as we'll implement gallery browsing later
      // In a real app, you might use photo_manager or similar package
      return [];
    } catch (e) {
      throw ImagePickerException('Failed to get gallery images: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw StorageException('Failed to delete image: ${e.toString()}');
    }
  }

  @override
  Future<String> saveImageToAppStorage(String imagePath) async {
    try {
      final originalFile = File(imagePath);
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/images');
      
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final fileName = path.basename(imagePath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newFileName = '${timestamp}_$fileName';
      final newPath = path.join(imagesDir.path, newFileName);

      final newFile = await originalFile.copy(newPath);
      return newFile.path;
    } catch (e) {
      throw StorageException('Failed to save image: ${e.toString()}');
    }
  }
}
