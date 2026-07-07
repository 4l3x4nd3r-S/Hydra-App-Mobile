// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'punto_presion_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PuntoPresionDto _$PuntoPresionDtoFromJson(Map<String, dynamic> json) {
  return _PuntoPresionDto.fromJson(json);
}

/// @nodoc
mixin _$PuntoPresionDto {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'codigo_punto')
  String? get codigoPunto => throw _privateConstructorUsedError;
  @JsonKey(name: 'sector_id')
  int? get sectorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'latitud')
  double? get latitud => throw _privateConstructorUsedError;
  @JsonKey(name: 'longitud')
  double? get longitud => throw _privateConstructorUsedError;

  /// Serializes this PuntoPresionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PuntoPresionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PuntoPresionDtoCopyWith<PuntoPresionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PuntoPresionDtoCopyWith<$Res> {
  factory $PuntoPresionDtoCopyWith(
          PuntoPresionDto value, $Res Function(PuntoPresionDto) then) =
      _$PuntoPresionDtoCopyWithImpl<$Res, PuntoPresionDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'codigo_punto') String? codigoPunto,
      @JsonKey(name: 'sector_id') int? sectorId,
      @JsonKey(name: 'latitud') double? latitud,
      @JsonKey(name: 'longitud') double? longitud});
}

/// @nodoc
class _$PuntoPresionDtoCopyWithImpl<$Res, $Val extends PuntoPresionDto>
    implements $PuntoPresionDtoCopyWith<$Res> {
  _$PuntoPresionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PuntoPresionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigoPunto = freezed,
    Object? sectorId = freezed,
    Object? latitud = freezed,
    Object? longitud = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      codigoPunto: freezed == codigoPunto
          ? _value.codigoPunto
          : codigoPunto // ignore: cast_nullable_to_non_nullable
              as String?,
      sectorId: freezed == sectorId
          ? _value.sectorId
          : sectorId // ignore: cast_nullable_to_non_nullable
              as int?,
      latitud: freezed == latitud
          ? _value.latitud
          : latitud // ignore: cast_nullable_to_non_nullable
              as double?,
      longitud: freezed == longitud
          ? _value.longitud
          : longitud // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PuntoPresionDtoImplCopyWith<$Res>
    implements $PuntoPresionDtoCopyWith<$Res> {
  factory _$$PuntoPresionDtoImplCopyWith(_$PuntoPresionDtoImpl value,
          $Res Function(_$PuntoPresionDtoImpl) then) =
      __$$PuntoPresionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'codigo_punto') String? codigoPunto,
      @JsonKey(name: 'sector_id') int? sectorId,
      @JsonKey(name: 'latitud') double? latitud,
      @JsonKey(name: 'longitud') double? longitud});
}

/// @nodoc
class __$$PuntoPresionDtoImplCopyWithImpl<$Res>
    extends _$PuntoPresionDtoCopyWithImpl<$Res, _$PuntoPresionDtoImpl>
    implements _$$PuntoPresionDtoImplCopyWith<$Res> {
  __$$PuntoPresionDtoImplCopyWithImpl(
      _$PuntoPresionDtoImpl _value, $Res Function(_$PuntoPresionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PuntoPresionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigoPunto = freezed,
    Object? sectorId = freezed,
    Object? latitud = freezed,
    Object? longitud = freezed,
  }) {
    return _then(_$PuntoPresionDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      codigoPunto: freezed == codigoPunto
          ? _value.codigoPunto
          : codigoPunto // ignore: cast_nullable_to_non_nullable
              as String?,
      sectorId: freezed == sectorId
          ? _value.sectorId
          : sectorId // ignore: cast_nullable_to_non_nullable
              as int?,
      latitud: freezed == latitud
          ? _value.latitud
          : latitud // ignore: cast_nullable_to_non_nullable
              as double?,
      longitud: freezed == longitud
          ? _value.longitud
          : longitud // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PuntoPresionDtoImpl implements _PuntoPresionDto {
  const _$PuntoPresionDtoImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'codigo_punto') this.codigoPunto,
      @JsonKey(name: 'sector_id') this.sectorId,
      @JsonKey(name: 'latitud') this.latitud,
      @JsonKey(name: 'longitud') this.longitud});

  factory _$PuntoPresionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PuntoPresionDtoImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'codigo_punto')
  final String? codigoPunto;
  @override
  @JsonKey(name: 'sector_id')
  final int? sectorId;
  @override
  @JsonKey(name: 'latitud')
  final double? latitud;
  @override
  @JsonKey(name: 'longitud')
  final double? longitud;

  @override
  String toString() {
    return 'PuntoPresionDto(id: $id, codigoPunto: $codigoPunto, sectorId: $sectorId, latitud: $latitud, longitud: $longitud)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PuntoPresionDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.codigoPunto, codigoPunto) ||
                other.codigoPunto == codigoPunto) &&
            (identical(other.sectorId, sectorId) ||
                other.sectorId == sectorId) &&
            (identical(other.latitud, latitud) || other.latitud == latitud) &&
            (identical(other.longitud, longitud) ||
                other.longitud == longitud));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, codigoPunto, sectorId, latitud, longitud);

  /// Create a copy of PuntoPresionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PuntoPresionDtoImplCopyWith<_$PuntoPresionDtoImpl> get copyWith =>
      __$$PuntoPresionDtoImplCopyWithImpl<_$PuntoPresionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PuntoPresionDtoImplToJson(
      this,
    );
  }
}

abstract class _PuntoPresionDto implements PuntoPresionDto {
  const factory _PuntoPresionDto(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'codigo_punto') final String? codigoPunto,
          @JsonKey(name: 'sector_id') final int? sectorId,
          @JsonKey(name: 'latitud') final double? latitud,
          @JsonKey(name: 'longitud') final double? longitud}) =
      _$PuntoPresionDtoImpl;

  factory _PuntoPresionDto.fromJson(Map<String, dynamic> json) =
      _$PuntoPresionDtoImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'codigo_punto')
  String? get codigoPunto;
  @override
  @JsonKey(name: 'sector_id')
  int? get sectorId;
  @override
  @JsonKey(name: 'latitud')
  double? get latitud;
  @override
  @JsonKey(name: 'longitud')
  double? get longitud;

  /// Create a copy of PuntoPresionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PuntoPresionDtoImplCopyWith<_$PuntoPresionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
