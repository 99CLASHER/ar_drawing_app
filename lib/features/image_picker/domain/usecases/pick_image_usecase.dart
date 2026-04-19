import 'package:dartz/dartz.dart';
import '../entities/image_entity.dart';
import '../entities/image_source.dart';
import '../repositories/image_repository.dart';
import '../../../../core/errors/failures.dart';

class PickImageUseCase {
  final ImageRepository _repository;

  PickImageUseCase(this._repository);

  Future<Either<Failure, ImageEntity>> call(ImageSource source) {
    return _repository.pickImage(source);
  }
}
