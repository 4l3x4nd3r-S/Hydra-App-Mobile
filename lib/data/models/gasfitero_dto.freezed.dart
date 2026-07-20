// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gasfitero_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GasfiteroDto _$GasfiteroDtoFromJson(Map<String, dynamic> json) {
  return _GasfiteroDto.fromJson(json);
}

/// @nodoc
mixin _$GasfiteroDto {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'nombre')
  String? get nombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'codigo_empleado')
  String? get codigoEmpleado => throw _privateConstructorUsedError;
  @JsonKey(name: 'dni')
  String? get dni => throw _privateConstructorUsedError;
  @JsonKey(name: 'celular')
  String? get celular => throw _privateConstructorUsedError;
  @JsonKey(name: 'cargo')
  String? get cargo => throw _privateConstructorUsedError;
  @JsonKey(name: 'cargo_visible')
  String? get cargoVisible => throw _privateConstructorUsedError;
  @JsonKey(name: 'area')
  String? get area => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_visible')
  String? get areaVisible => throw _privateConstructorUsedError;
  @JsonKey(name: 'rol_en_cuadrilla')
  String? get rolEnCuadrilla => throw _privateConstructorUsedError;
  @JsonKey(name: 'funcion_visible')
  String? get funcionVisible => throw _privateConstructorUsedError;
  @JsonKey(name: 'es_principal')
  bool get esPrincipal => throw _privateConstructorUsedError;
  @JsonKey(name: 'puede_ser_gasfitero')
  bool get puedeSerGasfitero => throw _privateConstructorUsedError;
  @JsonKey(name: 'puede_ser_chofer')
  bool get puedeSerChofer => throw _privateConstructorUsedError;
  @JsonKey(name: 'cuadrilla_id')
  int? get cuadrillaId => throw _privateConstructorUsedError;
  @JsonKey(name: 'codigo_cuadrilla')
  String? get codigoCuadrilla => throw _privateConstructorUsedError;

  /// Serializes this GasfiteroDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GasfiteroDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GasfiteroDtoCopyWith<GasfiteroDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GasfiteroDtoCopyWith<$Res> {
  factory $GasfiteroDtoCopyWith(
          GasfiteroDto value, $Res Function(GasfiteroDto) then) =
      _$GasfiteroDtoCopyWithImpl<$Res, GasfiteroDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'nombre') String? nombre,
      @JsonKey(name: 'codigo_empleado') String? codigoEmpleado,
      @JsonKey(name: 'dni') String? dni,
      @JsonKey(name: 'celular') String? celular,
      @JsonKey(name: 'cargo') String? cargo,
      @JsonKey(name: 'cargo_visible') String? cargoVisible,
      @JsonKey(name: 'area') String? area,
      @JsonKey(name: 'area_visible') String? areaVisible,
      @JsonKey(name: 'rol_en_cuadrilla') String? rolEnCuadrilla,
      @JsonKey(name: 'funcion_visible') String? funcionVisible,
      @JsonKey(name: 'es_principal') bool esPrincipal,
      @JsonKey(name: 'puede_ser_gasfitero') bool puedeSerGasfitero,
      @JsonKey(name: 'puede_ser_chofer') bool puedeSerChofer,
      @JsonKey(name: 'cuadrilla_id') int? cuadrillaId,
      @JsonKey(name: 'codigo_cuadrilla') String? codigoCuadrilla});
}

