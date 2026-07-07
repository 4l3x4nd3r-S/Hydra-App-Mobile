import 'package:freezed_annotation/freezed_annotation.dart';

part 'pending_sync_report.freezed.dart';

@freezed
class PendingSyncReport with _$PendingSyncReport {
  const factory PendingSyncReport({
    required int osId,
    required String? insumosUtilizados,
    required String? observacionesGasfitero,
    required String? rutaCarpetaEvidencias,
    required String? trabajoEjecutado,
    required String? problemas,
    required String? soluciones,
    required String? comentariosInstrucciones,
    required double? latitud,
    required double? longitud,
    required String? fotosProblemaUrls,
    required String? fotosSolucionUrls,
    required String? fechaEjecucionInicio,
    required String? fechaEjecucionFin,
    required String status,
    required String createdAt,
  }) = _PendingSyncReport;
}
