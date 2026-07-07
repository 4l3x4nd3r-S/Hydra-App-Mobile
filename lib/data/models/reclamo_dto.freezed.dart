// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reclamo_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReclamoDto _$ReclamoDtoFromJson(Map<String, dynamic> json) {
  return _ReclamoDto.fromJson(json);
}

/// @nodoc
mixin _$ReclamoDto {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'formato')
  String? get formato => throw _privateConstructorUsedError;
  @JsonKey(name: 'codigo_solicitud')
  String? get codigoSolicitud => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_registro')
  String? get fechaRegistro => throw _privateConstructorUsedError;
  @JsonKey(name: 'canal_entrada')
  String? get canalEntrada => throw _privateConstructorUsedError;
  @JsonKey(name: 'tipo_problema')
  String? get tipoProblema => throw _privateConstructorUsedError;
  @JsonKey(name: 'estado')
  String? get estado => throw _privateConstructorUsedError;
  @JsonKey(name: 'descripcion')
  String? get descripcion => throw _privateConstructorUsedError;
  @JsonKey(name: 'nombre_solicitante')
  String? get nombreSolicitante => throw _privateConstructorUsedError;
  @JsonKey(name: 'direccion')
  String? get direccion => throw _privateConstructorUsedError;
  @JsonKey(name: 'numero_medidor')
  String? get numeroMedidor => throw _privateConstructorUsedError;
  @JsonKey(name: 'telefono')
  String? get telefono => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String? get email => throw _privateConstructorUsedError;

  /// Serializes this ReclamoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReclamoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReclamoDtoCopyWith<ReclamoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReclamoDtoCopyWith<$Res> {
  factory $ReclamoDtoCopyWith(
          ReclamoDto value, $Res Function(ReclamoDto) then) =
      _$ReclamoDtoCopyWithImpl<$Res, ReclamoDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'formato') String? formato,
      @JsonKey(name: 'codigo_solicitud') String? codigoSolicitud,
      @JsonKey(name: 'fecha_registro') String? fechaRegistro,
      @JsonKey(name: 'canal_entrada') String? canalEntrada,
      @JsonKey(name: 'tipo_problema') String? tipoProblema,
      @JsonKey(name: 'estado') String? estado,
      @JsonKey(name: 'descripcion') String? descripcion,
      @JsonKey(name: 'nombre_solicitante') String? nombreSolicitante,
      @JsonKey(name: 'direccion') String? direccion,
      @JsonKey(name: 'numero_medidor') String? numeroMedidor,
      @JsonKey(name: 'telefono') String? telefono,
      @JsonKey(name: 'email') String? email});
}

/// @nodoc
class _$ReclamoDtoCopyWithImpl<$Res, $Val extends ReclamoDto>
    implements $ReclamoDtoCopyWith<$Res> {
  _$ReclamoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReclamoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? formato = freezed,
    Object? codigoSolicitud = freezed,
    Object? fechaRegistro = freezed,
    Object? canalEntrada = freezed,
    Object? tipoProblema = freezed,
    Object? estado = freezed,
    Object? descripcion = freezed,
    Object? nombreSolicitante = freezed,
    Object? direccion = freezed,
    Object? numeroMedidor = freezed,
    Object? telefono = freezed,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      formato: freezed == formato
          ? _value.formato
          : formato // ignore: cast_nullable_to_non_nullable
              as String?,
      codigoSolicitud: freezed == codigoSolicitud
          ? _value.codigoSolicitud
          : codigoSolicitud // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaRegistro: freezed == fechaRegistro
          ? _value.fechaRegistro
          : fechaRegistro // ignore: cast_nullable_to_non_nullable
              as String?,
      canalEntrada: freezed == canalEntrada
          ? _value.canalEntrada
          : canalEntrada // ignore: cast_nullable_to_non_nullable
              as String?,
      tipoProblema: freezed == tipoProblema
          ? _value.tipoProblema
          : tipoProblema // ignore: cast_nullable_to_non_nullable
              as String?,
      estado: freezed == estado
          ? _value.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String?,
      descripcion: freezed == descripcion
          ? _value.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String?,
      nombreSolicitante: freezed == nombreSolicitante
          ? _value.nombreSolicitante
          : nombreSolicitante // ignore: cast_nullable_to_non_nullable
              as String?,
      direccion: freezed == direccion
          ? _value.direccion
          : direccion // ignore: cast_nullable_to_non_nullable
              as String?,
      numeroMedidor: freezed == numeroMedidor
          ? _value.numeroMedidor
          : numeroMedidor // ignore: cast_nullable_to_non_nullable
              as String?,
      telefono: freezed == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReclamoDtoImplCopyWith<$Res>
    implements $ReclamoDtoCopyWith<$Res> {
  factory _$$ReclamoDtoImplCopyWith(
          _$ReclamoDtoImpl value, $Res Function(_$ReclamoDtoImpl) then) =
      __$$ReclamoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'formato') String? formato,
      @JsonKey(name: 'codigo_solicitud') String? codigoSolicitud,
      @JsonKey(name: 'fecha_registro') String? fechaRegistro,
      @JsonKey(name: 'canal_entrada') String? canalEntrada,
      @JsonKey(name: 'tipo_problema') String? tipoProblema,
      @JsonKey(name: 'estado') String? estado,
      @JsonKey(name: 'descripcion') String? descripcion,
      @JsonKey(name: 'nombre_solicitante') String? nombreSolicitante,
      @JsonKey(name: 'direccion') String? direccion,
      @JsonKey(name: 'numero_medidor') String? numeroMedidor,
      @JsonKey(name: 'telefono') String? telefono,
      @JsonKey(name: 'email') String? email});
}

