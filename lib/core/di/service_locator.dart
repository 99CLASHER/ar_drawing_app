import 'package:get_it/get_it.dart';
import '../utils/logger.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core services will be registered here as we implement features
  
  // Example:
  // sl.registerLazySingleton<CameraService>(() => CameraService());
  // sl.registerLazySingleton<ImagePickerService>(() => ImagePickerService());
  // sl.registerLazySingleton<PermissionService>(() => PermissionService());
  
  // Repositories
  // sl.registerLazySingleton<CameraRepository>(() => CameraRepositoryImpl());
  // sl.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl());
  
  // Use cases
  // sl.registerLazySingleton<GetCameraImageUseCase>(() => GetCameraImageUseCase());
  // sl.registerLazySingleton<PickImageUseCase>(() => PickImageUseCase());
  
  AppLogger.info('Dependency injection initialized');
}
