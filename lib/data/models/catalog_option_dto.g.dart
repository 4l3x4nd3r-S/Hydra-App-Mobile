// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_option_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogOptionDtoImpl _$$CatalogOptionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CatalogOptionDtoImpl(
      group: json['grupo'] as String,
      code: json['codigo'] as String,
      label: json['etiqueta'] as String,
      description: json['descripcion'] as String?,
      parentCode: json['padre_codigo'] as String?,
      relatedCode: json['relacionado_codigo'] as String?,
      order: (json['orden'] as num?)?.toInt() ?? 0,
      isDefault: json['predeterminado'] as bool? ?? false,
    );

Map<String, dynamic> _$$CatalogOptionDtoImplToJson(
        _$CatalogOptionDtoImpl instance) =>
    <String, dynamic>{
      'grupo': instance.group,
      'codigo': instance.code,
      'etiqueta': instance.label,
      'descripcion': instance.description,
      'padre_codigo': instance.parentCode,
      'relacionado_codigo': instance.relatedCode,
      'orden': instance.order,
      'predeterminado': instance.isDefault,
    };
