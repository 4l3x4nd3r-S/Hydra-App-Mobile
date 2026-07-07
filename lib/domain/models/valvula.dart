import 'package:freezed_annotation/freezed_annotation.dart';

part 'valvula.freezed.dart';

@freezed
class Valvula with _$Valvula {
  const factory Valvula({
    required int id,
    String? codigoPlano,
    String? tipo,
    int? sectorId,
    double? latitud,
    double? longitud,
    String? estadoOperativo,
    String? estadoValvula,
    String? fechaModificacion,
  }) = _Valvula;
}
