import 'package:freezed_annotation/freezed_annotation.dart';

part 'gasfitero_dto.freezed.dart';
part 'gasfitero_dto.g.dart';

@freezed
class GasfiteroDto with _$GasfiteroDto {
  const factory GasfiteroDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'nombre') String? nombre,
    @JsonKey(name: 'codigo_empleado') String? codigoEmpleado,
    @JsonKey(name: 'cargo') String? cargo,
    @JsonKey(name: 'area') String? area,
    @JsonKey(name: 'rol_en_cuadrilla') String? rolEnCuadrilla,
  }) = _GasfiteroDto;

  factory GasfiteroDto.fromJson(Map<String, dynamic> json) =>
      _$GasfiteroDtoFromJson(json);
}
