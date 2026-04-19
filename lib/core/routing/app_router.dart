import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_strings.dart';
import '../theme/app_theme.dart';
import '../../features/image_picker/presentation/screens/home_screen.dart';
import '../../features/image_picker/presentation/screens/image_picker_screen.dart';
import '../../features/camera_overlay/presentation/screens/camera_overlay_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

// Placeholder routes - will be updated as we implement features
class AppRoutes {
  static const String home = '/';
  static const String imagePicker = '/image-picker';
  static const String cameraOverlay = '/camera-overlay';
  static const String settings = '/settings';
  
  // Helper method to create camera overlay route with image path
  static String cameraOverlayWithImage(String imagePath) {
    return '$cameraOverlay?imagePath=${Uri.encodeComponent(imagePath)}';
  }
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.imagePicker,
        name: AppRoutes.imagePicker,
        builder: (context, state) => const ImagePickerScreen(),
      ),
      GoRoute(
        path: AppRoutes.cameraOverlay,
        name: AppRoutes.cameraOverlay,
        builder: (context, state) {
          final imagePath = state.uri.queryParameters['imagePath'];
          return CameraOverlayScreen(imagePath: imagePath);
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
}


class ErrorScreen extends StatelessWidget {
  final Exception? error;
  
  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.error),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            const Text(
              AppStrings.somethingWentWrong,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text(AppStrings.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
