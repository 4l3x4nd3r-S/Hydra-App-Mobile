// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responsable_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResponsableDtoImpl _$$ResponsableDtoImplFromJson(Map<String, dynamic> json) =>
    _$ResponsableDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String?,
      codigoEmpleado: json['codigo_empleado'] as String?,
      cargo: json['cargo'] as String?,
    );

Map<String, dynamic> _$$ResponsableDtoImplToJson(
        _$ResponsableDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'codigo_empleado': instance.codigoEmpleado,
      'cargo': instance.cargo,
    };
