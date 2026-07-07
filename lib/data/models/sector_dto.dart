import 'package:freezed_annotation/freezed_annotation.dart';

part 'sector_dto.freezed.dart';
part 'sector_dto.g.dart';

@freezed
class SectorDto with _$SectorDto {
  const factory SectorDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'nombre') String? nombre,
    @JsonKey(name: 'reservorio_asociado') String? reservorioAsociado,
  }) = _SectorDto;

  factory SectorDto.fromJson(Map<String, dynamic> json) =>
      _$SectorDtoFromJson(json);
}
