// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'os_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OsDto _$OsDtoFromJson(Map<String, dynamic> json) {
  return _OsDto.fromJson(json);
}

/// @nodoc
mixin _$OsDto {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'numero_orden')
  String? get numeroOrden => throw _privateConstructorUsedError;
  @JsonKey(name: 'reclamo_id')
  int? get reclamoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supervisor_id')
  int? get supervisorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cuadrilla_id')
  int? get cuadrillaId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sector_id')
  int? get sectorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_programacion')
  String? get fechaProgramacion => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_ejecucion_inicio')
  String? get fechaEjecucionInicio => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_ejecucion_fin')
  String? get fechaEjecucionFin => throw _privateConstructorUsedError;
  @JsonKey(name: 'estado_orden')
  String? get estadoOrden => throw _privateConstructorUsedError;
  @JsonKey(name: 'insumos_utilizados')
  String? get insumosUtilizados => throw _privateConstructorUsedError;
  @JsonKey(name: 'observaciones_gasfitero')
  String? get observacionesGasfitero => throw _privateConstructorUsedError;
  @JsonKey(name: 'ruta_carpeta_evidencias')
  String? get rutaCarpetaEvidencias => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'trabajo_ejecutado')
  String? get trabajoEjecutado => throw _privateConstructorUsedError;
  @JsonKey(name: 'problemas')
  String? get problemas => throw _privateConstructorUsedError;
  @JsonKey(name: 'soluciones')
  String? get soluciones => throw _privateConstructorUsedError;
  @JsonKey(name: 'comentarios_instrucciones')
  String? get comentariosInstrucciones => throw _privateConstructorUsedError;
  @JsonKey(name: 'latitud')
  double? get latitud => throw _privateConstructorUsedError;
  @JsonKey(name: 'longitud')
  double? get longitud => throw _privateConstructorUsedError;
  @JsonKey(name: 'fotos_problema_urls')
  List<String> get fotosProblemaUrls => throw _privateConstructorUsedError;
  @JsonKey(name: 'fotos_solucion_urls')
  List<String> get fotosSolucionUrls => throw _privateConstructorUsedError;
  @JsonKey(name: 'reclamo')
  ReclamoDto? get reclamo => throw _privateConstructorUsedError;
  @JsonKey(name: 'cuadrilla')
  CuadrillaDto? get cuadrilla => throw _privateConstructorUsedError;
  @JsonKey(name: 'responsable')
  ResponsableDto? get responsable => throw _privateConstructorUsedError;

  /// Serializes this OsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OsDtoCopyWith<OsDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OsDtoCopyWith<$Res> {
  factory $OsDtoCopyWith(OsDto value, $Res Function(OsDto) then) =
      _$OsDtoCopyWithImpl<$Res, OsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'numero_orden') String? numeroOrden,
      @JsonKey(name: 'reclamo_id') int? reclamoId,
      @JsonKey(name: 'supervisor_id') int? supervisorId,
      @JsonKey(name: 'cuadrilla_id') int? cuadrillaId,
      @JsonKey(name: 'sector_id') int? sectorId,
      @JsonKey(name: 'fecha_programacion') String? fechaProgramacion,
      @JsonKey(name: 'fecha_ejecucion_inicio') String? fechaEjecucionInicio,
      @JsonKey(name: 'fecha_ejecucion_fin') String? fechaEjecucionFin,
      @JsonKey(name: 'estado_orden') String? estadoOrden,
      @JsonKey(name: 'insumos_utilizados') String? insumosUtilizados,
      @JsonKey(name: 'observaciones_gasfitero') String? observacionesGasfitero,
      @JsonKey(name: 'ruta_carpeta_evidencias') String? rutaCarpetaEvidencias,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'trabajo_ejecutado') String? trabajoEjecutado,
      @JsonKey(name: 'problemas') String? problemas,
      @JsonKey(name: 'soluciones') String? soluciones,
      @JsonKey(name: 'comentarios_instrucciones')
      String? comentariosInstrucciones,
      @JsonKey(name: 'latitud') double? latitud,
      @JsonKey(name: 'longitud') double? longitud,
      @JsonKey(name: 'fotos_problema_urls') List<String> fotosProblemaUrls,
      @JsonKey(name: 'fotos_solucion_urls') List<String> fotosSolucionUrls,
      @JsonKey(name: 'reclamo') ReclamoDto? reclamo,
      @JsonKey(name: 'cuadrilla') CuadrillaDto? cuadrilla,
      @JsonKey(name: 'responsable') ResponsableDto? responsable});

  $ReclamoDtoCopyWith<$Res>? get reclamo;
  $CuadrillaDtoCopyWith<$Res>? get cuadrilla;
  $ResponsableDtoCopyWith<$Res>? get responsable;
}

