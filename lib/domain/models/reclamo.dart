import 'package:freezed_annotation/freezed_annotation.dart';

part 'reclamo.freezed.dart';

@freezed
class Reclamo with _$Reclamo {
  const factory Reclamo({
    required int id,
    String? formato,
    String? codigoSolicitud,
    String? canalEntrada,
    String? tipoProblema,
    String? estado,
    String? descripcion,
    String? nombreSolicitante,
    String? direccion,
    String? numeroSuministro,
    String? telefono,
    String? email,
    String? fechaRegistro,
  }) = _Reclamo;
}
