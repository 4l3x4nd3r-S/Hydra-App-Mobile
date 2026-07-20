// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cuadrilla_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CuadrillaDto _$CuadrillaDtoFromJson(Map<String, dynamic> json) {
  return _CuadrillaDto.fromJson(json);
}

/// @nodoc
mixin _$CuadrillaDto {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'codigo_grupo')
  String? get codigoGrupo => throw _privateConstructorUsedError;
  @JsonKey(name: 'especialidad')
  String? get especialidad => throw _privateConstructorUsedError;
  @JsonKey(name: 'lider')
  GasfiteroDto? get lider => throw _privateConstructorUsedError;
  @JsonKey(name: 'apoyos')
  List<GasfiteroDto> get apoyos => throw _privateConstructorUsedError;
  @JsonKey(name: 'chofer')
  GasfiteroDto? get chofer => throw _privateConstructorUsedError;

  /// Serializes this CuadrillaDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CuadrillaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CuadrillaDtoCopyWith<CuadrillaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CuadrillaDtoCopyWith<$Res> {
  factory $CuadrillaDtoCopyWith(
          CuadrillaDto value, $Res Function(CuadrillaDto) then) =
      _$CuadrillaDtoCopyWithImpl<$Res, CuadrillaDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'codigo_grupo') String? codigoGrupo,
      @JsonKey(name: 'especialidad') String? especialidad,
      @JsonKey(name: 'lider') GasfiteroDto? lider,
      @JsonKey(name: 'apoyos') List<GasfiteroDto> apoyos,
      @JsonKey(name: 'chofer') GasfiteroDto? chofer});

  $GasfiteroDtoCopyWith<$Res>? get lider;
  $GasfiteroDtoCopyWith<$Res>? get chofer;
}

