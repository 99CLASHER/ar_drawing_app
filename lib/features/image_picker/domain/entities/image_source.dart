enum ImageSource {
  gallery,
  camera,
}

extension ImageSourceExtension on ImageSource {
  String get displayName {
    switch (this) {
      case ImageSource.gallery:
        return 'Gallery';
      case ImageSource.camera:
        return 'Camera';
    }
  }
}
