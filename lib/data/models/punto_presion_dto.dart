import 'package:freezed_annotation/freezed_annotation.dart';

part 'punto_presion_dto.freezed.dart';
part 'punto_presion_dto.g.dart';

@freezed
class PuntoPresionDto with _$PuntoPresionDto {
  const factory PuntoPresionDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'codigo_punto') String? codigoPunto,
    @JsonKey(name: 'sector_id') int? sectorId,
    @JsonKey(name: 'latitud') double? latitud,
    @JsonKey(name: 'longitud') double? longitud,
  }) = _PuntoPresionDto;

  factory PuntoPresionDto.fromJson(Map<String, dynamic> json) =>
      _$PuntoPresionDtoFromJson(json);
}
