import 'package:freezed_annotation/freezed_annotation.dart';

part 'reclamo_dto.freezed.dart';
part 'reclamo_dto.g.dart';

@freezed
class ReclamoDto with _$ReclamoDto {
  const factory ReclamoDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'formato') String? formato,
    @JsonKey(name: 'codigo_solicitud') String? codigoSolicitud,
    @JsonKey(name: 'fecha_registro') String? fechaRegistro,
    @JsonKey(name: 'canal_entrada') String? canalEntrada,
    @JsonKey(name: 'tipo_problema') String? tipoProblema,
    @JsonKey(name: 'estado') String? estado,
    @JsonKey(name: 'descripcion') String? descripcion,
    @JsonKey(name: 'nombre_solicitante') String? nombreSolicitante,
    @JsonKey(name: 'direccion') String? direccion,
    @JsonKey(name: 'numero_medidor') String? numeroMedidor,
    @JsonKey(name: 'telefono') String? telefono,
    @JsonKey(name: 'email') String? email,
  }) = _ReclamoDto;

  factory ReclamoDto.fromJson(Map<String, dynamic> json) =>
      _$ReclamoDtoFromJson(json);
}
