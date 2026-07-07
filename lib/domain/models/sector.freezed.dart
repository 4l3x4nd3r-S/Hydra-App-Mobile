// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sector.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Sector {
  int get id => throw _privateConstructorUsedError;
  String? get nombre => throw _privateConstructorUsedError;
  String? get reservorioAsociado => throw _privateConstructorUsedError;

  /// Create a copy of Sector
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SectorCopyWith<Sector> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SectorCopyWith<$Res> {
  factory $SectorCopyWith(Sector value, $Res Function(Sector) then) =
      _$SectorCopyWithImpl<$Res, Sector>;
  @useResult
  $Res call({int id, String? nombre, String? reservorioAsociado});
}

/// @nodoc
class _$SectorCopyWithImpl<$Res, $Val extends Sector>
    implements $SectorCopyWith<$Res> {
  _$SectorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sector
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = freezed,
    Object? reservorioAsociado = freezed,
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
      reservorioAsociado: freezed == reservorioAsociado
          ? _value.reservorioAsociado
          : reservorioAsociado // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SectorImplCopyWith<$Res> implements $SectorCopyWith<$Res> {
  factory _$$SectorImplCopyWith(
          _$SectorImpl value, $Res Function(_$SectorImpl) then) =
      __$$SectorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String? nombre, String? reservorioAsociado});
}

/// @nodoc
class __$$SectorImplCopyWithImpl<$Res>
    extends _$SectorCopyWithImpl<$Res, _$SectorImpl>
    implements _$$SectorImplCopyWith<$Res> {
  __$$SectorImplCopyWithImpl(
      _$SectorImpl _value, $Res Function(_$SectorImpl) _then)
      : super(_value, _then);

  /// Create a copy of Sector
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = freezed,
    Object? reservorioAsociado = freezed,
  }) {
    return _then(_$SectorImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: freezed == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String?,
      reservorioAsociado: freezed == reservorioAsociado
          ? _value.reservorioAsociado
          : reservorioAsociado // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SectorImpl implements _Sector {
  const _$SectorImpl({required this.id, this.nombre, this.reservorioAsociado});

  @override
  final int id;
  @override
  final String? nombre;
  @override
  final String? reservorioAsociado;

  @override
  String toString() {
    return 'Sector(id: $id, nombre: $nombre, reservorioAsociado: $reservorioAsociado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SectorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.reservorioAsociado, reservorioAsociado) ||
                other.reservorioAsociado == reservorioAsociado));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, reservorioAsociado);

  /// Create a copy of Sector
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SectorImplCopyWith<_$SectorImpl> get copyWith =>
      __$$SectorImplCopyWithImpl<_$SectorImpl>(this, _$identity);
}

abstract class _Sector implements Sector {
  const factory _Sector(
      {required final int id,
      final String? nombre,
      final String? reservorioAsociado}) = _$SectorImpl;

  @override
  int get id;
  @override
  String? get nombre;
  @override
  String? get reservorioAsociado;

  /// Create a copy of Sector
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SectorImplCopyWith<_$SectorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
