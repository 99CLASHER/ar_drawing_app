import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_entity.freezed.dart';

@freezed
class ImageEntity with _$ImageEntity {
  const factory ImageEntity({
    required String id,
    required String path,
    required String name,
    required int size,
    required DateTime createdAt,
    String? description,
  }) = _ImageEntity;
}