/// @nodoc
class _$GasfiteroDtoCopyWithImpl<$Res, $Val extends GasfiteroDto>
    implements $GasfiteroDtoCopyWith<$Res> {
  _$GasfiteroDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GasfiteroDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = freezed,
    Object? codigoEmpleado = freezed,
    Object? dni = freezed,
    Object? celular = freezed,
    Object? cargo = freezed,
    Object? cargoVisible = freezed,
    Object? area = freezed,
    Object? areaVisible = freezed,
    Object? rolEnCuadrilla = freezed,
    Object? funcionVisible = freezed,
    Object? esPrincipal = null,
    Object? puedeSerGasfitero = null,
    Object? puedeSerChofer = null,
    Object? cuadrillaId = freezed,
    Object? codigoCuadrilla = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: freezed == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String?,
      codigoEmpleado: freezed == codigoEmpleado
          ? _value.codigoEmpleado
          : codigoEmpleado // ignore: cast_nullable_to_non_nullable
              as String?,
      dni: freezed == dni
          ? _value.dni
          : dni // ignore: cast_nullable_to_non_nullable
              as String?,
      celular: freezed == celular
          ? _value.celular
          : celular // ignore: cast_nullable_to_non_nullable
              as String?,
      cargo: freezed == cargo
          ? _value.cargo
          : cargo // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoVisible: freezed == cargoVisible
          ? _value.cargoVisible
          : cargoVisible // ignore: cast_nullable_to_non_nullable
              as String?,
      area: freezed == area
          ? _value.area
          : area // ignore: cast_nullable_to_non_nullable
              as String?,
      areaVisible: freezed == areaVisible
          ? _value.areaVisible
          : areaVisible // ignore: cast_nullable_to_non_nullable
              as String?,
      rolEnCuadrilla: freezed == rolEnCuadrilla
          ? _value.rolEnCuadrilla
          : rolEnCuadrilla // ignore: cast_nullable_to_non_nullable
              as String?,
      funcionVisible: freezed == funcionVisible
          ? _value.funcionVisible
          : funcionVisible // ignore: cast_nullable_to_non_nullable
              as String?,
      esPrincipal: null == esPrincipal
          ? _value.esPrincipal
          : esPrincipal // ignore: cast_nullable_to_non_nullable
              as bool,
      puedeSerGasfitero: null == puedeSerGasfitero
          ? _value.puedeSerGasfitero
          : puedeSerGasfitero // ignore: cast_nullable_to_non_nullable
              as bool,
      puedeSerChofer: null == puedeSerChofer
          ? _value.puedeSerChofer
          : puedeSerChofer // ignore: cast_nullable_to_non_nullable
              as bool,
      cuadrillaId: freezed == cuadrillaId
          ? _value.cuadrillaId
          : cuadrillaId // ignore: cast_nullable_to_non_nullable
              as int?,
      codigoCuadrilla: freezed == codigoCuadrilla
          ? _value.codigoCuadrilla
          : codigoCuadrilla // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GasfiteroDtoImplCopyWith<$Res>
    implements $GasfiteroDtoCopyWith<$Res> {
  factory _$$GasfiteroDtoImplCopyWith(
          _$GasfiteroDtoImpl value, $Res Function(_$GasfiteroDtoImpl) then) =
      __$$GasfiteroDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'nombre') String? nombre,
      @JsonKey(name: 'codigo_empleado') String? codigoEmpleado,
      @JsonKey(name: 'dni') String? dni,
      @JsonKey(name: 'celular') String? celular,
      @JsonKey(name: 'cargo') String? cargo,
      @JsonKey(name: 'cargo_visible') String? cargoVisible,
      @JsonKey(name: 'area') String? area,
      @JsonKey(name: 'area_visible') String? areaVisible,
      @JsonKey(name: 'rol_en_cuadrilla') String? rolEnCuadrilla,
      @JsonKey(name: 'funcion_visible') String? funcionVisible,
      @JsonKey(name: 'es_principal') bool esPrincipal,
      @JsonKey(name: 'puede_ser_gasfitero') bool puedeSerGasfitero,
      @JsonKey(name: 'puede_ser_chofer') bool puedeSerChofer,
      @JsonKey(name: 'cuadrilla_id') int? cuadrillaId,
      @JsonKey(name: 'codigo_cuadrilla') String? codigoCuadrilla});
}

