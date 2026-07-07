// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gasfitero_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GasfiteroDtoImpl _$$GasfiteroDtoImplFromJson(Map<String, dynamic> json) =>
    _$GasfiteroDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String?,
      codigoEmpleado: json['codigo_empleado'] as String?,
      cargo: json['cargo'] as String?,
      area: json['area'] as String?,
      rolEnCuadrilla: json['rol_en_cuadrilla'] as String?,
    );

Map<String, dynamic> _$$GasfiteroDtoImplToJson(_$GasfiteroDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'codigo_empleado': instance.codigoEmpleado,
      'cargo': instance.cargo,
      'area': instance.area,
      'rol_en_cuadrilla': instance.rolEnCuadrilla,
    };
