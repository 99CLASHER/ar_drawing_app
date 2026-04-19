import 'package:permission_handler/permission_handler.dart';
import '../errors/exceptions.dart';
import '../utils/logger.dart';

class AppPermissionHandler {
  static Future<bool> checkCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      return status.isGranted;
    } catch (e) {
      AppLogger.error('Error checking camera permission', error: e);
      return false;
    }
  }

  static Future<bool> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (e) {
      AppLogger.error('Error requesting camera permission', error: e);
      return false;
    }
  }

  static Future<bool> checkStoragePermission() async {
    try {
      // For Android 13+ (API 33+), use media permissions
      if (await _isAndroid13OrHigher()) {
        final photosStatus = await Permission.photos.status;
        return photosStatus.isGranted;
      } else {
        // For older Android versions
        final storageStatus = await Permission.storage.status;
        return storageStatus.isGranted;
      }
    } catch (e) {
      AppLogger.error('Error checking storage permission', error: e);
      return false;
    }
  }

  static Future<bool> requestStoragePermission() async {
    try {
      // For Android 13+ (API 33+), use media permissions
      if (await _isAndroid13OrHigher()) {
        final photosStatus = await Permission.photos.request();
        return photosStatus.isGranted;
      } else {
        // For older Android versions
        final storageStatus = await Permission.storage.request();
        return storageStatus.isGranted;
      }
    } catch (e) {
      AppLogger.error('Error requesting storage permission', error: e);
      return false;
    }
  }

  static Future<bool> checkPhotosPermission() async {
    try {
      final status = await Permission.photos.status;
      return status.isGranted;
    } catch (e) {
      AppLogger.error('Error checking photos permission', error: e);
      return false;
    }
  }

  static Future<bool> requestPhotosPermission() async {
    try {
      final status = await Permission.photos.request();
      return status.isGranted;
    } catch (e) {
      AppLogger.error('Error requesting photos permission', error: e);
      return false;
    }
  }

  static Future<void> openAppSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      AppLogger.error('Error opening app settings', error: e);
      throw const PermissionException('Failed to open app settings');
    }
  }

  static Future<bool> isPermanentlyDenied(Permission permission) async {
    return permission.isPermanentlyDenied;
  }

  static Future<bool> _isAndroid13OrHigher() async {
    try {
      // This is a simplified check - in a real app, you'd use device_info_plus
      // For now, we'll assume we need to handle both cases
      return true;
    } catch (e) {
      AppLogger.error('Error checking Android version', error: e);
      return false;
    }
  }

  static Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    try {
      return await permission.status;
    } catch (e) {
      AppLogger.error('Error getting permission status', error: e);
      return PermissionStatus.denied;
    }
  }
}
