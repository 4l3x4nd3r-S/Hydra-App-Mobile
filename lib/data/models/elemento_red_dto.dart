import 'package:freezed_annotation/freezed_annotation.dart';

part 'elemento_red_dto.freezed.dart';
part 'elemento_red_dto.g.dart';

@freezed
class ElementoRedDto with _$ElementoRedDto {
  const factory ElementoRedDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'codigo_plano') String? codigoPlano,
    @JsonKey(name: 'tipo') String? tipo,
    @JsonKey(name: 'sector_id') int? sectorId,
    @JsonKey(name: 'latitud') double? latitud,
    @JsonKey(name: 'longitud') double? longitud,
    @JsonKey(name: 'estado_operativo') String? estadoOperativo,
    @JsonKey(name: 'fecha_modificacion') String? fechaModificacion,
    @JsonKey(name: 'estado_valvula') String? estadoValvula,
  }) = _ElementoRedDto;

  factory ElementoRedDto.fromJson(Map<String, dynamic> json) =>
      _$ElementoRedDtoFromJson(json);
}
