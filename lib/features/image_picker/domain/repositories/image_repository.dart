import 'package:dartz/dartz.dart';
import '../entities/image_entity.dart';
import '../entities/image_source.dart';
import '../../../../core/errors/failures.dart';

abstract class ImageRepository {
  /// Pick an image from the specified source
  Future<Either<Failure, ImageEntity>> pickImage(ImageSource source);
  
  /// Get all available images from gallery
  Future<Either<Failure, List<ImageEntity>>> getGalleryImages();
  
  /// Delete an image by path
  Future<Either<Failure, void>> deleteImage(String imagePath);
  
  /// Save an image to app storage
  Future<Either<Failure, String>> saveImage(String imagePath);
}