/// @nodoc
class _$CuadrillaDtoCopyWithImpl<$Res, $Val extends CuadrillaDto>
    implements $CuadrillaDtoCopyWith<$Res> {
  _$CuadrillaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CuadrillaDto
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
              as GasfiteroDto?,
      apoyos: null == apoyos
          ? _value.apoyos
          : apoyos // ignore: cast_nullable_to_non_nullable
              as List<GasfiteroDto>,
      chofer: freezed == chofer
          ? _value.chofer
          : chofer // ignore: cast_nullable_to_non_nullable
              as GasfiteroDto?,
    ) as $Val);
  }

  /// Create a copy of CuadrillaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GasfiteroDtoCopyWith<$Res>? get lider {
    if (_value.lider == null) {
      return null;
    }

    return $GasfiteroDtoCopyWith<$Res>(_value.lider!, (value) {
      return _then(_value.copyWith(lider: value) as $Val);
    });
  }

  /// Create a copy of CuadrillaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GasfiteroDtoCopyWith<$Res>? get chofer {
    if (_value.chofer == null) {
      return null;
    }

    return $GasfiteroDtoCopyWith<$Res>(_value.chofer!, (value) {
      return _then(_value.copyWith(chofer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CuadrillaDtoImplCopyWith<$Res>
    implements $CuadrillaDtoCopyWith<$Res> {
  factory _$$CuadrillaDtoImplCopyWith(
          _$CuadrillaDtoImpl value, $Res Function(_$CuadrillaDtoImpl) then) =
      __$$CuadrillaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'codigo_grupo') String? codigoGrupo,
      @JsonKey(name: 'especialidad') String? especialidad,
      @JsonKey(name: 'lider') GasfiteroDto? lider,
      @JsonKey(name: 'apoyos') List<GasfiteroDto> apoyos,
      @JsonKey(name: 'chofer') GasfiteroDto? chofer});

  @override
  $GasfiteroDtoCopyWith<$Res>? get lider;
  @override
  $GasfiteroDtoCopyWith<$Res>? get chofer;
}

/// @nodoc
class __$$CuadrillaDtoImplCopyWithImpl<$Res>
    extends _$CuadrillaDtoCopyWithImpl<$Res, _$CuadrillaDtoImpl>
    implements _$$CuadrillaDtoImplCopyWith<$Res> {
  __$$CuadrillaDtoImplCopyWithImpl(
      _$CuadrillaDtoImpl _value, $Res Function(_$CuadrillaDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CuadrillaDto
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
  }) {
    return _then(_$CuadrillaDtoImpl(
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
              as GasfiteroDto?,
      apoyos: null == apoyos
          ? _value._apoyos
          : apoyos // ignore: cast_nullable_to_non_nullable
              as List<GasfiteroDto>,
      chofer: freezed == chofer
          ? _value.chofer
          : chofer // ignore: cast_nullable_to_non_nullable
              as GasfiteroDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CuadrillaDtoImpl implements _CuadrillaDto {
  const _$CuadrillaDtoImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'codigo_grupo') this.codigoGrupo,
      @JsonKey(name: 'especialidad') this.especialidad,
      @JsonKey(name: 'lider') this.lider,
      @JsonKey(name: 'apoyos') final List<GasfiteroDto> apoyos = const [],
      @JsonKey(name: 'chofer') this.chofer})
      : _apoyos = apoyos;

  factory _$CuadrillaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CuadrillaDtoImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'codigo_grupo')
  final String? codigoGrupo;
  @override
  @JsonKey(name: 'especialidad')
  final String? especialidad;
  @override
  @JsonKey(name: 'lider')
  final GasfiteroDto? lider;
  final List<GasfiteroDto> _apoyos;
  @override
  @JsonKey(name: 'apoyos')
  List<GasfiteroDto> get apoyos {
    if (_apoyos is EqualUnmodifiableListView) return _apoyos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_apoyos);
  }

  @override
  @JsonKey(name: 'chofer')
  final GasfiteroDto? chofer;

  @override
  String toString() {
    return 'CuadrillaDto(id: $id, codigoGrupo: $codigoGrupo, especialidad: $especialidad, lider: $lider, apoyos: $apoyos, chofer: $chofer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CuadrillaDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.codigoGrupo, codigoGrupo) ||
                other.codigoGrupo == codigoGrupo) &&
            (identical(other.especialidad, especialidad) ||
                other.especialidad == especialidad) &&
            (identical(other.lider, lider) || other.lider == lider) &&
            const DeepCollectionEquality().equals(other._apoyos, _apoyos) &&
            (identical(other.chofer, chofer) || other.chofer == chofer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, codigoGrupo, especialidad,
      lider, const DeepCollectionEquality().hash(_apoyos), chofer);

  /// Create a copy of CuadrillaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CuadrillaDtoImplCopyWith<_$CuadrillaDtoImpl> get copyWith =>
      __$$CuadrillaDtoImplCopyWithImpl<_$CuadrillaDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CuadrillaDtoImplToJson(
      this,
    );
  }
}

abstract class _CuadrillaDto implements CuadrillaDto {
  const factory _CuadrillaDto(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'codigo_grupo') final String? codigoGrupo,
          @JsonKey(name: 'especialidad') final String? especialidad,
          @JsonKey(name: 'lider') final GasfiteroDto? lider,
          @JsonKey(name: 'apoyos') final List<GasfiteroDto> apoyos,
          @JsonKey(name: 'chofer') final GasfiteroDto? chofer}) =
      _$CuadrillaDtoImpl;

  factory _CuadrillaDto.fromJson(Map<String, dynamic> json) =
      _$CuadrillaDtoImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'codigo_grupo')
  String? get codigoGrupo;
  @override
  @JsonKey(name: 'especialidad')
  String? get especialidad;
  @override
  @JsonKey(name: 'lider')
  GasfiteroDto? get lider;
  @override
  @JsonKey(name: 'apoyos')
  List<GasfiteroDto> get apoyos;
  @override
  @JsonKey(name: 'chofer')
  GasfiteroDto? get chofer;

  /// Create a copy of CuadrillaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CuadrillaDtoImplCopyWith<_$CuadrillaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
