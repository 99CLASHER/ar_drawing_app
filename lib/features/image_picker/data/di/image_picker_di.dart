import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import '../datasources/image_local_datasource.dart';
import '../repositories/image_repository_impl.dart';
import '../../domain/repositories/image_repository.dart';
import '../../domain/usecases/pick_image_usecase.dart';
import '../../domain/usecases/get_gallery_images_usecase.dart';

final sl = GetIt.instance;

Future<void> initializeImagePickerDI() async {
  // External
  sl.registerLazySingleton(() => ImagePicker());

  // Data sources
  sl.registerLazySingleton<ImageLocalDataSource>(
    () => ImageLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ImageRepository>(
    () => ImageRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton<PickImageUseCase>(
    () => PickImageUseCase(sl()),
  );

  sl.registerLazySingleton<GetGalleryImagesUseCase>(
    () => GetGalleryImagesUseCase(sl()),
  );
}
