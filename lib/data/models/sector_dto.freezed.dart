// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sector_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SectorDto _$SectorDtoFromJson(Map<String, dynamic> json) {
  return _SectorDto.fromJson(json);
}

/// @nodoc
mixin _$SectorDto {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'nombre')
  String? get nombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'reservorio_asociado')
  String? get reservorioAsociado => throw _privateConstructorUsedError;

  /// Serializes this SectorDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SectorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SectorDtoCopyWith<SectorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SectorDtoCopyWith<$Res> {
  factory $SectorDtoCopyWith(SectorDto value, $Res Function(SectorDto) then) =
      _$SectorDtoCopyWithImpl<$Res, SectorDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'nombre') String? nombre,
      @JsonKey(name: 'reservorio_asociado') String? reservorioAsociado});
}

/// @nodoc
class _$SectorDtoCopyWithImpl<$Res, $Val extends SectorDto>
    implements $SectorDtoCopyWith<$Res> {
  _$SectorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SectorDto
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
abstract class _$$SectorDtoImplCopyWith<$Res>
    implements $SectorDtoCopyWith<$Res> {
  factory _$$SectorDtoImplCopyWith(
          _$SectorDtoImpl value, $Res Function(_$SectorDtoImpl) then) =
      __$$SectorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'nombre') String? nombre,
      @JsonKey(name: 'reservorio_asociado') String? reservorioAsociado});
}

/// @nodoc
class __$$SectorDtoImplCopyWithImpl<$Res>
    extends _$SectorDtoCopyWithImpl<$Res, _$SectorDtoImpl>
    implements _$$SectorDtoImplCopyWith<$Res> {
  __$$SectorDtoImplCopyWithImpl(
      _$SectorDtoImpl _value, $Res Function(_$SectorDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SectorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = freezed,
    Object? reservorioAsociado = freezed,
  }) {
    return _then(_$SectorDtoImpl(
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
@JsonSerializable()
class _$SectorDtoImpl implements _SectorDto {
  const _$SectorDtoImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'nombre') this.nombre,
      @JsonKey(name: 'reservorio_asociado') this.reservorioAsociado});

  factory _$SectorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SectorDtoImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'nombre')
  final String? nombre;
  @override
  @JsonKey(name: 'reservorio_asociado')
  final String? reservorioAsociado;

  @override
  String toString() {
    return 'SectorDto(id: $id, nombre: $nombre, reservorioAsociado: $reservorioAsociado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SectorDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.reservorioAsociado, reservorioAsociado) ||
                other.reservorioAsociado == reservorioAsociado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, reservorioAsociado);

  /// Create a copy of SectorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SectorDtoImplCopyWith<_$SectorDtoImpl> get copyWith =>
      __$$SectorDtoImplCopyWithImpl<_$SectorDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SectorDtoImplToJson(
      this,
    );
  }
}

abstract class _SectorDto implements SectorDto {
  const factory _SectorDto(
      {@JsonKey(name: 'id') required final int id,
      @JsonKey(name: 'nombre') final String? nombre,
      @JsonKey(name: 'reservorio_asociado')
      final String? reservorioAsociado}) = _$SectorDtoImpl;

  factory _SectorDto.fromJson(Map<String, dynamic> json) =
      _$SectorDtoImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'nombre')
  String? get nombre;
  @override
  @JsonKey(name: 'reservorio_asociado')
  String? get reservorioAsociado;

  /// Create a copy of SectorDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SectorDtoImplCopyWith<_$SectorDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
