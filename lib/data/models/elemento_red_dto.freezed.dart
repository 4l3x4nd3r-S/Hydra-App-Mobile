// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'elemento_red_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ElementoRedDto _$ElementoRedDtoFromJson(Map<String, dynamic> json) {
  return _ElementoRedDto.fromJson(json);
}

/// @nodoc
mixin _$ElementoRedDto {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'codigo_plano')
  String? get codigoPlano => throw _privateConstructorUsedError;
  @JsonKey(name: 'tipo')
  String? get tipo => throw _privateConstructorUsedError;
  @JsonKey(name: 'sector_id')
  int? get sectorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'latitud')
  double? get latitud => throw _privateConstructorUsedError;
  @JsonKey(name: 'longitud')
  double? get longitud => throw _privateConstructorUsedError;
  @JsonKey(name: 'estado_operativo')
  String? get estadoOperativo => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_modificacion')
  String? get fechaModificacion => throw _privateConstructorUsedError;
  @JsonKey(name: 'estado_valvula')
  String? get estadoValvula => throw _privateConstructorUsedError;

  /// Serializes this ElementoRedDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ElementoRedDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ElementoRedDtoCopyWith<ElementoRedDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ElementoRedDtoCopyWith<$Res> {
  factory $ElementoRedDtoCopyWith(
          ElementoRedDto value, $Res Function(ElementoRedDto) then) =
      _$ElementoRedDtoCopyWithImpl<$Res, ElementoRedDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'codigo_plano') String? codigoPlano,
      @JsonKey(name: 'tipo') String? tipo,
      @JsonKey(name: 'sector_id') int? sectorId,
      @JsonKey(name: 'latitud') double? latitud,
      @JsonKey(name: 'longitud') double? longitud,
      @JsonKey(name: 'estado_operativo') String? estadoOperativo,
      @JsonKey(name: 'fecha_modificacion') String? fechaModificacion,
      @JsonKey(name: 'estado_valvula') String? estadoValvula});
}

/// @nodoc
class _$ElementoRedDtoCopyWithImpl<$Res, $Val extends ElementoRedDto>
    implements $ElementoRedDtoCopyWith<$Res> {
  _$ElementoRedDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ElementoRedDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigoPlano = freezed,
    Object? tipo = freezed,
    Object? sectorId = freezed,
    Object? latitud = freezed,
    Object? longitud = freezed,
    Object? estadoOperativo = freezed,
    Object? fechaModificacion = freezed,
    Object? estadoValvula = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      codigoPlano: freezed == codigoPlano
          ? _value.codigoPlano
          : codigoPlano // ignore: cast_nullable_to_non_nullable
              as String?,
      tipo: freezed == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
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
      estadoOperativo: freezed == estadoOperativo
          ? _value.estadoOperativo
          : estadoOperativo // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaModificacion: freezed == fechaModificacion
          ? _value.fechaModificacion
          : fechaModificacion // ignore: cast_nullable_to_non_nullable
              as String?,
      estadoValvula: freezed == estadoValvula
          ? _value.estadoValvula
          : estadoValvula // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ElementoRedDtoImplCopyWith<$Res>
    implements $ElementoRedDtoCopyWith<$Res> {
  factory _$$ElementoRedDtoImplCopyWith(_$ElementoRedDtoImpl value,
          $Res Function(_$ElementoRedDtoImpl) then) =
      __$$ElementoRedDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'codigo_plano') String? codigoPlano,
      @JsonKey(name: 'tipo') String? tipo,
      @JsonKey(name: 'sector_id') int? sectorId,
      @JsonKey(name: 'latitud') double? latitud,
      @JsonKey(name: 'longitud') double? longitud,
      @JsonKey(name: 'estado_operativo') String? estadoOperativo,
      @JsonKey(name: 'fecha_modificacion') String? fechaModificacion,
      @JsonKey(name: 'estado_valvula') String? estadoValvula});
}

