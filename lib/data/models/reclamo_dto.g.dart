// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reclamo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReclamoDtoImpl _$$ReclamoDtoImplFromJson(Map<String, dynamic> json) =>
    _$ReclamoDtoImpl(
      id: (json['id'] as num).toInt(),
      formato: json['formato'] as String?,
      codigoSolicitud: json['codigo_solicitud'] as String?,
      fechaRegistro: json['fecha_registro'] as String?,
      canalEntrada: json['canal_entrada'] as String?,
      tipoProblema: json['tipo_problema'] as String?,
      estado: json['estado'] as String?,
      descripcion: json['descripcion'] as String?,
      nombreSolicitante: json['nombre_solicitante'] as String?,
      direccion: json['direccion'] as String?,
      numeroSuministro: json['numero_suministro'] as String?,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$ReclamoDtoImplToJson(_$ReclamoDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'formato': instance.formato,
      'codigo_solicitud': instance.codigoSolicitud,
      'fecha_registro': instance.fechaRegistro,
      'canal_entrada': instance.canalEntrada,
      'tipo_problema': instance.tipoProblema,
      'estado': instance.estado,
      'descripcion': instance.descripcion,
      'nombre_solicitante': instance.nombreSolicitante,
      'direccion': instance.direccion,
      'numero_suministro': instance.numeroSuministro,
      'telefono': instance.telefono,
      'email': instance.email,
    };
