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

  /// Devuelve "CÓDIGO - descripción" para un tipo de problema usando el
  /// catálogo importado desde Excel. Si no hay descripción, devuelve el código.
  Future<String> tipoProblemaLabel(String? code) async {
    final trimmed = code?.trim() ?? '';
    if (trimmed.isEmpty) return '';
    try {
      final options = await getGroup('TIPO_PROBLEMA');
      for (final option in options) {
        if (option.code.trim().toUpperCase() != trimmed.toUpperCase()) continue;
        final description = option.description?.trim() ?? '';
        if (description.isNotEmpty) return '$trimmed - $description';
        final label = option.label.trim();
        if (label.isNotEmpty && label.toUpperCase() != trimmed.toUpperCase()) {
          return '$trimmed - $label';
        }
        break;
      }
    } catch (_) {
      // Sin catálogo disponible: se muestra solo el código.
    }
    return trimmed;
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
