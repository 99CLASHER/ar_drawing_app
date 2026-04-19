// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ImageEntity {
  String get id => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ImageEntityCopyWith<ImageEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageEntityCopyWith<$Res> {
  factory $ImageEntityCopyWith(
          ImageEntity value, $Res Function(ImageEntity) then) =
      _$ImageEntityCopyWithImpl<$Res, ImageEntity>;
  @useResult
  $Res call(
      {String id,
      String path,
      String name,
      int size,
      DateTime createdAt,
      String? description});
}

/// @nodoc
class _$ImageEntityCopyWithImpl<$Res, $Val extends ImageEntity>
    implements $ImageEntityCopyWith<$Res> {
  _$ImageEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? name = null,
    Object? size = null,
    Object? createdAt = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImageEntityImplCopyWith<$Res>
    implements $ImageEntityCopyWith<$Res> {
  factory _$$ImageEntityImplCopyWith(
          _$ImageEntityImpl value, $Res Function(_$ImageEntityImpl) then) =
      __$$ImageEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String path,
      String name,
      int size,
      DateTime createdAt,
      String? description});
}

/// @nodoc
class __$$ImageEntityImplCopyWithImpl<$Res>
    extends _$ImageEntityCopyWithImpl<$Res, _$ImageEntityImpl>
    implements _$$ImageEntityImplCopyWith<$Res> {
  __$$ImageEntityImplCopyWithImpl(
      _$ImageEntityImpl _value, $Res Function(_$ImageEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? name = null,
    Object? size = null,
    Object? createdAt = null,
    Object? description = freezed,
  }) {
    return _then(_$ImageEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ImageEntityImpl implements _ImageEntity {
  const _$ImageEntityImpl(
      {required this.id,
      required this.path,
      required this.name,
      required this.size,
      required this.createdAt,
      this.description});

  @override
  final String id;
  @override
  final String path;
  @override
  final String name;
  @override
  final int size;
  @override
  final DateTime createdAt;
  @override
  final String? description;

  @override
  String toString() {
    return 'ImageEntity(id: $id, path: $path, name: $name, size: $size, createdAt: $createdAt, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, path, name, size, createdAt, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageEntityImplCopyWith<_$ImageEntityImpl> get copyWith =>
      __$$ImageEntityImplCopyWithImpl<_$ImageEntityImpl>(this, _$identity);
}

abstract class _ImageEntity implements ImageEntity {
  const factory _ImageEntity(
      {required final String id,
      required final String path,
      required final String name,
      required final int size,
      required final DateTime createdAt,
      final String? description}) = _$ImageEntityImpl;

  @override
  String get id;
  @override
  String get path;
  @override
  String get name;
  @override
  int get size;
  @override
  DateTime get createdAt;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$ImageEntityImplCopyWith<_$ImageEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
