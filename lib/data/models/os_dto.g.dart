// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'os_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OsDtoImpl _$$OsDtoImplFromJson(Map<String, dynamic> json) => _$OsDtoImpl(
      id: (json['id'] as num).toInt(),
      numeroOrden: json['numero_orden'] as String?,
      reclamoId: (json['reclamo_id'] as num?)?.toInt(),
      supervisorId: (json['supervisor_id'] as num?)?.toInt(),
      cuadrillaId: (json['cuadrilla_id'] as num?)?.toInt(),
      sectorId: (json['sector_id'] as num?)?.toInt(),
      fechaProgramacion: json['fecha_programacion'] as String?,
      fechaEjecucionInicio: json['fecha_ejecucion_inicio'] as String?,
      fechaEjecucionFin: json['fecha_ejecucion_fin'] as String?,
      estadoOrden: json['estado_orden'] as String?,
      insumosUtilizados: json['insumos_utilizados'] as String?,
      observacionesGasfitero: json['observaciones_gasfitero'] as String?,
      rutaCarpetaEvidencias: json['ruta_carpeta_evidencias'] as String?,
      createdAt: json['created_at'] as String?,
      trabajoEjecutado: json['trabajo_ejecutado'] as String?,
      problemas: json['problemas'] as String?,
      soluciones: json['soluciones'] as String?,
      comentariosInstrucciones: json['comentarios_instrucciones'] as String?,
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      fotosProblemaUrls: (json['fotos_problema_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      fotosSolucionUrls: (json['fotos_solucion_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      reclamo: json['reclamo'] == null
          ? null
          : ReclamoDto.fromJson(json['reclamo'] as Map<String, dynamic>),
      cuadrilla: json['cuadrilla'] == null
          ? null
          : CuadrillaDto.fromJson(json['cuadrilla'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OsDtoImplToJson(_$OsDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numero_orden': instance.numeroOrden,
      'reclamo_id': instance.reclamoId,
      'supervisor_id': instance.supervisorId,
      'cuadrilla_id': instance.cuadrillaId,
      'sector_id': instance.sectorId,
      'fecha_programacion': instance.fechaProgramacion,
      'fecha_ejecucion_inicio': instance.fechaEjecucionInicio,
      'fecha_ejecucion_fin': instance.fechaEjecucionFin,
      'estado_orden': instance.estadoOrden,
      'insumos_utilizados': instance.insumosUtilizados,
      'observaciones_gasfitero': instance.observacionesGasfitero,
      'ruta_carpeta_evidencias': instance.rutaCarpetaEvidencias,
      'created_at': instance.createdAt,
      'trabajo_ejecutado': instance.trabajoEjecutado,
      'problemas': instance.problemas,
      'soluciones': instance.soluciones,
      'comentarios_instrucciones': instance.comentariosInstrucciones,
      'latitud': instance.latitud,
      'longitud': instance.longitud,
      'fotos_problema_urls': instance.fotosProblemaUrls,
      'fotos_solucion_urls': instance.fotosSolucionUrls,
      'reclamo': instance.reclamo,
      'cuadrilla': instance.cuadrilla,
    };
