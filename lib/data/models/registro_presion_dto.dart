import 'package:freezed_annotation/freezed_annotation.dart';

part 'registro_presion_dto.freezed.dart';
part 'registro_presion_dto.g.dart';

@freezed
class RegistroPresionDto with _$RegistroPresionDto {
  const factory RegistroPresionDto({
    @JsonKey(name: 'fecha_hora') String? fechaHora,
    @JsonKey(name: 'presion_mca') double? presionMca,
    @JsonKey(name: 'temperatura_c') double? temperaturaC,
    @JsonKey(name: 'dispositivo_serie') String? dispositivoSerie,
  }) = _RegistroPresionDto;

  factory RegistroPresionDto.fromJson(Map<String, dynamic> json) =>
      _$RegistroPresionDtoFromJson(json);
}