/// @nodoc
class __$$ReclamoDtoImplCopyWithImpl<$Res>
    extends _$ReclamoDtoCopyWithImpl<$Res, _$ReclamoDtoImpl>
    implements _$$ReclamoDtoImplCopyWith<$Res> {
  __$$ReclamoDtoImplCopyWithImpl(
      _$ReclamoDtoImpl _value, $Res Function(_$ReclamoDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReclamoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? formato = freezed,
    Object? codigoSolicitud = freezed,
    Object? fechaRegistro = freezed,
    Object? canalEntrada = freezed,
    Object? tipoProblema = freezed,
    Object? estado = freezed,
    Object? descripcion = freezed,
    Object? nombreSolicitante = freezed,
    Object? direccion = freezed,
    Object? numeroMedidor = freezed,
    Object? telefono = freezed,
    Object? email = freezed,
  }) {
    return _then(_$ReclamoDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      formato: freezed == formato
          ? _value.formato
          : formato // ignore: cast_nullable_to_non_nullable
              as String?,
      codigoSolicitud: freezed == codigoSolicitud
          ? _value.codigoSolicitud
          : codigoSolicitud // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaRegistro: freezed == fechaRegistro
          ? _value.fechaRegistro
          : fechaRegistro // ignore: cast_nullable_to_non_nullable
              as String?,
      canalEntrada: freezed == canalEntrada
          ? _value.canalEntrada
          : canalEntrada // ignore: cast_nullable_to_non_nullable
              as String?,
      tipoProblema: freezed == tipoProblema
          ? _value.tipoProblema
          : tipoProblema // ignore: cast_nullable_to_non_nullable
              as String?,
      estado: freezed == estado
          ? _value.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String?,
      descripcion: freezed == descripcion
          ? _value.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String?,
      nombreSolicitante: freezed == nombreSolicitante
          ? _value.nombreSolicitante
          : nombreSolicitante // ignore: cast_nullable_to_non_nullable
              as String?,
      direccion: freezed == direccion
          ? _value.direccion
          : direccion // ignore: cast_nullable_to_non_nullable
              as String?,
      numeroMedidor: freezed == numeroMedidor
          ? _value.numeroMedidor
          : numeroMedidor // ignore: cast_nullable_to_non_nullable
              as String?,
      telefono: freezed == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReclamoDtoImpl implements _ReclamoDto {
  const _$ReclamoDtoImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'formato') this.formato,
      @JsonKey(name: 'codigo_solicitud') this.codigoSolicitud,
      @JsonKey(name: 'fecha_registro') this.fechaRegistro,
      @JsonKey(name: 'canal_entrada') this.canalEntrada,
      @JsonKey(name: 'tipo_problema') this.tipoProblema,
      @JsonKey(name: 'estado') this.estado,
      @JsonKey(name: 'descripcion') this.descripcion,
      @JsonKey(name: 'nombre_solicitante') this.nombreSolicitante,
      @JsonKey(name: 'direccion') this.direccion,
      @JsonKey(name: 'numero_medidor') this.numeroMedidor,
      @JsonKey(name: 'telefono') this.telefono,
      @JsonKey(name: 'email') this.email});

  factory _$ReclamoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReclamoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'formato')
  final String? formato;
  @override
  @JsonKey(name: 'codigo_solicitud')
  final String? codigoSolicitud;
  @override
  @JsonKey(name: 'fecha_registro')
  final String? fechaRegistro;
  @override
  @JsonKey(name: 'canal_entrada')
  final String? canalEntrada;
  @override
  @JsonKey(name: 'tipo_problema')
  final String? tipoProblema;
  @override
  @JsonKey(name: 'estado')
  final String? estado;
  @override
  @JsonKey(name: 'descripcion')
  final String? descripcion;
  @override
  @JsonKey(name: 'nombre_solicitante')
  final String? nombreSolicitante;
  @override
  @JsonKey(name: 'direccion')
  final String? direccion;
  @override
  @JsonKey(name: 'numero_medidor')
  final String? numeroMedidor;
  @override
  @JsonKey(name: 'telefono')
  final String? telefono;
  @override
  @JsonKey(name: 'email')
  final String? email;

  @override
  String toString() {
    return 'ReclamoDto(id: $id, formato: $formato, codigoSolicitud: $codigoSolicitud, fechaRegistro: $fechaRegistro, canalEntrada: $canalEntrada, tipoProblema: $tipoProblema, estado: $estado, descripcion: $descripcion, nombreSolicitante: $nombreSolicitante, direccion: $direccion, numeroMedidor: $numeroMedidor, telefono: $telefono, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReclamoDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.formato, formato) || other.formato == formato) &&
            (identical(other.codigoSolicitud, codigoSolicitud) ||
                other.codigoSolicitud == codigoSolicitud) &&
            (identical(other.fechaRegistro, fechaRegistro) ||
                other.fechaRegistro == fechaRegistro) &&
            (identical(other.canalEntrada, canalEntrada) ||
                other.canalEntrada == canalEntrada) &&
            (identical(other.tipoProblema, tipoProblema) ||
                other.tipoProblema == tipoProblema) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.nombreSolicitante, nombreSolicitante) ||
                other.nombreSolicitante == nombreSolicitante) &&
            (identical(other.direccion, direccion) ||
                other.direccion == direccion) &&
            (identical(other.numeroMedidor, numeroMedidor) ||
                other.numeroMedidor == numeroMedidor) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      formato,
      codigoSolicitud,
      fechaRegistro,
      canalEntrada,
      tipoProblema,
      estado,
      descripcion,
      nombreSolicitante,
      direccion,
      numeroMedidor,
      telefono,
      email);

  /// Create a copy of ReclamoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReclamoDtoImplCopyWith<_$ReclamoDtoImpl> get copyWith =>
      __$$ReclamoDtoImplCopyWithImpl<_$ReclamoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReclamoDtoImplToJson(
      this,
    );
  }
}

