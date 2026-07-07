// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cuadrilla.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Cuadrilla {
  int get id => throw _privateConstructorUsedError;
  String? get codigoGrupo => throw _privateConstructorUsedError;
  String? get especialidad => throw _privateConstructorUsedError;
  Gasfitero? get lider => throw _privateConstructorUsedError;
  List<Gasfitero> get apoyos => throw _privateConstructorUsedError;
  Gasfitero? get chofer => throw _privateConstructorUsedError;
  Gasfitero? get operador => throw _privateConstructorUsedError;

  /// Create a copy of Cuadrilla
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CuadrillaCopyWith<Cuadrilla> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CuadrillaCopyWith<$Res> {
  factory $CuadrillaCopyWith(Cuadrilla value, $Res Function(Cuadrilla) then) =
      _$CuadrillaCopyWithImpl<$Res, Cuadrilla>;
  @useResult
  $Res call(
      {int id,
      String? codigoGrupo,
      String? especialidad,
      Gasfitero? lider,
      List<Gasfitero> apoyos,
      Gasfitero? chofer,
      Gasfitero? operador});

  $GasfiteroCopyWith<$Res>? get lider;
  $GasfiteroCopyWith<$Res>? get chofer;
  $GasfiteroCopyWith<$Res>? get operador;
}

