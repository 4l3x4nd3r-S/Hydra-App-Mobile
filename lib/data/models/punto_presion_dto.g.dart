// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'punto_presion_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PuntoPresionDtoImpl _$$PuntoPresionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PuntoPresionDtoImpl(
      id: (json['id'] as num).toInt(),
      codigoPunto: json['codigo_punto'] as String?,
      sectorId: (json['sector_id'] as num?)?.toInt(),
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PuntoPresionDtoImplToJson(
        _$PuntoPresionDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigo_punto': instance.codigoPunto,
      'sector_id': instance.sectorId,
      'latitud': instance.latitud,
      'longitud': instance.longitud,
    };