/// @nodoc
class __$$GasfiteroDtoImplCopyWithImpl<$Res>
    extends _$GasfiteroDtoCopyWithImpl<$Res, _$GasfiteroDtoImpl>
    implements _$$GasfiteroDtoImplCopyWith<$Res> {
  __$$GasfiteroDtoImplCopyWithImpl(
      _$GasfiteroDtoImpl _value, $Res Function(_$GasfiteroDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of GasfiteroDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = freezed,
    Object? codigoEmpleado = freezed,
    Object? dni = freezed,
    Object? celular = freezed,
    Object? cargo = freezed,
    Object? cargoVisible = freezed,
    Object? area = freezed,
    Object? areaVisible = freezed,
    Object? rolEnCuadrilla = freezed,
    Object? funcionVisible = freezed,
    Object? esPrincipal = null,
    Object? puedeSerGasfitero = null,
    Object? puedeSerChofer = null,
    Object? cuadrillaId = freezed,
    Object? codigoCuadrilla = freezed,
  }) {
    return _then(_$GasfiteroDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: freezed == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String?,
      codigoEmpleado: freezed == codigoEmpleado
          ? _value.codigoEmpleado
          : codigoEmpleado // ignore: cast_nullable_to_non_nullable
              as String?,
      dni: freezed == dni
          ? _value.dni
          : dni // ignore: cast_nullable_to_non_nullable
              as String?,
      celular: freezed == celular
          ? _value.celular
          : celular // ignore: cast_nullable_to_non_nullable
              as String?,
      cargo: freezed == cargo
          ? _value.cargo
          : cargo // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoVisible: freezed == cargoVisible
          ? _value.cargoVisible
          : cargoVisible // ignore: cast_nullable_to_non_nullable
              as String?,
      area: freezed == area
          ? _value.area
          : area // ignore: cast_nullable_to_non_nullable
              as String?,
      areaVisible: freezed == areaVisible
          ? _value.areaVisible
          : areaVisible // ignore: cast_nullable_to_non_nullable
              as String?,
      rolEnCuadrilla: freezed == rolEnCuadrilla
          ? _value.rolEnCuadrilla
          : rolEnCuadrilla // ignore: cast_nullable_to_non_nullable
              as String?,
      funcionVisible: freezed == funcionVisible
          ? _value.funcionVisible
          : funcionVisible // ignore: cast_nullable_to_non_nullable
              as String?,
      esPrincipal: null == esPrincipal
          ? _value.esPrincipal
          : esPrincipal // ignore: cast_nullable_to_non_nullable
              as bool,
      puedeSerGasfitero: null == puedeSerGasfitero
          ? _value.puedeSerGasfitero
          : puedeSerGasfitero // ignore: cast_nullable_to_non_nullable
              as bool,
      puedeSerChofer: null == puedeSerChofer
          ? _value.puedeSerChofer
          : puedeSerChofer // ignore: cast_nullable_to_non_nullable
              as bool,
      cuadrillaId: freezed == cuadrillaId
          ? _value.cuadrillaId
          : cuadrillaId // ignore: cast_nullable_to_non_nullable
              as int?,
      codigoCuadrilla: freezed == codigoCuadrilla
          ? _value.codigoCuadrilla
          : codigoCuadrilla // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GasfiteroDtoImpl implements _GasfiteroDto {
  const _$GasfiteroDtoImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'nombre') this.nombre,
      @JsonKey(name: 'codigo_empleado') this.codigoEmpleado,
      @JsonKey(name: 'dni') this.dni,
      @JsonKey(name: 'celular') this.celular,
      @JsonKey(name: 'cargo') this.cargo,
      @JsonKey(name: 'cargo_visible') this.cargoVisible,
      @JsonKey(name: 'area') this.area,
      @JsonKey(name: 'area_visible') this.areaVisible,
      @JsonKey(name: 'rol_en_cuadrilla') this.rolEnCuadrilla,
      @JsonKey(name: 'funcion_visible') this.funcionVisible,
      @JsonKey(name: 'es_principal') this.esPrincipal = false,
      @JsonKey(name: 'puede_ser_gasfitero') this.puedeSerGasfitero = false,
      @JsonKey(name: 'puede_ser_chofer') this.puedeSerChofer = false,
      @JsonKey(name: 'cuadrilla_id') this.cuadrillaId,
      @JsonKey(name: 'codigo_cuadrilla') this.codigoCuadrilla});

  factory _$GasfiteroDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GasfiteroDtoImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'nombre')
  final String? nombre;
  @override
  @JsonKey(name: 'codigo_empleado')
  final String? codigoEmpleado;
  @override
  @JsonKey(name: 'dni')
  final String? dni;
  @override
  @JsonKey(name: 'celular')
  final String? celular;
  @override
  @JsonKey(name: 'cargo')
  final String? cargo;
  @override
  @JsonKey(name: 'cargo_visible')
  final String? cargoVisible;
  @override
  @JsonKey(name: 'area')
  final String? area;
  @override
  @JsonKey(name: 'area_visible')
  final String? areaVisible;
  @override
  @JsonKey(name: 'rol_en_cuadrilla')
  final String? rolEnCuadrilla;
  @override
  @JsonKey(name: 'funcion_visible')
  final String? funcionVisible;
  @override
  @JsonKey(name: 'es_principal')
  final bool esPrincipal;
  @override
  @JsonKey(name: 'puede_ser_gasfitero')
  final bool puedeSerGasfitero;
  @override
  @JsonKey(name: 'puede_ser_chofer')
  final bool puedeSerChofer;
  @override
  @JsonKey(name: 'cuadrilla_id')
  final int? cuadrillaId;
  @override
  @JsonKey(name: 'codigo_cuadrilla')
  final String? codigoCuadrilla;

  @override
  String toString() {
    return 'GasfiteroDto(id: $id, nombre: $nombre, codigoEmpleado: $codigoEmpleado, dni: $dni, celular: $celular, cargo: $cargo, cargoVisible: $cargoVisible, area: $area, areaVisible: $areaVisible, rolEnCuadrilla: $rolEnCuadrilla, funcionVisible: $funcionVisible, esPrincipal: $esPrincipal, puedeSerGasfitero: $puedeSerGasfitero, puedeSerChofer: $puedeSerChofer, cuadrillaId: $cuadrillaId, codigoCuadrilla: $codigoCuadrilla)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GasfiteroDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.codigoEmpleado, codigoEmpleado) ||
                other.codigoEmpleado == codigoEmpleado) &&
            (identical(other.dni, dni) || other.dni == dni) &&
            (identical(other.celular, celular) || other.celular == celular) &&
            (identical(other.cargo, cargo) || other.cargo == cargo) &&
            (identical(other.cargoVisible, cargoVisible) ||
                other.cargoVisible == cargoVisible) &&
            (identical(other.area, area) || other.area == area) &&
            (identical(other.areaVisible, areaVisible) ||
                other.areaVisible == areaVisible) &&
            (identical(other.rolEnCuadrilla, rolEnCuadrilla) ||
                other.rolEnCuadrilla == rolEnCuadrilla) &&
            (identical(other.funcionVisible, funcionVisible) ||
                other.funcionVisible == funcionVisible) &&
            (identical(other.esPrincipal, esPrincipal) ||
                other.esPrincipal == esPrincipal) &&
            (identical(other.puedeSerGasfitero, puedeSerGasfitero) ||
                other.puedeSerGasfitero == puedeSerGasfitero) &&
            (identical(other.puedeSerChofer, puedeSerChofer) ||
                other.puedeSerChofer == puedeSerChofer) &&
            (identical(other.cuadrillaId, cuadrillaId) ||
                other.cuadrillaId == cuadrillaId) &&
            (identical(other.codigoCuadrilla, codigoCuadrilla) ||
                other.codigoCuadrilla == codigoCuadrilla));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nombre,
      codigoEmpleado,
      dni,
      celular,
      cargo,
      cargoVisible,
      area,
      areaVisible,
      rolEnCuadrilla,
      funcionVisible,
      esPrincipal,
      puedeSerGasfitero,
      puedeSerChofer,
      cuadrillaId,
      codigoCuadrilla);

  /// Create a copy of GasfiteroDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GasfiteroDtoImplCopyWith<_$GasfiteroDtoImpl> get copyWith =>
      __$$GasfiteroDtoImplCopyWithImpl<_$GasfiteroDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GasfiteroDtoImplToJson(
      this,
    );
  }
}

