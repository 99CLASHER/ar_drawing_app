import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/di/service_locator.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await initializeDependencies();
    AppLogger.info('Application initialization completed');
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize application', error: e, stackTrace: stackTrace);
  }
  
  runApp(
    const ProviderScope(
      child: ARDrawingApp(),
    ),
  );
}

class ARDrawingApp extends ConsumerWidget {
  const ARDrawingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration
      theme: AppTheme.lightTheme,
      
      // Router Configuration
      routerConfig: AppRouter.router,
      
      // Builder for additional configurations
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling, // Prevent text scaling issues
          ),
          child: child!,
        );
      },
    );
  }
}
