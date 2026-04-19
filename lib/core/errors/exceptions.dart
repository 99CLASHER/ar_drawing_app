abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, {this.code});
  
  @override
  String toString() => 'AppException: $message';
}

class CameraException extends AppException {
  const CameraException(super.message, {super.code});
}

class ImagePickerException extends AppException {
  const ImagePickerException(super.message, {super.code});
}

class PermissionException extends AppException {
  const PermissionException(super.message, {super.code});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

class StorageException extends AppException {
  const StorageException(super.message, {super.code});
}

class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}
