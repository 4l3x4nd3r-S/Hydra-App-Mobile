import 'package:freezed_annotation/freezed_annotation.dart';

part 'gasfitero_dto.freezed.dart';
part 'gasfitero_dto.g.dart';

@freezed
class GasfiteroDto with _$GasfiteroDto {
  const factory GasfiteroDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'nombre') String? nombre,
    @JsonKey(name: 'codigo_empleado') String? codigoEmpleado,
    @JsonKey(name: 'dni') String? dni,
    @JsonKey(name: 'celular') String? celular,
    @JsonKey(name: 'cargo') String? cargo,
    @JsonKey(name: 'cargo_visible') String? cargoVisible,
    @JsonKey(name: 'area') String? area,
    @JsonKey(name: 'area_visible') String? areaVisible,
    @JsonKey(name: 'rol_en_cuadrilla') String? rolEnCuadrilla,
    @JsonKey(name: 'funcion_visible') String? funcionVisible,
    @JsonKey(name: 'es_principal') @Default(false) bool esPrincipal,
    @JsonKey(name: 'puede_ser_gasfitero')
    @Default(false)
    bool puedeSerGasfitero,
    @JsonKey(name: 'puede_ser_chofer') @Default(false) bool puedeSerChofer,
    @JsonKey(name: 'cuadrilla_id') int? cuadrillaId,
    @JsonKey(name: 'codigo_cuadrilla') String? codigoCuadrilla,
  }) = _GasfiteroDto;

  factory GasfiteroDto.fromJson(Map<String, dynamic> json) =>
      _$GasfiteroDtoFromJson(json);
}
