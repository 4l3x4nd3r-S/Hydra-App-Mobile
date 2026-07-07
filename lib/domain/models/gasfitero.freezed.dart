// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gasfitero.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Gasfitero {
  int get id => throw _privateConstructorUsedError;
  String? get nombre => throw _privateConstructorUsedError;
  String? get codigoEmpleado => throw _privateConstructorUsedError;
  String? get cargo => throw _privateConstructorUsedError;
  String? get area => throw _privateConstructorUsedError;

  /// Create a copy of Gasfitero
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GasfiteroCopyWith<Gasfitero> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GasfiteroCopyWith<$Res> {
  factory $GasfiteroCopyWith(Gasfitero value, $Res Function(Gasfitero) then) =
      _$GasfiteroCopyWithImpl<$Res, Gasfitero>;
  @useResult
  $Res call(
      {int id,
      String? nombre,
      String? codigoEmpleado,
      String? cargo,
      String? area});
}

/// @nodoc
class _$GasfiteroCopyWithImpl<$Res, $Val extends Gasfitero>
    implements $GasfiteroCopyWith<$Res> {
  _$GasfiteroCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Gasfitero
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = freezed,
    Object? codigoEmpleado = freezed,
    Object? cargo = freezed,
    Object? area = freezed,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GasfiteroImplCopyWith<$Res>
    implements $GasfiteroCopyWith<$Res> {
  factory _$$GasfiteroImplCopyWith(
          _$GasfiteroImpl value, $Res Function(_$GasfiteroImpl) then) =
      __$$GasfiteroImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String? nombre,
      String? codigoEmpleado,
      String? cargo,
      String? area});
}

/// @nodoc
class __$$GasfiteroImplCopyWithImpl<$Res>
    extends _$GasfiteroCopyWithImpl<$Res, _$GasfiteroImpl>
    implements _$$GasfiteroImplCopyWith<$Res> {
  __$$GasfiteroImplCopyWithImpl(
      _$GasfiteroImpl _value, $Res Function(_$GasfiteroImpl) _then)
      : super(_value, _then);

  /// Create a copy of Gasfitero
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = freezed,
    Object? codigoEmpleado = freezed,
    Object? cargo = freezed,
    Object? area = freezed,
  }) {
    return _then(_$GasfiteroImpl(
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
    ));
  }
}

/// @nodoc

class _$GasfiteroImpl implements _Gasfitero {
  const _$GasfiteroImpl(
      {required this.id,
      this.nombre,
      this.codigoEmpleado,
      this.cargo,
      this.area});

  @override
  final int id;
  @override
  final String? nombre;
  @override
  final String? codigoEmpleado;
  @override
  final String? cargo;
  @override
  final String? area;

  @override
  String toString() {
    return 'Gasfitero(id: $id, nombre: $nombre, codigoEmpleado: $codigoEmpleado, cargo: $cargo, area: $area)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GasfiteroImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.codigoEmpleado, codigoEmpleado) ||
                other.codigoEmpleado == codigoEmpleado) &&
            (identical(other.cargo, cargo) || other.cargo == cargo) &&
            (identical(other.area, area) || other.area == area));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nombre, codigoEmpleado, cargo, area);

  /// Create a copy of Gasfitero
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GasfiteroImplCopyWith<_$GasfiteroImpl> get copyWith =>
      __$$GasfiteroImplCopyWithImpl<_$GasfiteroImpl>(this, _$identity);
}

abstract class _Gasfitero implements Gasfitero {
  const factory _Gasfitero(
      {required final int id,
      final String? nombre,
      final String? codigoEmpleado,
      final String? cargo,
      final String? area}) = _$GasfiteroImpl;

  @override
  int get id;
  @override
  String? get nombre;
  @override
  String? get codigoEmpleado;
  @override
  String? get cargo;
  @override
  String? get area;

  /// Create a copy of Gasfitero
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GasfiteroImplCopyWith<_$GasfiteroImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
