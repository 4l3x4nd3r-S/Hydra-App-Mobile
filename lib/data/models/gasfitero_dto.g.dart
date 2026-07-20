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
      dni: json['dni'] as String?,
      celular: json['celular'] as String?,
      cargo: json['cargo'] as String?,
      cargoVisible: json['cargo_visible'] as String?,
      area: json['area'] as String?,
      areaVisible: json['area_visible'] as String?,
      rolEnCuadrilla: json['rol_en_cuadrilla'] as String?,
      funcionVisible: json['funcion_visible'] as String?,
      esPrincipal: json['es_principal'] as bool? ?? false,
      puedeSerGasfitero: json['puede_ser_gasfitero'] as bool? ?? false,
      puedeSerChofer: json['puede_ser_chofer'] as bool? ?? false,
      cuadrillaId: (json['cuadrilla_id'] as num?)?.toInt(),
      codigoCuadrilla: json['codigo_cuadrilla'] as String?,
    );

Map<String, dynamic> _$$GasfiteroDtoImplToJson(_$GasfiteroDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'codigo_empleado': instance.codigoEmpleado,
      'dni': instance.dni,
      'celular': instance.celular,
      'cargo': instance.cargo,
      'cargo_visible': instance.cargoVisible,
      'area': instance.area,
      'area_visible': instance.areaVisible,
      'rol_en_cuadrilla': instance.rolEnCuadrilla,
      'funcion_visible': instance.funcionVisible,
      'es_principal': instance.esPrincipal,
      'puede_ser_gasfitero': instance.puedeSerGasfitero,
      'puede_ser_chofer': instance.puedeSerChofer,
      'cuadrilla_id': instance.cuadrillaId,
      'codigo_cuadrilla': instance.codigoCuadrilla,
    };
