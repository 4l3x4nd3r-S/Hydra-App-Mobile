import 'package:freezed_annotation/freezed_annotation.dart';
import 'gasfitero_dto.dart';

part 'cuadrilla_dto.freezed.dart';
part 'cuadrilla_dto.g.dart';

@freezed
class CuadrillaDto with _$CuadrillaDto {
  const factory CuadrillaDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'codigo_grupo') String? codigoGrupo,
    @JsonKey(name: 'especialidad') String? especialidad,
    @JsonKey(name: 'lider') GasfiteroDto? lider,
    @JsonKey(name: 'apoyos') @Default([]) List<GasfiteroDto> apoyos,
    @JsonKey(name: 'chofer') GasfiteroDto? chofer,
    @JsonKey(name: 'operador') GasfiteroDto? operador,
  }) = _CuadrillaDto;

  factory CuadrillaDto.fromJson(Map<String, dynamic> json) =>
      _$CuadrillaDtoFromJson(json);
}
