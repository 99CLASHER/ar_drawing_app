import 'package:get_it/get_it.dart';
import '../datasources/camera_overlay_local_datasource.dart';
import '../repositories/camera_overlay_repository_impl.dart';
import '../../domain/repositories/camera_overlay_repository.dart';
import '../../domain/usecases/get_overlay_state_usecase.dart';
import '../../domain/usecases/update_overlay_opacity_usecase.dart';
import '../../domain/usecases/update_overlay_scale_usecase.dart';
import '../../domain/usecases/toggle_overlay_visibility_usecase.dart';

Future<void> initializeCameraOverlayDependencies(GetIt sl) async {
  // Register data source
  sl.registerLazySingleton<CameraOverlayLocalDataSource>(
    CameraOverlayLocalDataSourceImpl.new,
  );

  // Register repository
  sl.registerLazySingleton<CameraOverlayRepository>(
    () => CameraOverlayRepositoryImpl.withDataSource(sl<CameraOverlayLocalDataSource>()),
  );

  // Register use cases
  sl.registerLazySingleton<GetOverlayStateUseCase>(
    () => GetOverlayStateUseCase(sl()),
  );

  sl.registerLazySingleton<UpdateOverlayOpacityUseCase>(
    () => UpdateOverlayOpacityUseCase(sl()),
  );

  sl.registerLazySingleton<UpdateOverlayScaleUseCase>(
    () => UpdateOverlayScaleUseCase(sl()),
  );

  sl.registerLazySingleton<ToggleOverlayVisibilityUseCase>(
    () => ToggleOverlayVisibilityUseCase(sl()),
  );
}