/// @nodoc
class _$OsDtoCopyWithImpl<$Res, $Val extends OsDto>
    implements $OsDtoCopyWith<$Res> {
  _$OsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? numeroOrden = freezed,
    Object? reclamoId = freezed,
    Object? supervisorId = freezed,
    Object? cuadrillaId = freezed,
    Object? sectorId = freezed,
    Object? fechaProgramacion = freezed,
    Object? fechaEjecucionInicio = freezed,
    Object? fechaEjecucionFin = freezed,
    Object? estadoOrden = freezed,
    Object? insumosUtilizados = freezed,
    Object? observacionesGasfitero = freezed,
    Object? rutaCarpetaEvidencias = freezed,
    Object? createdAt = freezed,
    Object? trabajoEjecutado = freezed,
    Object? problemas = freezed,
    Object? soluciones = freezed,
    Object? comentariosInstrucciones = freezed,
    Object? latitud = freezed,
    Object? longitud = freezed,
    Object? fotosProblemaUrls = null,
    Object? fotosSolucionUrls = null,
    Object? reclamo = freezed,
    Object? cuadrilla = freezed,
    Object? responsable = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      numeroOrden: freezed == numeroOrden
          ? _value.numeroOrden
          : numeroOrden // ignore: cast_nullable_to_non_nullable
              as String?,
      reclamoId: freezed == reclamoId
          ? _value.reclamoId
          : reclamoId // ignore: cast_nullable_to_non_nullable
              as int?,
      supervisorId: freezed == supervisorId
          ? _value.supervisorId
          : supervisorId // ignore: cast_nullable_to_non_nullable
              as int?,
      cuadrillaId: freezed == cuadrillaId
          ? _value.cuadrillaId
          : cuadrillaId // ignore: cast_nullable_to_non_nullable
              as int?,
      sectorId: freezed == sectorId
          ? _value.sectorId
          : sectorId // ignore: cast_nullable_to_non_nullable
              as int?,
      fechaProgramacion: freezed == fechaProgramacion
          ? _value.fechaProgramacion
          : fechaProgramacion // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaEjecucionInicio: freezed == fechaEjecucionInicio
          ? _value.fechaEjecucionInicio
          : fechaEjecucionInicio // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaEjecucionFin: freezed == fechaEjecucionFin
          ? _value.fechaEjecucionFin
          : fechaEjecucionFin // ignore: cast_nullable_to_non_nullable
              as String?,
      estadoOrden: freezed == estadoOrden
          ? _value.estadoOrden
          : estadoOrden // ignore: cast_nullable_to_non_nullable
              as String?,
      insumosUtilizados: freezed == insumosUtilizados
          ? _value.insumosUtilizados
          : insumosUtilizados // ignore: cast_nullable_to_non_nullable
              as String?,
      observacionesGasfitero: freezed == observacionesGasfitero
          ? _value.observacionesGasfitero
          : observacionesGasfitero // ignore: cast_nullable_to_non_nullable
              as String?,
      rutaCarpetaEvidencias: freezed == rutaCarpetaEvidencias
          ? _value.rutaCarpetaEvidencias
          : rutaCarpetaEvidencias // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      trabajoEjecutado: freezed == trabajoEjecutado
          ? _value.trabajoEjecutado
          : trabajoEjecutado // ignore: cast_nullable_to_non_nullable
              as String?,
      problemas: freezed == problemas
          ? _value.problemas
          : problemas // ignore: cast_nullable_to_non_nullable
              as String?,
      soluciones: freezed == soluciones
          ? _value.soluciones
          : soluciones // ignore: cast_nullable_to_non_nullable
              as String?,
      comentariosInstrucciones: freezed == comentariosInstrucciones
          ? _value.comentariosInstrucciones
          : comentariosInstrucciones // ignore: cast_nullable_to_non_nullable
              as String?,
      latitud: freezed == latitud
          ? _value.latitud
          : latitud // ignore: cast_nullable_to_non_nullable
              as double?,
      longitud: freezed == longitud
          ? _value.longitud
          : longitud // ignore: cast_nullable_to_non_nullable
              as double?,
      fotosProblemaUrls: null == fotosProblemaUrls
          ? _value.fotosProblemaUrls
          : fotosProblemaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fotosSolucionUrls: null == fotosSolucionUrls
          ? _value.fotosSolucionUrls
          : fotosSolucionUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reclamo: freezed == reclamo
          ? _value.reclamo
          : reclamo // ignore: cast_nullable_to_non_nullable
              as ReclamoDto?,
      cuadrilla: freezed == cuadrilla
          ? _value.cuadrilla
          : cuadrilla // ignore: cast_nullable_to_non_nullable
              as CuadrillaDto?,
      responsable: freezed == responsable
          ? _value.responsable
          : responsable // ignore: cast_nullable_to_non_nullable
              as ResponsableDto?,
    ) as $Val);
  }

  /// Create a copy of OsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReclamoDtoCopyWith<$Res>? get reclamo {
    if (_value.reclamo == null) {
      return null;
    }

    return $ReclamoDtoCopyWith<$Res>(_value.reclamo!, (value) {
      return _then(_value.copyWith(reclamo: value) as $Val);
    });
  }

  /// Create a copy of OsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CuadrillaDtoCopyWith<$Res>? get cuadrilla {
    if (_value.cuadrilla == null) {
      return null;
    }

    return $CuadrillaDtoCopyWith<$Res>(_value.cuadrilla!, (value) {
      return _then(_value.copyWith(cuadrilla: value) as $Val);
    });
  }

  /// Create a copy of OsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResponsableDtoCopyWith<$Res>? get responsable {
    if (_value.responsable == null) {
      return null;
    }

    return $ResponsableDtoCopyWith<$Res>(_value.responsable!, (value) {
      return _then(_value.copyWith(responsable: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OsDtoImplCopyWith<$Res> implements $OsDtoCopyWith<$Res> {
  factory _$$OsDtoImplCopyWith(
          _$OsDtoImpl value, $Res Function(_$OsDtoImpl) then) =
      __$$OsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'numero_orden') String? numeroOrden,
      @JsonKey(name: 'reclamo_id') int? reclamoId,
      @JsonKey(name: 'supervisor_id') int? supervisorId,
      @JsonKey(name: 'cuadrilla_id') int? cuadrillaId,
      @JsonKey(name: 'sector_id') int? sectorId,
      @JsonKey(name: 'fecha_programacion') String? fechaProgramacion,
      @JsonKey(name: 'fecha_ejecucion_inicio') String? fechaEjecucionInicio,
      @JsonKey(name: 'fecha_ejecucion_fin') String? fechaEjecucionFin,
      @JsonKey(name: 'estado_orden') String? estadoOrden,
      @JsonKey(name: 'insumos_utilizados') String? insumosUtilizados,
      @JsonKey(name: 'observaciones_gasfitero') String? observacionesGasfitero,
      @JsonKey(name: 'ruta_carpeta_evidencias') String? rutaCarpetaEvidencias,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'trabajo_ejecutado') String? trabajoEjecutado,
      @JsonKey(name: 'problemas') String? problemas,
      @JsonKey(name: 'soluciones') String? soluciones,
      @JsonKey(name: 'comentarios_instrucciones')
      String? comentariosInstrucciones,
      @JsonKey(name: 'latitud') double? latitud,
      @JsonKey(name: 'longitud') double? longitud,
      @JsonKey(name: 'fotos_problema_urls') List<String> fotosProblemaUrls,
      @JsonKey(name: 'fotos_solucion_urls') List<String> fotosSolucionUrls,
      @JsonKey(name: 'reclamo') ReclamoDto? reclamo,
      @JsonKey(name: 'cuadrilla') CuadrillaDto? cuadrilla,
      @JsonKey(name: 'responsable') ResponsableDto? responsable});

  @override
  $ReclamoDtoCopyWith<$Res>? get reclamo;
  @override
  $CuadrillaDtoCopyWith<$Res>? get cuadrilla;
  @override
  $ResponsableDtoCopyWith<$Res>? get responsable;
}

