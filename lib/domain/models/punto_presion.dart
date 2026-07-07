import 'package:freezed_annotation/freezed_annotation.dart';

part 'punto_presion.freezed.dart';

@freezed
class PuntoPresion with _$PuntoPresion {
  const factory PuntoPresion({
    required int id,
    String? codigoPunto,
    int? sectorId,
    double? latitud,
    double? longitud,
  }) = _PuntoPresion;
}
