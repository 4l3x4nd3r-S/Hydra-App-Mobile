// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CatalogOption {
  String get group => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get parentCode => throw _privateConstructorUsedError;
  String? get relatedCode => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;

  /// Create a copy of CatalogOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogOptionCopyWith<CatalogOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogOptionCopyWith<$Res> {
  factory $CatalogOptionCopyWith(
          CatalogOption value, $Res Function(CatalogOption) then) =
      _$CatalogOptionCopyWithImpl<$Res, CatalogOption>;
  @useResult
  $Res call(
      {String group,
      String code,
      String label,
      String? description,
      String? parentCode,
      String? relatedCode,
      int order,
      bool isDefault});
}

/// @nodoc
class _$CatalogOptionCopyWithImpl<$Res, $Val extends CatalogOption>
    implements $CatalogOptionCopyWith<$Res> {
  _$CatalogOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? group = null,
    Object? code = null,
    Object? label = null,
    Object? description = freezed,
    Object? parentCode = freezed,
    Object? relatedCode = freezed,
    Object? order = null,
    Object? isDefault = null,
  }) {
    return _then(_value.copyWith(
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parentCode: freezed == parentCode
          ? _value.parentCode
          : parentCode // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedCode: freezed == relatedCode
          ? _value.relatedCode
          : relatedCode // ignore: cast_nullable_to_non_nullable
              as String?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CatalogOptionImplCopyWith<$Res>
    implements $CatalogOptionCopyWith<$Res> {
  factory _$$CatalogOptionImplCopyWith(
          _$CatalogOptionImpl value, $Res Function(_$CatalogOptionImpl) then) =
      __$$CatalogOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String group,
      String code,
      String label,
      String? description,
      String? parentCode,
      String? relatedCode,
      int order,
      bool isDefault});
}

/// @nodoc
class __$$CatalogOptionImplCopyWithImpl<$Res>
    extends _$CatalogOptionCopyWithImpl<$Res, _$CatalogOptionImpl>
    implements _$$CatalogOptionImplCopyWith<$Res> {
  __$$CatalogOptionImplCopyWithImpl(
      _$CatalogOptionImpl _value, $Res Function(_$CatalogOptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of CatalogOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? group = null,
    Object? code = null,
    Object? label = null,
    Object? description = freezed,
    Object? parentCode = freezed,
    Object? relatedCode = freezed,
    Object? order = null,
    Object? isDefault = null,
  }) {
    return _then(_$CatalogOptionImpl(
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parentCode: freezed == parentCode
          ? _value.parentCode
          : parentCode // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedCode: freezed == relatedCode
          ? _value.relatedCode
          : relatedCode // ignore: cast_nullable_to_non_nullable
              as String?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CatalogOptionImpl implements _CatalogOption {
  const _$CatalogOptionImpl(
      {required this.group,
      required this.code,
      required this.label,
      this.description,
      this.parentCode,
      this.relatedCode,
      this.order = 0,
      this.isDefault = false});

  @override
  final String group;
  @override
  final String code;
  @override
  final String label;
  @override
  final String? description;
  @override
  final String? parentCode;
  @override
  final String? relatedCode;
  @override
  @JsonKey()
  final int order;
  @override
  @JsonKey()
  final bool isDefault;

  @override
  String toString() {
    return 'CatalogOption(group: $group, code: $code, label: $label, description: $description, parentCode: $parentCode, relatedCode: $relatedCode, order: $order, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogOptionImpl &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.parentCode, parentCode) ||
                other.parentCode == parentCode) &&
            (identical(other.relatedCode, relatedCode) ||
                other.relatedCode == relatedCode) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @override
  int get hashCode => Object.hash(runtimeType, group, code, label, description,
      parentCode, relatedCode, order, isDefault);

  /// Create a copy of CatalogOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogOptionImplCopyWith<_$CatalogOptionImpl> get copyWith =>
      __$$CatalogOptionImplCopyWithImpl<_$CatalogOptionImpl>(this, _$identity);
}

abstract class _CatalogOption implements CatalogOption {
  const factory _CatalogOption(
      {required final String group,
      required final String code,
      required final String label,
      final String? description,
      final String? parentCode,
      final String? relatedCode,
      final int order,
      final bool isDefault}) = _$CatalogOptionImpl;

  @override
  String get group;
  @override
  String get code;
  @override
  String get label;
  @override
  String? get description;
  @override
  String? get parentCode;
  @override
  String? get relatedCode;
  @override
  int get order;
  @override
  bool get isDefault;

  /// Create a copy of CatalogOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogOptionImplCopyWith<_$CatalogOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