/// @nodoc
class __$$OsDtoImplCopyWithImpl<$Res>
    extends _$OsDtoCopyWithImpl<$Res, _$OsDtoImpl>
    implements _$$OsDtoImplCopyWith<$Res> {
  __$$OsDtoImplCopyWithImpl(
      _$OsDtoImpl _value, $Res Function(_$OsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of OsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? numeroOrden = freezed,
    Object? reclamoId = freezed,
    Object? supervisorId = freezed,
    Object? cuadrillaId = freezed,
    Object? sectorId = freezed,
    Object? fechaProgramacion = freezed,
    Object? fechaEjecucionInicio = freezed,
    Object? fechaEjecucionFin = freezed,
    Object? estadoOrden = freezed,
    Object? insumosUtilizados = freezed,
    Object? observacionesGasfitero = freezed,
    Object? rutaCarpetaEvidencias = freezed,
    Object? createdAt = freezed,
    Object? trabajoEjecutado = freezed,
    Object? problemas = freezed,
    Object? soluciones = freezed,
    Object? comentariosInstrucciones = freezed,
    Object? latitud = freezed,
    Object? longitud = freezed,
    Object? fotosProblemaUrls = null,
    Object? fotosSolucionUrls = null,
    Object? reclamo = freezed,
    Object? cuadrilla = freezed,
    Object? responsable = freezed,
  }) {
    return _then(_$OsDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      numeroOrden: freezed == numeroOrden
          ? _value.numeroOrden
          : numeroOrden // ignore: cast_nullable_to_non_nullable
              as String?,
      reclamoId: freezed == reclamoId
          ? _value.reclamoId
          : reclamoId // ignore: cast_nullable_to_non_nullable
              as int?,
      supervisorId: freezed == supervisorId
          ? _value.supervisorId
          : supervisorId // ignore: cast_nullable_to_non_nullable
              as int?,
      cuadrillaId: freezed == cuadrillaId
          ? _value.cuadrillaId
          : cuadrillaId // ignore: cast_nullable_to_non_nullable
              as int?,
      sectorId: freezed == sectorId
          ? _value.sectorId
          : sectorId // ignore: cast_nullable_to_non_nullable
              as int?,
      fechaProgramacion: freezed == fechaProgramacion
          ? _value.fechaProgramacion
          : fechaProgramacion // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaEjecucionInicio: freezed == fechaEjecucionInicio
          ? _value.fechaEjecucionInicio
          : fechaEjecucionInicio // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaEjecucionFin: freezed == fechaEjecucionFin
          ? _value.fechaEjecucionFin
          : fechaEjecucionFin // ignore: cast_nullable_to_non_nullable
              as String?,
      estadoOrden: freezed == estadoOrden
          ? _value.estadoOrden
          : estadoOrden // ignore: cast_nullable_to_non_nullable
              as String?,
      insumosUtilizados: freezed == insumosUtilizados
          ? _value.insumosUtilizados
          : insumosUtilizados // ignore: cast_nullable_to_non_nullable
              as String?,
      observacionesGasfitero: freezed == observacionesGasfitero
          ? _value.observacionesGasfitero
          : observacionesGasfitero // ignore: cast_nullable_to_non_nullable
              as String?,
      rutaCarpetaEvidencias: freezed == rutaCarpetaEvidencias
          ? _value.rutaCarpetaEvidencias
          : rutaCarpetaEvidencias // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      trabajoEjecutado: freezed == trabajoEjecutado
          ? _value.trabajoEjecutado
          : trabajoEjecutado // ignore: cast_nullable_to_non_nullable
              as String?,
      problemas: freezed == problemas
          ? _value.problemas
          : problemas // ignore: cast_nullable_to_non_nullable
              as String?,
      soluciones: freezed == soluciones
          ? _value.soluciones
          : soluciones // ignore: cast_nullable_to_non_nullable
              as String?,
      comentariosInstrucciones: freezed == comentariosInstrucciones
          ? _value.comentariosInstrucciones
          : comentariosInstrucciones // ignore: cast_nullable_to_non_nullable
              as String?,
      latitud: freezed == latitud
          ? _value.latitud
          : latitud // ignore: cast_nullable_to_non_nullable
              as double?,
      longitud: freezed == longitud
          ? _value.longitud
          : longitud // ignore: cast_nullable_to_non_nullable
              as double?,
      fotosProblemaUrls: null == fotosProblemaUrls
          ? _value._fotosProblemaUrls
          : fotosProblemaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fotosSolucionUrls: null == fotosSolucionUrls
          ? _value._fotosSolucionUrls
          : fotosSolucionUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reclamo: freezed == reclamo
          ? _value.reclamo
          : reclamo // ignore: cast_nullable_to_non_nullable
              as ReclamoDto?,
      cuadrilla: freezed == cuadrilla
          ? _value.cuadrilla
          : cuadrilla // ignore: cast_nullable_to_non_nullable
              as CuadrillaDto?,
      responsable: freezed == responsable
          ? _value.responsable
          : responsable // ignore: cast_nullable_to_non_nullable
              as ResponsableDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OsDtoImpl implements _OsDto {
  const _$OsDtoImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'numero_orden') this.numeroOrden,
      @JsonKey(name: 'reclamo_id') this.reclamoId,
      @JsonKey(name: 'supervisor_id') this.supervisorId,
      @JsonKey(name: 'cuadrilla_id') this.cuadrillaId,
      @JsonKey(name: 'sector_id') this.sectorId,
      @JsonKey(name: 'fecha_programacion') this.fechaProgramacion,
      @JsonKey(name: 'fecha_ejecucion_inicio') this.fechaEjecucionInicio,
      @JsonKey(name: 'fecha_ejecucion_fin') this.fechaEjecucionFin,
      @JsonKey(name: 'estado_orden') this.estadoOrden,
      @JsonKey(name: 'insumos_utilizados') this.insumosUtilizados,
      @JsonKey(name: 'observaciones_gasfitero') this.observacionesGasfitero,
      @JsonKey(name: 'ruta_carpeta_evidencias') this.rutaCarpetaEvidencias,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'trabajo_ejecutado') this.trabajoEjecutado,
      @JsonKey(name: 'problemas') this.problemas,
      @JsonKey(name: 'soluciones') this.soluciones,
      @JsonKey(name: 'comentarios_instrucciones') this.comentariosInstrucciones,
      @JsonKey(name: 'latitud') this.latitud,
      @JsonKey(name: 'longitud') this.longitud,
      @JsonKey(name: 'fotos_problema_urls')
      final List<String> fotosProblemaUrls = const [],
      @JsonKey(name: 'fotos_solucion_urls')
      final List<String> fotosSolucionUrls = const [],
      @JsonKey(name: 'reclamo') this.reclamo,
      @JsonKey(name: 'cuadrilla') this.cuadrilla,
      @JsonKey(name: 'responsable') this.responsable})
      : _fotosProblemaUrls = fotosProblemaUrls,
        _fotosSolucionUrls = fotosSolucionUrls;

  factory _$OsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'numero_orden')
  final String? numeroOrden;
  @override
  @JsonKey(name: 'reclamo_id')
  final int? reclamoId;
  @override
  @JsonKey(name: 'supervisor_id')
  final int? supervisorId;
  @override
  @JsonKey(name: 'cuadrilla_id')
  final int? cuadrillaId;
  @override
  @JsonKey(name: 'sector_id')
  final int? sectorId;
  @override
  @JsonKey(name: 'fecha_programacion')
  final String? fechaProgramacion;
  @override
  @JsonKey(name: 'fecha_ejecucion_inicio')
  final String? fechaEjecucionInicio;
  @override
  @JsonKey(name: 'fecha_ejecucion_fin')
  final String? fechaEjecucionFin;
  @override
  @JsonKey(name: 'estado_orden')
  final String? estadoOrden;
  @override
  @JsonKey(name: 'insumos_utilizados')
  final String? insumosUtilizados;
  @override
  @JsonKey(name: 'observaciones_gasfitero')
  final String? observacionesGasfitero;
  @override
  @JsonKey(name: 'ruta_carpeta_evidencias')
  final String? rutaCarpetaEvidencias;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'trabajo_ejecutado')
  final String? trabajoEjecutado;
  @override
  @JsonKey(name: 'problemas')
  final String? problemas;
  @override
  @JsonKey(name: 'soluciones')
  final String? soluciones;
  @override
  @JsonKey(name: 'comentarios_instrucciones')
  final String? comentariosInstrucciones;
  @override
  @JsonKey(name: 'latitud')
  final double? latitud;
  @override
  @JsonKey(name: 'longitud')
  final double? longitud;
  final List<String> _fotosProblemaUrls;
  @override
  @JsonKey(name: 'fotos_problema_urls')
  List<String> get fotosProblemaUrls {
    if (_fotosProblemaUrls is EqualUnmodifiableListView)
      return _fotosProblemaUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fotosProblemaUrls);
  }

  final List<String> _fotosSolucionUrls;
  @override
  @JsonKey(name: 'fotos_solucion_urls')
  List<String> get fotosSolucionUrls {
    if (_fotosSolucionUrls is EqualUnmodifiableListView)
      return _fotosSolucionUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fotosSolucionUrls);
  }

  @override
  @JsonKey(name: 'reclamo')
  final ReclamoDto? reclamo;
  @override
  @JsonKey(name: 'cuadrilla')
  final CuadrillaDto? cuadrilla;
  @override
  @JsonKey(name: 'responsable')
  final ResponsableDto? responsable;

  @override
  String toString() {
    return 'OsDto(id: $id, numeroOrden: $numeroOrden, reclamoId: $reclamoId, supervisorId: $supervisorId, cuadrillaId: $cuadrillaId, sectorId: $sectorId, fechaProgramacion: $fechaProgramacion, fechaEjecucionInicio: $fechaEjecucionInicio, fechaEjecucionFin: $fechaEjecucionFin, estadoOrden: $estadoOrden, insumosUtilizados: $insumosUtilizados, observacionesGasfitero: $observacionesGasfitero, rutaCarpetaEvidencias: $rutaCarpetaEvidencias, createdAt: $createdAt, trabajoEjecutado: $trabajoEjecutado, problemas: $problemas, soluciones: $soluciones, comentariosInstrucciones: $comentariosInstrucciones, latitud: $latitud, longitud: $longitud, fotosProblemaUrls: $fotosProblemaUrls, fotosSolucionUrls: $fotosSolucionUrls, reclamo: $reclamo, cuadrilla: $cuadrilla, responsable: $responsable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OsDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.numeroOrden, numeroOrden) ||
                other.numeroOrden == numeroOrden) &&
            (identical(other.reclamoId, reclamoId) ||
                other.reclamoId == reclamoId) &&
            (identical(other.supervisorId, supervisorId) ||
                other.supervisorId == supervisorId) &&
            (identical(other.cuadrillaId, cuadrillaId) ||
                other.cuadrillaId == cuadrillaId) &&
            (identical(other.sectorId, sectorId) ||
                other.sectorId == sectorId) &&
            (identical(other.fechaProgramacion, fechaProgramacion) ||
                other.fechaProgramacion == fechaProgramacion) &&
            (identical(other.fechaEjecucionInicio, fechaEjecucionInicio) ||
                other.fechaEjecucionInicio == fechaEjecucionInicio) &&
            (identical(other.fechaEjecucionFin, fechaEjecucionFin) ||
                other.fechaEjecucionFin == fechaEjecucionFin) &&
            (identical(other.estadoOrden, estadoOrden) ||
                other.estadoOrden == estadoOrden) &&
            (identical(other.insumosUtilizados, insumosUtilizados) ||
                other.insumosUtilizados == insumosUtilizados) &&
            (identical(other.observacionesGasfitero, observacionesGasfitero) ||
                other.observacionesGasfitero == observacionesGasfitero) &&
            (identical(other.rutaCarpetaEvidencias, rutaCarpetaEvidencias) ||
                other.rutaCarpetaEvidencias == rutaCarpetaEvidencias) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.trabajoEjecutado, trabajoEjecutado) ||
                other.trabajoEjecutado == trabajoEjecutado) &&
            (identical(other.problemas, problemas) ||
                other.problemas == problemas) &&
            (identical(other.soluciones, soluciones) ||
                other.soluciones == soluciones) &&
            (identical(
                    other.comentariosInstrucciones, comentariosInstrucciones) ||
                other.comentariosInstrucciones == comentariosInstrucciones) &&
            (identical(other.latitud, latitud) || other.latitud == latitud) &&
            (identical(other.longitud, longitud) ||
                other.longitud == longitud) &&
            const DeepCollectionEquality()
                .equals(other._fotosProblemaUrls, _fotosProblemaUrls) &&
            const DeepCollectionEquality()
                .equals(other._fotosSolucionUrls, _fotosSolucionUrls) &&
            (identical(other.reclamo, reclamo) || other.reclamo == reclamo) &&
            (identical(other.cuadrilla, cuadrilla) ||
                other.cuadrilla == cuadrilla) &&
            (identical(other.responsable, responsable) ||
                other.responsable == responsable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        numeroOrden,
        reclamoId,
        supervisorId,
        cuadrillaId,
        sectorId,
        fechaProgramacion,
        fechaEjecucionInicio,
        fechaEjecucionFin,
        estadoOrden,
        insumosUtilizados,
        observacionesGasfitero,
        rutaCarpetaEvidencias,
        createdAt,
        trabajoEjecutado,
        problemas,
        soluciones,
        comentariosInstrucciones,
        latitud,
        longitud,
        const DeepCollectionEquality().hash(_fotosProblemaUrls),
        const DeepCollectionEquality().hash(_fotosSolucionUrls),
        reclamo,
        cuadrilla,
        responsable
      ]);

  /// Create a copy of OsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OsDtoImplCopyWith<_$OsDtoImpl> get copyWith =>
      __$$OsDtoImplCopyWithImpl<_$OsDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OsDtoImplToJson(
      this,
    );
  }
}

