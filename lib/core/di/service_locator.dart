import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';
import '../../features/image_picker/data/di/image_picker_di.dart';
import '../../features/camera_overlay/data/di/camera_overlay_di.dart';
import '../../features/drawing_controls/data/di/drawing_controls_di.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Initialize core services
  final getIt = GetIt.instance;
  
  // Note: SharedPreferences is now initialized in main.dart and injected through Riverpod
  // Do NOT register SharedPreferences here anymore
  
  // Register image picker dependencies
  await initializeImagePickerDI();
  
  // Register camera overlay dependencies
  await initializeCameraOverlayDependencies(getIt);
  
  // Register drawing controls dependencies
  await initializeDrawingControlsDI(getIt);
  
  // Core services will be registered here as we implement features
  
  // Example:
  // sl.registerLazySingleton<CameraService>(() => CameraService());
  // sl.registerLazySingleton<PermissionService>(() => PermissionService());
  
  // Repositories
  // sl.registerLazySingleton<CameraRepository>(() => CameraRepositoryImpl());
  
  // Use cases
  // sl.registerLazySingleton<GetCameraImageUseCase>(() => GetCameraImageUseCase());
  
  AppLogger.info('Dependency injection initialized');
}