abstract class _GasfiteroDto implements GasfiteroDto {
  const factory _GasfiteroDto(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'nombre') final String? nombre,
          @JsonKey(name: 'codigo_empleado') final String? codigoEmpleado,
          @JsonKey(name: 'dni') final String? dni,
          @JsonKey(name: 'celular') final String? celular,
          @JsonKey(name: 'cargo') final String? cargo,
          @JsonKey(name: 'cargo_visible') final String? cargoVisible,
          @JsonKey(name: 'area') final String? area,
          @JsonKey(name: 'area_visible') final String? areaVisible,
          @JsonKey(name: 'rol_en_cuadrilla') final String? rolEnCuadrilla,
          @JsonKey(name: 'funcion_visible') final String? funcionVisible,
          @JsonKey(name: 'es_principal') final bool esPrincipal,
          @JsonKey(name: 'puede_ser_gasfitero') final bool puedeSerGasfitero,
          @JsonKey(name: 'puede_ser_chofer') final bool puedeSerChofer,
          @JsonKey(name: 'cuadrilla_id') final int? cuadrillaId,
          @JsonKey(name: 'codigo_cuadrilla') final String? codigoCuadrilla}) =
      _$GasfiteroDtoImpl;

  factory _GasfiteroDto.fromJson(Map<String, dynamic> json) =
      _$GasfiteroDtoImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'nombre')
  String? get nombre;
  @override
  @JsonKey(name: 'codigo_empleado')
  String? get codigoEmpleado;
  @override
  @JsonKey(name: 'dni')
  String? get dni;
  @override
  @JsonKey(name: 'celular')
  String? get celular;
  @override
  @JsonKey(name: 'cargo')
  String? get cargo;
  @override
  @JsonKey(name: 'cargo_visible')
  String? get cargoVisible;
  @override
  @JsonKey(name: 'area')
  String? get area;
  @override
  @JsonKey(name: 'area_visible')
  String? get areaVisible;
  @override
  @JsonKey(name: 'rol_en_cuadrilla')
  String? get rolEnCuadrilla;
  @override
  @JsonKey(name: 'funcion_visible')
  String? get funcionVisible;
  @override
  @JsonKey(name: 'es_principal')
  bool get esPrincipal;
  @override
  @JsonKey(name: 'puede_ser_gasfitero')
  bool get puedeSerGasfitero;
  @override
  @JsonKey(name: 'puede_ser_chofer')
  bool get puedeSerChofer;
  @override
  @JsonKey(name: 'cuadrilla_id')
  int? get cuadrillaId;
  @override
  @JsonKey(name: 'codigo_cuadrilla')
  String? get codigoCuadrilla;

  /// Create a copy of GasfiteroDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GasfiteroDtoImplCopyWith<_$GasfiteroDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