/// @nodoc
class __$$ElementoRedDtoImplCopyWithImpl<$Res>
    extends _$ElementoRedDtoCopyWithImpl<$Res, _$ElementoRedDtoImpl>
    implements _$$ElementoRedDtoImplCopyWith<$Res> {
  __$$ElementoRedDtoImplCopyWithImpl(
      _$ElementoRedDtoImpl _value, $Res Function(_$ElementoRedDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ElementoRedDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigoPlano = freezed,
    Object? tipo = freezed,
    Object? sectorId = freezed,
    Object? latitud = freezed,
    Object? longitud = freezed,
    Object? estadoOperativo = freezed,
    Object? fechaModificacion = freezed,
    Object? estadoValvula = freezed,
  }) {
    return _then(_$ElementoRedDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      codigoPlano: freezed == codigoPlano
          ? _value.codigoPlano
          : codigoPlano // ignore: cast_nullable_to_non_nullable
              as String?,
      tipo: freezed == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
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
      estadoOperativo: freezed == estadoOperativo
          ? _value.estadoOperativo
          : estadoOperativo // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaModificacion: freezed == fechaModificacion
          ? _value.fechaModificacion
          : fechaModificacion // ignore: cast_nullable_to_non_nullable
              as String?,
      estadoValvula: freezed == estadoValvula
          ? _value.estadoValvula
          : estadoValvula // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ElementoRedDtoImpl implements _ElementoRedDto {
  const _$ElementoRedDtoImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'codigo_plano') this.codigoPlano,
      @JsonKey(name: 'tipo') this.tipo,
      @JsonKey(name: 'sector_id') this.sectorId,
      @JsonKey(name: 'latitud') this.latitud,
      @JsonKey(name: 'longitud') this.longitud,
      @JsonKey(name: 'estado_operativo') this.estadoOperativo,
      @JsonKey(name: 'fecha_modificacion') this.fechaModificacion,
      @JsonKey(name: 'estado_valvula') this.estadoValvula});

  factory _$ElementoRedDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ElementoRedDtoImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'codigo_plano')
  final String? codigoPlano;
  @override
  @JsonKey(name: 'tipo')
  final String? tipo;
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
  @JsonKey(name: 'estado_operativo')
  final String? estadoOperativo;
  @override
  @JsonKey(name: 'fecha_modificacion')
  final String? fechaModificacion;
  @override
  @JsonKey(name: 'estado_valvula')
  final String? estadoValvula;

  @override
  String toString() {
    return 'ElementoRedDto(id: $id, codigoPlano: $codigoPlano, tipo: $tipo, sectorId: $sectorId, latitud: $latitud, longitud: $longitud, estadoOperativo: $estadoOperativo, fechaModificacion: $fechaModificacion, estadoValvula: $estadoValvula)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ElementoRedDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.codigoPlano, codigoPlano) ||
                other.codigoPlano == codigoPlano) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.sectorId, sectorId) ||
                other.sectorId == sectorId) &&
            (identical(other.latitud, latitud) || other.latitud == latitud) &&
            (identical(other.longitud, longitud) ||
                other.longitud == longitud) &&
            (identical(other.estadoOperativo, estadoOperativo) ||
                other.estadoOperativo == estadoOperativo) &&
            (identical(other.fechaModificacion, fechaModificacion) ||
                other.fechaModificacion == fechaModificacion) &&
            (identical(other.estadoValvula, estadoValvula) ||
                other.estadoValvula == estadoValvula));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, codigoPlano, tipo, sectorId,
      latitud, longitud, estadoOperativo, fechaModificacion, estadoValvula);

  /// Create a copy of ElementoRedDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ElementoRedDtoImplCopyWith<_$ElementoRedDtoImpl> get copyWith =>
      __$$ElementoRedDtoImplCopyWithImpl<_$ElementoRedDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ElementoRedDtoImplToJson(
      this,
    );
  }
}

abstract class _ElementoRedDto implements ElementoRedDto {
  const factory _ElementoRedDto(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'codigo_plano') final String? codigoPlano,
          @JsonKey(name: 'tipo') final String? tipo,
          @JsonKey(name: 'sector_id') final int? sectorId,
          @JsonKey(name: 'latitud') final double? latitud,
          @JsonKey(name: 'longitud') final double? longitud,
          @JsonKey(name: 'estado_operativo') final String? estadoOperativo,
          @JsonKey(name: 'fecha_modificacion') final String? fechaModificacion,
          @JsonKey(name: 'estado_valvula') final String? estadoValvula}) =
      _$ElementoRedDtoImpl;

  factory _ElementoRedDto.fromJson(Map<String, dynamic> json) =
      _$ElementoRedDtoImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'codigo_plano')
  String? get codigoPlano;
  @override
  @JsonKey(name: 'tipo')
  String? get tipo;
  @override
  @JsonKey(name: 'sector_id')
  int? get sectorId;
  @override
  @JsonKey(name: 'latitud')
  double? get latitud;
  @override
  @JsonKey(name: 'longitud')
  double? get longitud;
  @override
  @JsonKey(name: 'estado_operativo')
  String? get estadoOperativo;
  @override
  @JsonKey(name: 'fecha_modificacion')
  String? get fechaModificacion;
  @override
  @JsonKey(name: 'estado_valvula')
  String? get estadoValvula;

  /// Create a copy of ElementoRedDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ElementoRedDtoImplCopyWith<_$ElementoRedDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
