import '../../data/repositories/os_repository.dart';

class SaveOsReportUseCase {
  final OsRepository _osRepository;

  SaveOsReportUseCase({required OsRepository osRepository})
      : _osRepository = osRepository;

  Future<void> call({
    required int osId,
    String? insumosUtilizados,
    String? observacionesGasfitero,
    String? rutaCarpetaEvidencias,
    String? trabajoEjecutado,
    String? problemas,
    String? soluciones,
    String? comentariosInstrucciones,
    double? latitud,
    double? longitud,
    String? fotosProblemaUrls,
    String? fotosSolucionUrls,
    String? fechaEjecucionInicio,
    String? fechaEjecucionFin,
  }) async {
    await _osRepository.saveReportOffline(
      osId: osId,
      insumosUtilizados: insumosUtilizados,
      observacionesGasfitero: observacionesGasfitero,
      rutaCarpetaEvidencias: rutaCarpetaEvidencias,
      trabajoEjecutado: trabajoEjecutado,
      problemas: problemas,
      soluciones: soluciones,
      comentariosInstrucciones: comentariosInstrucciones,
      latitud: latitud,
      longitud: longitud,
      fotosProblemaUrls: fotosProblemaUrls,
      fotosSolucionUrls: fotosSolucionUrls,
      fechaEjecucionInicio: fechaEjecucionInicio,
      fechaEjecucionFin: fechaEjecucionFin,
    );
    await _osRepository.triggerSync();
  }
}
