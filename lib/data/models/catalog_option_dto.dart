import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_option_dto.freezed.dart';
part 'catalog_option_dto.g.dart';

@freezed
class CatalogOptionDto with _$CatalogOptionDto {
  const factory CatalogOptionDto({
    @JsonKey(name: 'grupo') required String group,
    @JsonKey(name: 'codigo') required String code,
    @JsonKey(name: 'etiqueta') required String label,
    @JsonKey(name: 'descripcion') String? description,
    @JsonKey(name: 'padre_codigo') String? parentCode,
    @JsonKey(name: 'relacionado_codigo') String? relatedCode,
    @JsonKey(name: 'orden') @Default(0) int order,
    @JsonKey(name: 'predeterminado') @Default(false) bool isDefault,
  }) = _CatalogOptionDto;

  factory CatalogOptionDto.fromJson(Map<String, dynamic> json) =>
      _$CatalogOptionDtoFromJson(json);
}
