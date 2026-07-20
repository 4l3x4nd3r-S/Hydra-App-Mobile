import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_option.freezed.dart';

@freezed
class CatalogOption with _$CatalogOption {
  const factory CatalogOption({
    required String group,
    required String code,
    required String label,
    String? description,
    String? parentCode,
    String? relatedCode,
    @Default(0) int order,
    @Default(false) bool isDefault,
  }) = _CatalogOption;
}
