import 'package:freezed_annotation/freezed_annotation.dart';

part 'datalogger.freezed.dart';

@freezed
class Datalogger with _$Datalogger {
  const factory Datalogger({
    required int id,
    String? codigoPlano,
    String? tipo,
    int? sectorId,
    double? latitud,
    double? longitud,
    String? estadoOperativo,
    String? fechaModificacion,
  }) = _Datalogger;
}
