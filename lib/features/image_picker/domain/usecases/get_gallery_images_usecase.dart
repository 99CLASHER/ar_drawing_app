import 'package:dartz/dartz.dart';
import '../entities/image_entity.dart';
import '../repositories/image_repository.dart';
import '../../../../core/errors/failures.dart';

class GetGalleryImagesUseCase {
  final ImageRepository _repository;

  GetGalleryImagesUseCase(this._repository);

  Future<Either<Failure, List<ImageEntity>>> call() {
    return _repository.getGalleryImages();
  }
}
