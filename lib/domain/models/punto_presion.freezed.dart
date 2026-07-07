// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'punto_presion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PuntoPresion {
  int get id => throw _privateConstructorUsedError;
  String? get codigoPunto => throw _privateConstructorUsedError;
  int? get sectorId => throw _privateConstructorUsedError;
  double? get latitud => throw _privateConstructorUsedError;
  double? get longitud => throw _privateConstructorUsedError;

  /// Create a copy of PuntoPresion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PuntoPresionCopyWith<PuntoPresion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PuntoPresionCopyWith<$Res> {
  factory $PuntoPresionCopyWith(
          PuntoPresion value, $Res Function(PuntoPresion) then) =
      _$PuntoPresionCopyWithImpl<$Res, PuntoPresion>;
  @useResult
  $Res call(
      {int id,
      String? codigoPunto,
      int? sectorId,
      double? latitud,
      double? longitud});
}

/// @nodoc
class _$PuntoPresionCopyWithImpl<$Res, $Val extends PuntoPresion>
    implements $PuntoPresionCopyWith<$Res> {
  _$PuntoPresionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PuntoPresion
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
abstract class _$$PuntoPresionImplCopyWith<$Res>
    implements $PuntoPresionCopyWith<$Res> {
  factory _$$PuntoPresionImplCopyWith(
          _$PuntoPresionImpl value, $Res Function(_$PuntoPresionImpl) then) =
      __$$PuntoPresionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String? codigoPunto,
      int? sectorId,
      double? latitud,
      double? longitud});
}

/// @nodoc
class __$$PuntoPresionImplCopyWithImpl<$Res>
    extends _$PuntoPresionCopyWithImpl<$Res, _$PuntoPresionImpl>
    implements _$$PuntoPresionImplCopyWith<$Res> {
  __$$PuntoPresionImplCopyWithImpl(
      _$PuntoPresionImpl _value, $Res Function(_$PuntoPresionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PuntoPresion
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
    return _then(_$PuntoPresionImpl(
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

class _$PuntoPresionImpl implements _PuntoPresion {
  const _$PuntoPresionImpl(
      {required this.id,
      this.codigoPunto,
      this.sectorId,
      this.latitud,
      this.longitud});

  @override
  final int id;
  @override
  final String? codigoPunto;
  @override
  final int? sectorId;
  @override
  final double? latitud;
  @override
  final double? longitud;

  @override
  String toString() {
    return 'PuntoPresion(id: $id, codigoPunto: $codigoPunto, sectorId: $sectorId, latitud: $latitud, longitud: $longitud)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PuntoPresionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.codigoPunto, codigoPunto) ||
                other.codigoPunto == codigoPunto) &&
            (identical(other.sectorId, sectorId) ||
                other.sectorId == sectorId) &&
            (identical(other.latitud, latitud) || other.latitud == latitud) &&
            (identical(other.longitud, longitud) ||
                other.longitud == longitud));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, codigoPunto, sectorId, latitud, longitud);

  /// Create a copy of PuntoPresion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PuntoPresionImplCopyWith<_$PuntoPresionImpl> get copyWith =>
      __$$PuntoPresionImplCopyWithImpl<_$PuntoPresionImpl>(this, _$identity);
}

abstract class _PuntoPresion implements PuntoPresion {
  const factory _PuntoPresion(
      {required final int id,
      final String? codigoPunto,
      final int? sectorId,
      final double? latitud,
      final double? longitud}) = _$PuntoPresionImpl;

  @override
  int get id;
  @override
  String? get codigoPunto;
  @override
  int? get sectorId;
  @override
  double? get latitud;
  @override
  double? get longitud;

  /// Create a copy of PuntoPresion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PuntoPresionImplCopyWith<_$PuntoPresionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
