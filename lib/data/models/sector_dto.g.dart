// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sector_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SectorDtoImpl _$$SectorDtoImplFromJson(Map<String, dynamic> json) =>
    _$SectorDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String?,
      reservorioAsociado: json['reservorio_asociado'] as String?,
    );

Map<String, dynamic> _$$SectorDtoImplToJson(_$SectorDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'reservorio_asociado': instance.reservorioAsociado,
    };
