// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cuadrilla_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CuadrillaDtoImpl _$$CuadrillaDtoImplFromJson(Map<String, dynamic> json) =>
    _$CuadrillaDtoImpl(
      id: (json['id'] as num).toInt(),
      codigoGrupo: json['codigo_grupo'] as String?,
      especialidad: json['especialidad'] as String?,
      lider: json['lider'] == null
          ? null
          : GasfiteroDto.fromJson(json['lider'] as Map<String, dynamic>),
      apoyos: (json['apoyos'] as List<dynamic>?)
              ?.map((e) => GasfiteroDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      chofer: json['chofer'] == null
          ? null
          : GasfiteroDto.fromJson(json['chofer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CuadrillaDtoImplToJson(_$CuadrillaDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigo_grupo': instance.codigoGrupo,
      'especialidad': instance.especialidad,
      'lider': instance.lider,
      'apoyos': instance.apoyos,
      'chofer': instance.chofer,
    };
