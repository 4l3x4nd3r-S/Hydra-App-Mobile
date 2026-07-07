// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registro_presion_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistroPresionDto _$RegistroPresionDtoFromJson(Map<String, dynamic> json) {
  return _RegistroPresionDto.fromJson(json);
}

/// @nodoc
mixin _$RegistroPresionDto {
  @JsonKey(name: 'fecha_hora')
  String? get fechaHora => throw _privateConstructorUsedError;
  @JsonKey(name: 'presion_mca')
  double? get presionMca => throw _privateConstructorUsedError;
  @JsonKey(name: 'temperatura_c')
  double? get temperaturaC => throw _privateConstructorUsedError;
  @JsonKey(name: 'dispositivo_serie')
  String? get dispositivoSerie => throw _privateConstructorUsedError;

  /// Serializes this RegistroPresionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegistroPresionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegistroPresionDtoCopyWith<RegistroPresionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistroPresionDtoCopyWith<$Res> {
  factory $RegistroPresionDtoCopyWith(
          RegistroPresionDto value, $Res Function(RegistroPresionDto) then) =
      _$RegistroPresionDtoCopyWithImpl<$Res, RegistroPresionDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'fecha_hora') String? fechaHora,
      @JsonKey(name: 'presion_mca') double? presionMca,
      @JsonKey(name: 'temperatura_c') double? temperaturaC,
      @JsonKey(name: 'dispositivo_serie') String? dispositivoSerie});
}

/// @nodoc
class _$RegistroPresionDtoCopyWithImpl<$Res, $Val extends RegistroPresionDto>
    implements $RegistroPresionDtoCopyWith<$Res> {
  _$RegistroPresionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistroPresionDto
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
abstract class _$$RegistroPresionDtoImplCopyWith<$Res>
    implements $RegistroPresionDtoCopyWith<$Res> {
  factory _$$RegistroPresionDtoImplCopyWith(_$RegistroPresionDtoImpl value,
          $Res Function(_$RegistroPresionDtoImpl) then) =
      __$$RegistroPresionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'fecha_hora') String? fechaHora,
      @JsonKey(name: 'presion_mca') double? presionMca,
      @JsonKey(name: 'temperatura_c') double? temperaturaC,
      @JsonKey(name: 'dispositivo_serie') String? dispositivoSerie});
}

/// @nodoc
class __$$RegistroPresionDtoImplCopyWithImpl<$Res>
    extends _$RegistroPresionDtoCopyWithImpl<$Res, _$RegistroPresionDtoImpl>
    implements _$$RegistroPresionDtoImplCopyWith<$Res> {
  __$$RegistroPresionDtoImplCopyWithImpl(_$RegistroPresionDtoImpl _value,
      $Res Function(_$RegistroPresionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistroPresionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fechaHora = freezed,
    Object? presionMca = freezed,
    Object? temperaturaC = freezed,
    Object? dispositivoSerie = freezed,
  }) {
    return _then(_$RegistroPresionDtoImpl(
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
@JsonSerializable()
class _$RegistroPresionDtoImpl implements _RegistroPresionDto {
  const _$RegistroPresionDtoImpl(
      {@JsonKey(name: 'fecha_hora') this.fechaHora,
      @JsonKey(name: 'presion_mca') this.presionMca,
      @JsonKey(name: 'temperatura_c') this.temperaturaC,
      @JsonKey(name: 'dispositivo_serie') this.dispositivoSerie});

  factory _$RegistroPresionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistroPresionDtoImplFromJson(json);

  @override
  @JsonKey(name: 'fecha_hora')
  final String? fechaHora;
  @override
  @JsonKey(name: 'presion_mca')
  final double? presionMca;
  @override
  @JsonKey(name: 'temperatura_c')
  final double? temperaturaC;
  @override
  @JsonKey(name: 'dispositivo_serie')
  final String? dispositivoSerie;

  @override
  String toString() {
    return 'RegistroPresionDto(fechaHora: $fechaHora, presionMca: $presionMca, temperaturaC: $temperaturaC, dispositivoSerie: $dispositivoSerie)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistroPresionDtoImpl &&
            (identical(other.fechaHora, fechaHora) ||
                other.fechaHora == fechaHora) &&
            (identical(other.presionMca, presionMca) ||
                other.presionMca == presionMca) &&
            (identical(other.temperaturaC, temperaturaC) ||
                other.temperaturaC == temperaturaC) &&
            (identical(other.dispositivoSerie, dispositivoSerie) ||
                other.dispositivoSerie == dispositivoSerie));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, fechaHora, presionMca, temperaturaC, dispositivoSerie);

  /// Create a copy of RegistroPresionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistroPresionDtoImplCopyWith<_$RegistroPresionDtoImpl> get copyWith =>
      __$$RegistroPresionDtoImplCopyWithImpl<_$RegistroPresionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistroPresionDtoImplToJson(
      this,
    );
  }
}

abstract class _RegistroPresionDto implements RegistroPresionDto {
  const factory _RegistroPresionDto(
          {@JsonKey(name: 'fecha_hora') final String? fechaHora,
          @JsonKey(name: 'presion_mca') final double? presionMca,
          @JsonKey(name: 'temperatura_c') final double? temperaturaC,
          @JsonKey(name: 'dispositivo_serie') final String? dispositivoSerie}) =
      _$RegistroPresionDtoImpl;

  factory _RegistroPresionDto.fromJson(Map<String, dynamic> json) =
      _$RegistroPresionDtoImpl.fromJson;

  @override
  @JsonKey(name: 'fecha_hora')
  String? get fechaHora;
  @override
  @JsonKey(name: 'presion_mca')
  double? get presionMca;
  @override
  @JsonKey(name: 'temperatura_c')
  double? get temperaturaC;
  @override
  @JsonKey(name: 'dispositivo_serie')
  String? get dispositivoSerie;

  /// Create a copy of RegistroPresionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistroPresionDtoImplCopyWith<_$RegistroPresionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
