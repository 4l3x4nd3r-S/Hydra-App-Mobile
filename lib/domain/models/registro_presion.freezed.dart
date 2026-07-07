// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registro_presion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RegistroPresion {
  String? get fechaHora => throw _privateConstructorUsedError;
  double? get presionMca => throw _privateConstructorUsedError;
  double? get temperaturaC => throw _privateConstructorUsedError;
  String? get dispositivoSerie => throw _privateConstructorUsedError;

  /// Create a copy of RegistroPresion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegistroPresionCopyWith<RegistroPresion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistroPresionCopyWith<$Res> {
  factory $RegistroPresionCopyWith(
          RegistroPresion value, $Res Function(RegistroPresion) then) =
      _$RegistroPresionCopyWithImpl<$Res, RegistroPresion>;
  @useResult
  $Res call(
      {String? fechaHora,
      double? presionMca,
      double? temperaturaC,
      String? dispositivoSerie});
}

/// @nodoc
class _$RegistroPresionCopyWithImpl<$Res, $Val extends RegistroPresion>
    implements $RegistroPresionCopyWith<$Res> {
  _$RegistroPresionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistroPresion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fechaHora = freezed,
    Object? presionMca = freezed,
    Object? temperaturaC = freezed,
    Object? dispositivoSerie = freezed,
  }) {
    return _then(_value.copyWith(
      fechaHora: freezed == fechaHora
          ? _value.fechaHora
          : fechaHora // ignore: cast_nullable_to_non_nullable
              as String?,
      presionMca: freezed == presionMca
          ? _value.presionMca
          : presionMca // ignore: cast_nullable_to_non_nullable
              as double?,
      temperaturaC: freezed == temperaturaC
          ? _value.temperaturaC
          : temperaturaC // ignore: cast_nullable_to_non_nullable
              as double?,
      dispositivoSerie: freezed == dispositivoSerie
          ? _value.dispositivoSerie
          : dispositivoSerie // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistroPresionImplCopyWith<$Res>
    implements $RegistroPresionCopyWith<$Res> {
  factory _$$RegistroPresionImplCopyWith(_$RegistroPresionImpl value,
          $Res Function(_$RegistroPresionImpl) then) =
      __$$RegistroPresionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? fechaHora,
      double? presionMca,
      double? temperaturaC,
      String? dispositivoSerie});
}

/// @nodoc
class __$$RegistroPresionImplCopyWithImpl<$Res>
    extends _$RegistroPresionCopyWithImpl<$Res, _$RegistroPresionImpl>
    implements _$$RegistroPresionImplCopyWith<$Res> {
  __$$RegistroPresionImplCopyWithImpl(
      _$RegistroPresionImpl _value, $Res Function(_$RegistroPresionImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistroPresion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fechaHora = freezed,
    Object? presionMca = freezed,
    Object? temperaturaC = freezed,
    Object? dispositivoSerie = freezed,
  }) {
    return _then(_$RegistroPresionImpl(
      fechaHora: freezed == fechaHora
          ? _value.fechaHora
          : fechaHora // ignore: cast_nullable_to_non_nullable
              as String?,
      presionMca: freezed == presionMca
          ? _value.presionMca
          : presionMca // ignore: cast_nullable_to_non_nullable
              as double?,
      temperaturaC: freezed == temperaturaC
          ? _value.temperaturaC
          : temperaturaC // ignore: cast_nullable_to_non_nullable
              as double?,
      dispositivoSerie: freezed == dispositivoSerie
          ? _value.dispositivoSerie
          : dispositivoSerie // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RegistroPresionImpl implements _RegistroPresion {
  const _$RegistroPresionImpl(
      {this.fechaHora,
      this.presionMca,
      this.temperaturaC,
      this.dispositivoSerie});

  @override
  final String? fechaHora;
  @override
  final double? presionMca;
  @override
  final double? temperaturaC;
  @override
  final String? dispositivoSerie;

  @override
  String toString() {
    return 'RegistroPresion(fechaHora: $fechaHora, presionMca: $presionMca, temperaturaC: $temperaturaC, dispositivoSerie: $dispositivoSerie)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistroPresionImpl &&
            (identical(other.fechaHora, fechaHora) ||
                other.fechaHora == fechaHora) &&
            (identical(other.presionMca, presionMca) ||
                other.presionMca == presionMca) &&
            (identical(other.temperaturaC, temperaturaC) ||
                other.temperaturaC == temperaturaC) &&
            (identical(other.dispositivoSerie, dispositivoSerie) ||
                other.dispositivoSerie == dispositivoSerie));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, fechaHora, presionMca, temperaturaC, dispositivoSerie);

  /// Create a copy of RegistroPresion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistroPresionImplCopyWith<_$RegistroPresionImpl> get copyWith =>
      __$$RegistroPresionImplCopyWithImpl<_$RegistroPresionImpl>(
          this, _$identity);
}

abstract class _RegistroPresion implements RegistroPresion {
  const factory _RegistroPresion(
      {final String? fechaHora,
      final double? presionMca,
      final double? temperaturaC,
      final String? dispositivoSerie}) = _$RegistroPresionImpl;

  @override
  String? get fechaHora;
  @override
  double? get presionMca;
  @override
  double? get temperaturaC;
  @override
  String? get dispositivoSerie;

  /// Create a copy of RegistroPresion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistroPresionImplCopyWith<_$RegistroPresionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
