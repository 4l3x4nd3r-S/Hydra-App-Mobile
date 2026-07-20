// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_option_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CatalogOptionDto _$CatalogOptionDtoFromJson(Map<String, dynamic> json) {
  return _CatalogOptionDto.fromJson(json);
}

/// @nodoc
mixin _$CatalogOptionDto {
  @JsonKey(name: 'grupo')
  String get group => throw _privateConstructorUsedError;
  @JsonKey(name: 'codigo')
  String get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'etiqueta')
  String get label => throw _privateConstructorUsedError;
  @JsonKey(name: 'descripcion')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'padre_codigo')
  String? get parentCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'relacionado_codigo')
  String? get relatedCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'orden')
  int get order => throw _privateConstructorUsedError;
  @JsonKey(name: 'predeterminado')
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this CatalogOptionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CatalogOptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogOptionDtoCopyWith<CatalogOptionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogOptionDtoCopyWith<$Res> {
  factory $CatalogOptionDtoCopyWith(
          CatalogOptionDto value, $Res Function(CatalogOptionDto) then) =
      _$CatalogOptionDtoCopyWithImpl<$Res, CatalogOptionDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'grupo') String group,
      @JsonKey(name: 'codigo') String code,
      @JsonKey(name: 'etiqueta') String label,
      @JsonKey(name: 'descripcion') String? description,
      @JsonKey(name: 'padre_codigo') String? parentCode,
      @JsonKey(name: 'relacionado_codigo') String? relatedCode,
      @JsonKey(name: 'orden') int order,
      @JsonKey(name: 'predeterminado') bool isDefault});
}

/// @nodoc
class _$CatalogOptionDtoCopyWithImpl<$Res, $Val extends CatalogOptionDto>
    implements $CatalogOptionDtoCopyWith<$Res> {
  _$CatalogOptionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogOptionDto
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
abstract class _$$CatalogOptionDtoImplCopyWith<$Res>
    implements $CatalogOptionDtoCopyWith<$Res> {
  factory _$$CatalogOptionDtoImplCopyWith(_$CatalogOptionDtoImpl value,
          $Res Function(_$CatalogOptionDtoImpl) then) =
      __$$CatalogOptionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'grupo') String group,
      @JsonKey(name: 'codigo') String code,
      @JsonKey(name: 'etiqueta') String label,
      @JsonKey(name: 'descripcion') String? description,
      @JsonKey(name: 'padre_codigo') String? parentCode,
      @JsonKey(name: 'relacionado_codigo') String? relatedCode,
      @JsonKey(name: 'orden') int order,
      @JsonKey(name: 'predeterminado') bool isDefault});
}

/// @nodoc
class __$$CatalogOptionDtoImplCopyWithImpl<$Res>
    extends _$CatalogOptionDtoCopyWithImpl<$Res, _$CatalogOptionDtoImpl>
    implements _$$CatalogOptionDtoImplCopyWith<$Res> {
  __$$CatalogOptionDtoImplCopyWithImpl(_$CatalogOptionDtoImpl _value,
      $Res Function(_$CatalogOptionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CatalogOptionDto
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
    return _then(_$CatalogOptionDtoImpl(
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
@JsonSerializable()
class _$CatalogOptionDtoImpl implements _CatalogOptionDto {
  const _$CatalogOptionDtoImpl(
      {@JsonKey(name: 'grupo') required this.group,
      @JsonKey(name: 'codigo') required this.code,
      @JsonKey(name: 'etiqueta') required this.label,
      @JsonKey(name: 'descripcion') this.description,
      @JsonKey(name: 'padre_codigo') this.parentCode,
      @JsonKey(name: 'relacionado_codigo') this.relatedCode,
      @JsonKey(name: 'orden') this.order = 0,
      @JsonKey(name: 'predeterminado') this.isDefault = false});

  factory _$CatalogOptionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CatalogOptionDtoImplFromJson(json);

  @override
  @JsonKey(name: 'grupo')
  final String group;
  @override
  @JsonKey(name: 'codigo')
  final String code;
  @override
  @JsonKey(name: 'etiqueta')
  final String label;
  @override
  @JsonKey(name: 'descripcion')
  final String? description;
  @override
  @JsonKey(name: 'padre_codigo')
  final String? parentCode;
  @override
  @JsonKey(name: 'relacionado_codigo')
  final String? relatedCode;
  @override
  @JsonKey(name: 'orden')
  final int order;
  @override
  @JsonKey(name: 'predeterminado')
  final bool isDefault;

  @override
  String toString() {
    return 'CatalogOptionDto(group: $group, code: $code, label: $label, description: $description, parentCode: $parentCode, relatedCode: $relatedCode, order: $order, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogOptionDtoImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, group, code, label, description,
      parentCode, relatedCode, order, isDefault);

  /// Create a copy of CatalogOptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogOptionDtoImplCopyWith<_$CatalogOptionDtoImpl> get copyWith =>
      __$$CatalogOptionDtoImplCopyWithImpl<_$CatalogOptionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogOptionDtoImplToJson(
      this,
    );
  }
}

abstract class _CatalogOptionDto implements CatalogOptionDto {
  const factory _CatalogOptionDto(
          {@JsonKey(name: 'grupo') required final String group,
          @JsonKey(name: 'codigo') required final String code,
          @JsonKey(name: 'etiqueta') required final String label,
          @JsonKey(name: 'descripcion') final String? description,
          @JsonKey(name: 'padre_codigo') final String? parentCode,
          @JsonKey(name: 'relacionado_codigo') final String? relatedCode,
          @JsonKey(name: 'orden') final int order,
          @JsonKey(name: 'predeterminado') final bool isDefault}) =
      _$CatalogOptionDtoImpl;

  factory _CatalogOptionDto.fromJson(Map<String, dynamic> json) =
      _$CatalogOptionDtoImpl.fromJson;

  @override
  @JsonKey(name: 'grupo')
  String get group;
  @override
  @JsonKey(name: 'codigo')
  String get code;
  @override
  @JsonKey(name: 'etiqueta')
  String get label;
  @override
  @JsonKey(name: 'descripcion')
  String? get description;
  @override
  @JsonKey(name: 'padre_codigo')
  String? get parentCode;
  @override
  @JsonKey(name: 'relacionado_codigo')
  String? get relatedCode;
  @override
  @JsonKey(name: 'orden')
  int get order;
  @override
  @JsonKey(name: 'predeterminado')
  bool get isDefault;

  /// Create a copy of CatalogOptionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogOptionDtoImplCopyWith<_$CatalogOptionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
