import 'package:freezed_annotation/freezed_annotation.dart';
import 'reclamo_dto.dart';
import 'cuadrilla_dto.dart';

part 'os_dto.freezed.dart';
part 'os_dto.g.dart';

@freezed
class OsDto with _$OsDto {
  const factory OsDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'numero_orden') String? numeroOrden,
    @JsonKey(name: 'reclamo_id') int? reclamoId,
    @JsonKey(name: 'supervisor_id') int? supervisorId,
    @JsonKey(name: 'cuadrilla_id') int? cuadrillaId,
    @JsonKey(name: 'sector_id') int? sectorId,
    @JsonKey(name: 'fecha_programacion') String? fechaProgramacion,
    @JsonKey(name: 'fecha_ejecucion_inicio') String? fechaEjecucionInicio,
    @JsonKey(name: 'fecha_ejecucion_fin') String? fechaEjecucionFin,
    @JsonKey(name: 'estado_orden') String? estadoOrden,
    @JsonKey(name: 'insumos_utilizados') String? insumosUtilizados,
    @JsonKey(name: 'observaciones_gasfitero') String? observacionesGasfitero,
    @JsonKey(name: 'ruta_carpeta_evidencias') String? rutaCarpetaEvidencias,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'trabajo_ejecutado') String? trabajoEjecutado,
    @JsonKey(name: 'problemas') String? problemas,
    @JsonKey(name: 'soluciones') String? soluciones,
    @JsonKey(name: 'comentarios_instrucciones') String? comentariosInstrucciones,
    @JsonKey(name: 'latitud') double? latitud,
    @JsonKey(name: 'longitud') double? longitud,
    @JsonKey(name: 'fotos_problema_urls') @Default([]) List<String> fotosProblemaUrls,
    @JsonKey(name: 'fotos_solucion_urls') @Default([]) List<String> fotosSolucionUrls,
    @JsonKey(name: 'reclamo') ReclamoDto? reclamo,
    @JsonKey(name: 'cuadrilla') CuadrillaDto? cuadrilla,
  }) = _OsDto;

  factory OsDto.fromJson(Map<String, dynamic> json) => _$OsDtoFromJson(json);
}
