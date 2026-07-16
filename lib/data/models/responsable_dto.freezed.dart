// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'responsable_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResponsableDto _$ResponsableDtoFromJson(Map<String, dynamic> json) {
  return _ResponsableDto.fromJson(json);
}

/// @nodoc
mixin _$ResponsableDto {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'nombre')
  String? get nombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'codigo_empleado')
  String? get codigoEmpleado => throw _privateConstructorUsedError;
  @JsonKey(name: 'cargo')
  String? get cargo => throw _privateConstructorUsedError;

  /// Serializes this ResponsableDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResponsableDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResponsableDtoCopyWith<ResponsableDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponsableDtoCopyWith<$Res> {
  factory $ResponsableDtoCopyWith(
          ResponsableDto value, $Res Function(ResponsableDto) then) =
      _$ResponsableDtoCopyWithImpl<$Res, ResponsableDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'nombre') String? nombre,
      @JsonKey(name: 'codigo_empleado') String? codigoEmpleado,
      @JsonKey(name: 'cargo') String? cargo});
}

/// @nodoc
class _$ResponsableDtoCopyWithImpl<$Res, $Val extends ResponsableDto>
    implements $ResponsableDtoCopyWith<$Res> {
  _$ResponsableDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResponsableDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = freezed,
    Object? codigoEmpleado = freezed,
    Object? cargo = freezed,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResponsableDtoImplCopyWith<$Res>
    implements $ResponsableDtoCopyWith<$Res> {
  factory _$$ResponsableDtoImplCopyWith(_$ResponsableDtoImpl value,
          $Res Function(_$ResponsableDtoImpl) then) =
      __$$ResponsableDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'nombre') String? nombre,
      @JsonKey(name: 'codigo_empleado') String? codigoEmpleado,
      @JsonKey(name: 'cargo') String? cargo});
}

/// @nodoc
class __$$ResponsableDtoImplCopyWithImpl<$Res>
    extends _$ResponsableDtoCopyWithImpl<$Res, _$ResponsableDtoImpl>
    implements _$$ResponsableDtoImplCopyWith<$Res> {
  __$$ResponsableDtoImplCopyWithImpl(
      _$ResponsableDtoImpl _value, $Res Function(_$ResponsableDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResponsableDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = freezed,
    Object? codigoEmpleado = freezed,
    Object? cargo = freezed,
  }) {
    return _then(_$ResponsableDtoImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResponsableDtoImpl implements _ResponsableDto {
  const _$ResponsableDtoImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'nombre') this.nombre,
      @JsonKey(name: 'codigo_empleado') this.codigoEmpleado,
      @JsonKey(name: 'cargo') this.cargo});

  factory _$ResponsableDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResponsableDtoImplFromJson(json);

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
  String toString() {
    return 'ResponsableDto(id: $id, nombre: $nombre, codigoEmpleado: $codigoEmpleado, cargo: $cargo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponsableDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.codigoEmpleado, codigoEmpleado) ||
                other.codigoEmpleado == codigoEmpleado) &&
            (identical(other.cargo, cargo) || other.cargo == cargo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nombre, codigoEmpleado, cargo);

  /// Create a copy of ResponsableDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponsableDtoImplCopyWith<_$ResponsableDtoImpl> get copyWith =>
      __$$ResponsableDtoImplCopyWithImpl<_$ResponsableDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResponsableDtoImplToJson(
      this,
    );
  }
}

abstract class _ResponsableDto implements ResponsableDto {
  const factory _ResponsableDto(
      {@JsonKey(name: 'id') required final int id,
      @JsonKey(name: 'nombre') final String? nombre,
      @JsonKey(name: 'codigo_empleado') final String? codigoEmpleado,
      @JsonKey(name: 'cargo') final String? cargo}) = _$ResponsableDtoImpl;

  factory _ResponsableDto.fromJson(Map<String, dynamic> json) =
      _$ResponsableDtoImpl.fromJson;

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

  /// Create a copy of ResponsableDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResponsableDtoImplCopyWith<_$ResponsableDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
