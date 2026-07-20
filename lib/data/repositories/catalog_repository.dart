import '../../domain/models/catalog_option.dart';
import '../models/catalog_option_dto.dart';
import '../services/catalog_api_service.dart';

class CatalogRepository {
  CatalogRepository({required CatalogApiService apiService})
      : _apiService = apiService;

  final CatalogApiService _apiService;
  List<CatalogOption>? _cache;

  Future<List<CatalogOption>> getOptions({bool refresh = false}) async {
    if (!refresh && _cache != null) return List.unmodifiable(_cache!);
    final response = await _apiService.getOperationalCatalog();
    if (response.statusCode != 200 || response.data is! List) {
      throw StateError('El servidor no devolvió los catálogos operativos.');
    }
    _cache = (response.data as List)
        .map((json) => CatalogOptionDto.fromJson(json as Map<String, dynamic>))
        .map(_toDomain)
        .toList(growable: false);
    return List.unmodifiable(_cache!);
  }

  Future<List<CatalogOption>> getGroup(String group) async {
    final options = await getOptions();
    return options.where((option) => option.group == group).toList();
  }

  CatalogOption _toDomain(CatalogOptionDto dto) => CatalogOption(
        group: dto.group,
        code: dto.code,
        label: dto.label,
        description: dto.description,
        parentCode: dto.parentCode,
        relatedCode: dto.relatedCode,
        order: dto.order,
        isDefault: dto.isDefault,
      );
}
