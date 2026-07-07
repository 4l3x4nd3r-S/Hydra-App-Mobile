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
  @JsonKey(name: 'cargo')
  String? get cargo => throw _privateConstructorUsedError;
  @JsonKey(name: 'area')
  String? get area => throw _privateConstructorUsedError;
  @JsonKey(name: 'rol_en_cuadrilla')
  String? get rolEnCuadrilla => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'cargo') String? cargo,
      @JsonKey(name: 'area') String? area,
      @JsonKey(name: 'rol_en_cuadrilla') String? rolEnCuadrilla});
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
    Object? cargo = freezed,
    Object? area = freezed,
    Object? rolEnCuadrilla = freezed,
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
      cargo: freezed == cargo
          ? _value.cargo
          : cargo // ignore: cast_nullable_to_non_nullable
              as String?,
      area: freezed == area
          ? _value.area
          : area // ignore: cast_nullable_to_non_nullable
              as String?,
      rolEnCuadrilla: freezed == rolEnCuadrilla
          ? _value.rolEnCuadrilla
          : rolEnCuadrilla // ignore: cast_nullable_to_non_nullable
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
      @JsonKey(name: 'cargo') String? cargo,
      @JsonKey(name: 'area') String? area,
      @JsonKey(name: 'rol_en_cuadrilla') String? rolEnCuadrilla});
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
    Object? cargo = freezed,
    Object? area = freezed,
    Object? rolEnCuadrilla = freezed,
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
      cargo: freezed == cargo
          ? _value.cargo
          : cargo // ignore: cast_nullable_to_non_nullable
              as String?,
      area: freezed == area
          ? _value.area
          : area // ignore: cast_nullable_to_non_nullable
              as String?,
      rolEnCuadrilla: freezed == rolEnCuadrilla
          ? _value.rolEnCuadrilla
          : rolEnCuadrilla // ignore: cast_nullable_to_non_nullable
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
      @JsonKey(name: 'cargo') this.cargo,
      @JsonKey(name: 'area') this.area,
      @JsonKey(name: 'rol_en_cuadrilla') this.rolEnCuadrilla});

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
  @JsonKey(name: 'cargo')
  final String? cargo;
  @override
  @JsonKey(name: 'area')
  final String? area;
  @override
  @JsonKey(name: 'rol_en_cuadrilla')
  final String? rolEnCuadrilla;

  @override
  String toString() {
    return 'GasfiteroDto(id: $id, nombre: $nombre, codigoEmpleado: $codigoEmpleado, cargo: $cargo, area: $area, rolEnCuadrilla: $rolEnCuadrilla)';
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
            (identical(other.cargo, cargo) || other.cargo == cargo) &&
            (identical(other.area, area) || other.area == area) &&
            (identical(other.rolEnCuadrilla, rolEnCuadrilla) ||
                other.rolEnCuadrilla == rolEnCuadrilla));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, nombre, codigoEmpleado, cargo, area, rolEnCuadrilla);

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
          @JsonKey(name: 'cargo') final String? cargo,
          @JsonKey(name: 'area') final String? area,
          @JsonKey(name: 'rol_en_cuadrilla') final String? rolEnCuadrilla}) =
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
  @JsonKey(name: 'cargo')
  String? get cargo;
  @override
  @JsonKey(name: 'area')
  String? get area;
  @override
  @JsonKey(name: 'rol_en_cuadrilla')
  String? get rolEnCuadrilla;

  /// Create a copy of GasfiteroDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GasfiteroDtoImplCopyWith<_$GasfiteroDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
