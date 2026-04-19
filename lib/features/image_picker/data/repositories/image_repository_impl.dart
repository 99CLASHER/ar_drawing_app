import 'package:dartz/dartz.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/entities/image_source.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/image_local_datasource.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageLocalDataSource _dataSource;

  ImageRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, ImageEntity>> pickImage(ImageSource source) async {
    try {
      final image = await _dataSource.pickImageFromSource(source);
      return Right(image);
    } on ImagePickerException catch (e) {
      return Left(ImagePickerFailure(e.message, code: e.code));
    } on Exception catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ImageEntity>>> getGalleryImages() async {
    try {
      final images = await _dataSource.getGalleryImages();
      return Right(images);
    } on ImagePickerException catch (e) {
      return Left(ImagePickerFailure(e.message, code: e.code));
    } on Exception catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteImage(String imagePath) async {
    try {
      await _dataSource.deleteImage(imagePath);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message, code: e.code));
    } on Exception catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> saveImage(String imagePath) async {
    try {
      final savedPath = await _dataSource.saveImageToAppStorage(imagePath);
      return Right(savedPath);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message, code: e.code));
    } on Exception catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
