// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registro_presion_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistroPresionDtoImpl _$$RegistroPresionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistroPresionDtoImpl(
      fechaHora: json['fecha_hora'] as String?,
      presionMca: (json['presion_mca'] as num?)?.toDouble(),
      temperaturaC: (json['temperatura_c'] as num?)?.toDouble(),
      dispositivoSerie: json['dispositivo_serie'] as String?,
    );

Map<String, dynamic> _$$RegistroPresionDtoImplToJson(
        _$RegistroPresionDtoImpl instance) =>
    <String, dynamic>{
      'fecha_hora': instance.fechaHora,
      'presion_mca': instance.presionMca,
      'temperatura_c': instance.temperaturaC,
      'dispositivo_serie': instance.dispositivoSerie,
    };