abstract class _OsDto implements OsDto {
  const factory _OsDto(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'numero_orden') final String? numeroOrden,
          @JsonKey(name: 'reclamo_id') final int? reclamoId,
          @JsonKey(name: 'supervisor_id') final int? supervisorId,
          @JsonKey(name: 'cuadrilla_id') final int? cuadrillaId,
          @JsonKey(name: 'sector_id') final int? sectorId,
          @JsonKey(name: 'fecha_programacion') final String? fechaProgramacion,
          @JsonKey(name: 'fecha_ejecucion_inicio')
          final String? fechaEjecucionInicio,
          @JsonKey(name: 'fecha_ejecucion_fin') final String? fechaEjecucionFin,
          @JsonKey(name: 'estado_orden') final String? estadoOrden,
          @JsonKey(name: 'insumos_utilizados') final String? insumosUtilizados,
          @JsonKey(name: 'observaciones_gasfitero')
          final String? observacionesGasfitero,
          @JsonKey(name: 'ruta_carpeta_evidencias')
          final String? rutaCarpetaEvidencias,
          @JsonKey(name: 'created_at') final String? createdAt,
          @JsonKey(name: 'trabajo_ejecutado') final String? trabajoEjecutado,
          @JsonKey(name: 'problemas') final String? problemas,
          @JsonKey(name: 'soluciones') final String? soluciones,
          @JsonKey(name: 'comentarios_instrucciones')
          final String? comentariosInstrucciones,
          @JsonKey(name: 'latitud') final double? latitud,
          @JsonKey(name: 'longitud') final double? longitud,
          @JsonKey(name: 'fotos_problema_urls')
          final List<String> fotosProblemaUrls,
          @JsonKey(name: 'fotos_solucion_urls')
          final List<String> fotosSolucionUrls,
          @JsonKey(name: 'reclamo') final ReclamoDto? reclamo,
          @JsonKey(name: 'cuadrilla') final CuadrillaDto? cuadrilla,
          @JsonKey(name: 'responsable') final ResponsableDto? responsable}) =
      _$OsDtoImpl;

  factory _OsDto.fromJson(Map<String, dynamic> json) = _$OsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'numero_orden')
  String? get numeroOrden;
  @override
  @JsonKey(name: 'reclamo_id')
  int? get reclamoId;
  @override
  @JsonKey(name: 'supervisor_id')
  int? get supervisorId;
  @override
  @JsonKey(name: 'cuadrilla_id')
  int? get cuadrillaId;
  @override
  @JsonKey(name: 'sector_id')
  int? get sectorId;
  @override
  @JsonKey(name: 'fecha_programacion')
  String? get fechaProgramacion;
  @override
  @JsonKey(name: 'fecha_ejecucion_inicio')
  String? get fechaEjecucionInicio;
  @override
  @JsonKey(name: 'fecha_ejecucion_fin')
  String? get fechaEjecucionFin;
  @override
  @JsonKey(name: 'estado_orden')
  String? get estadoOrden;
  @override
  @JsonKey(name: 'insumos_utilizados')
  String? get insumosUtilizados;
  @override
  @JsonKey(name: 'observaciones_gasfitero')
  String? get observacionesGasfitero;
  @override
  @JsonKey(name: 'ruta_carpeta_evidencias')
  String? get rutaCarpetaEvidencias;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'trabajo_ejecutado')
  String? get trabajoEjecutado;
  @override
  @JsonKey(name: 'problemas')
  String? get problemas;
  @override
  @JsonKey(name: 'soluciones')
  String? get soluciones;
  @override
  @JsonKey(name: 'comentarios_instrucciones')
  String? get comentariosInstrucciones;
  @override
  @JsonKey(name: 'latitud')
  double? get latitud;
  @override
  @JsonKey(name: 'longitud')
  double? get longitud;
  @override
  @JsonKey(name: 'fotos_problema_urls')
  List<String> get fotosProblemaUrls;
  @override
  @JsonKey(name: 'fotos_solucion_urls')
  List<String> get fotosSolucionUrls;
  @override
  @JsonKey(name: 'reclamo')
  ReclamoDto? get reclamo;
  @override
  @JsonKey(name: 'cuadrilla')
  CuadrillaDto? get cuadrilla;
  @override
  @JsonKey(name: 'responsable')
  ResponsableDto? get responsable;

  /// Create a copy of OsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OsDtoImplCopyWith<_$OsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
