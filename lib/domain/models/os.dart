import 'package:freezed_annotation/freezed_annotation.dart';
import 'reclamo.dart';
import 'cuadrilla.dart';
import 'gasfitero.dart';

part 'os.freezed.dart';

@freezed
class Os with _$Os {
  const factory Os({
    required int id,
    String? numeroOrden,
    int? reclamoId,
    int? supervisorId,
    int? cuadrillaId,
    int? sectorId,
    String? fechaProgramacion,
    String? fechaEjecucionInicio,
    String? fechaEjecucionFin,
    String? estadoOrden,
    String? insumosUtilizados,
    String? observacionesGasfitero,
    String? rutaCarpetaEvidencias,
    String? createdAt,
    String? trabajoEjecutado,
    String? problemas,
    String? soluciones,
    String? comentariosInstrucciones,
    double? latitud,
    double? longitud,
    @Default([]) List<String> fotosProblemaUrls,
    @Default([]) List<String> fotosSolucionUrls,
    Reclamo? reclamo,
    Cuadrilla? cuadrilla,
    @Default([]) List<Gasfitero> responsables,
  }) = _Os;
}
