import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../datasources/drawing_controls_local_datasource.dart';
import '../repositories/drawing_controls_repository_impl.dart';
import '../../domain/repositories/drawing_controls_repository.dart';

Future<void> initializeDrawingControlsDI(GetIt getIt) async {
  // Register data sources
  getIt.registerLazySingleton<DrawingControlsLocalDataSource>(
    () => DrawingControlsLocalDataSourceImpl(getIt<SharedPreferences>()),
  );

  // Register repositories
  getIt.registerLazySingleton<DrawingControlsRepository>(
    () => DrawingControlsRepositoryImpl(getIt<DrawingControlsLocalDataSource>()),
  );
}
