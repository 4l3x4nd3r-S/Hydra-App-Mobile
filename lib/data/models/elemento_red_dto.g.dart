// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elemento_red_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ElementoRedDtoImpl _$$ElementoRedDtoImplFromJson(Map<String, dynamic> json) =>
    _$ElementoRedDtoImpl(
      id: (json['id'] as num).toInt(),
      codigoPlano: json['codigo_plano'] as String?,
      tipo: json['tipo'] as String?,
      sectorId: (json['sector_id'] as num?)?.toInt(),
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      estadoOperativo: json['estado_operativo'] as String?,
      fechaModificacion: json['fecha_modificacion'] as String?,
      estadoValvula: json['estado_valvula'] as String?,
    );

Map<String, dynamic> _$$ElementoRedDtoImplToJson(
        _$ElementoRedDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigo_plano': instance.codigoPlano,
      'tipo': instance.tipo,
      'sector_id': instance.sectorId,
      'latitud': instance.latitud,
      'longitud': instance.longitud,
      'estado_operativo': instance.estadoOperativo,
      'fecha_modificacion': instance.fechaModificacion,
      'estado_valvula': instance.estadoValvula,
    };