/// @nodoc
class _$CuadrillaCopyWithImpl<$Res, $Val extends Cuadrilla>
    implements $CuadrillaCopyWith<$Res> {
  _$CuadrillaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cuadrilla
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigoGrupo = freezed,
    Object? especialidad = freezed,
    Object? lider = freezed,
    Object? apoyos = null,
    Object? chofer = freezed,
    Object? operador = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      codigoGrupo: freezed == codigoGrupo
          ? _value.codigoGrupo
          : codigoGrupo // ignore: cast_nullable_to_non_nullable
              as String?,
      especialidad: freezed == especialidad
          ? _value.especialidad
          : especialidad // ignore: cast_nullable_to_non_nullable
              as String?,
      lider: freezed == lider
          ? _value.lider
          : lider // ignore: cast_nullable_to_non_nullable
              as Gasfitero?,
      apoyos: null == apoyos
          ? _value.apoyos
          : apoyos // ignore: cast_nullable_to_non_nullable
              as List<Gasfitero>,
      chofer: freezed == chofer
          ? _value.chofer
          : chofer // ignore: cast_nullable_to_non_nullable
              as Gasfitero?,
      operador: freezed == operador
          ? _value.operador
          : operador // ignore: cast_nullable_to_non_nullable
              as Gasfitero?,
    ) as $Val);
  }

  /// Create a copy of Cuadrilla
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GasfiteroCopyWith<$Res>? get lider {
    if (_value.lider == null) {
      return null;
    }

    return $GasfiteroCopyWith<$Res>(_value.lider!, (value) {
      return _then(_value.copyWith(lider: value) as $Val);
    });
  }

  /// Create a copy of Cuadrilla
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GasfiteroCopyWith<$Res>? get chofer {
    if (_value.chofer == null) {
      return null;
    }

    return $GasfiteroCopyWith<$Res>(_value.chofer!, (value) {
      return _then(_value.copyWith(chofer: value) as $Val);
    });
  }

  /// Create a copy of Cuadrilla
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GasfiteroCopyWith<$Res>? get operador {
    if (_value.operador == null) {
      return null;
    }

    return $GasfiteroCopyWith<$Res>(_value.operador!, (value) {
      return _then(_value.copyWith(operador: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CuadrillaImplCopyWith<$Res>
    implements $CuadrillaCopyWith<$Res> {
  factory _$$CuadrillaImplCopyWith(
          _$CuadrillaImpl value, $Res Function(_$CuadrillaImpl) then) =
      __$$CuadrillaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String? codigoGrupo,
      String? especialidad,
      Gasfitero? lider,
      List<Gasfitero> apoyos,
      Gasfitero? chofer,
      Gasfitero? operador});

  @override
  $GasfiteroCopyWith<$Res>? get lider;
  @override
  $GasfiteroCopyWith<$Res>? get chofer;
  @override
  $GasfiteroCopyWith<$Res>? get operador;
}

/// @nodoc
class __$$CuadrillaImplCopyWithImpl<$Res>
    extends _$CuadrillaCopyWithImpl<$Res, _$CuadrillaImpl>
    implements _$$CuadrillaImplCopyWith<$Res> {
  __$$CuadrillaImplCopyWithImpl(
      _$CuadrillaImpl _value, $Res Function(_$CuadrillaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Cuadrilla
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigoGrupo = freezed,
    Object? especialidad = freezed,
    Object? lider = freezed,
    Object? apoyos = null,
    Object? chofer = freezed,
    Object? operador = freezed,
  }) {
    return _then(_$CuadrillaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      codigoGrupo: freezed == codigoGrupo
          ? _value.codigoGrupo
          : codigoGrupo // ignore: cast_nullable_to_non_nullable
              as String?,
      especialidad: freezed == especialidad
          ? _value.especialidad
          : especialidad // ignore: cast_nullable_to_non_nullable
              as String?,
      lider: freezed == lider
          ? _value.lider
          : lider // ignore: cast_nullable_to_non_nullable
              as Gasfitero?,
      apoyos: null == apoyos
          ? _value._apoyos
          : apoyos // ignore: cast_nullable_to_non_nullable
              as List<Gasfitero>,
      chofer: freezed == chofer
          ? _value.chofer
          : chofer // ignore: cast_nullable_to_non_nullable
              as Gasfitero?,
      operador: freezed == operador
          ? _value.operador
          : operador // ignore: cast_nullable_to_non_nullable
              as Gasfitero?,
    ));
  }
}

/// @nodoc

class _$CuadrillaImpl implements _Cuadrilla {
  const _$CuadrillaImpl(
      {required this.id,
      this.codigoGrupo,
      this.especialidad,
      this.lider,
      final List<Gasfitero> apoyos = const [],
      this.chofer,
      this.operador})
      : _apoyos = apoyos;

  @override
  final int id;
  @override
  final String? codigoGrupo;
  @override
  final String? especialidad;
  @override
  final Gasfitero? lider;
  final List<Gasfitero> _apoyos;
  @override
  @JsonKey()
  List<Gasfitero> get apoyos {
    if (_apoyos is EqualUnmodifiableListView) return _apoyos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_apoyos);
  }

  @override
  final Gasfitero? chofer;
  @override
  final Gasfitero? operador;

  @override
  String toString() {
    return 'Cuadrilla(id: $id, codigoGrupo: $codigoGrupo, especialidad: $especialidad, lider: $lider, apoyos: $apoyos, chofer: $chofer, operador: $operador)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CuadrillaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.codigoGrupo, codigoGrupo) ||
                other.codigoGrupo == codigoGrupo) &&
            (identical(other.especialidad, especialidad) ||
                other.especialidad == especialidad) &&
            (identical(other.lider, lider) || other.lider == lider) &&
            const DeepCollectionEquality().equals(other._apoyos, _apoyos) &&
            (identical(other.chofer, chofer) || other.chofer == chofer) &&
            (identical(other.operador, operador) ||
                other.operador == operador));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, codigoGrupo, especialidad,
      lider, const DeepCollectionEquality().hash(_apoyos), chofer, operador);

  /// Create a copy of Cuadrilla
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CuadrillaImplCopyWith<_$CuadrillaImpl> get copyWith =>
      __$$CuadrillaImplCopyWithImpl<_$CuadrillaImpl>(this, _$identity);
}

abstract class _Cuadrilla implements Cuadrilla {
  const factory _Cuadrilla(
      {required final int id,
      final String? codigoGrupo,
      final String? especialidad,
      final Gasfitero? lider,
      final List<Gasfitero> apoyos,
      final Gasfitero? chofer,
      final Gasfitero? operador}) = _$CuadrillaImpl;

  @override
  int get id;
  @override
  String? get codigoGrupo;
  @override
  String? get especialidad;
  @override
  Gasfitero? get lider;
  @override
  List<Gasfitero> get apoyos;
  @override
  Gasfitero? get chofer;
  @override
  Gasfitero? get operador;

  /// Create a copy of Cuadrilla
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CuadrillaImplCopyWith<_$CuadrillaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