abstract class _ReclamoDto implements ReclamoDto {
  const factory _ReclamoDto(
      {@JsonKey(name: 'id') required final int id,
      @JsonKey(name: 'formato') final String? formato,
      @JsonKey(name: 'codigo_solicitud') final String? codigoSolicitud,
      @JsonKey(name: 'fecha_registro') final String? fechaRegistro,
      @JsonKey(name: 'canal_entrada') final String? canalEntrada,
      @JsonKey(name: 'tipo_problema') final String? tipoProblema,
      @JsonKey(name: 'estado') final String? estado,
      @JsonKey(name: 'descripcion') final String? descripcion,
      @JsonKey(name: 'nombre_solicitante') final String? nombreSolicitante,
      @JsonKey(name: 'direccion') final String? direccion,
      @JsonKey(name: 'numero_medidor') final String? numeroMedidor,
      @JsonKey(name: 'telefono') final String? telefono,
      @JsonKey(name: 'email') final String? email}) = _$ReclamoDtoImpl;

  factory _ReclamoDto.fromJson(Map<String, dynamic> json) =
      _$ReclamoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'formato')
  String? get formato;
  @override
  @JsonKey(name: 'codigo_solicitud')
  String? get codigoSolicitud;
  @override
  @JsonKey(name: 'fecha_registro')
  String? get fechaRegistro;
  @override
  @JsonKey(name: 'canal_entrada')
  String? get canalEntrada;
  @override
  @JsonKey(name: 'tipo_problema')
  String? get tipoProblema;
  @override
  @JsonKey(name: 'estado')
  String? get estado;
  @override
  @JsonKey(name: 'descripcion')
  String? get descripcion;
  @override
  @JsonKey(name: 'nombre_solicitante')
  String? get nombreSolicitante;
  @override
  @JsonKey(name: 'direccion')
  String? get direccion;
  @override
  @JsonKey(name: 'numero_medidor')
  String? get numeroMedidor;
  @override
  @JsonKey(name: 'telefono')
  String? get telefono;
  @override
  @JsonKey(name: 'email')
  String? get email;

  /// Create a copy of ReclamoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReclamoDtoImplCopyWith<_$ReclamoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
