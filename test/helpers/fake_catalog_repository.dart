import 'package:hydra/data/repositories/catalog_repository.dart';
import 'package:hydra/domain/models/catalog_option.dart';

class FakeCatalogRepository implements CatalogRepository {
  FakeCatalogRepository({List<CatalogOption>? options})
      : _options = options ?? standardCatalogOptions;

  final List<CatalogOption> _options;

  @override
  Future<List<CatalogOption>> getOptions({bool refresh = false}) async =>
      _options;

  @override
  Future<List<CatalogOption>> getGroup(String group) async =>
      _options.where((option) => option.group == group).toList();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const standardCatalogOptions = <CatalogOption>[
  CatalogOption(
    group: 'FORMATO_RECLAMO',
    code: 'Anexo 6',
    label: 'Anexo 6',
    relatedCode: 'Alcantarillado',
    isDefault: true,
  ),
  CatalogOption(
    group: 'FORMATO_RECLAMO',
    code: 'Formato 1',
    label: 'Formato 1',
    relatedCode: 'Agua',
  ),
  CatalogOption(
    group: 'CANAL_RECLAMO',
    code: 'Presencial',
    label: 'Presencial',
    isDefault: true,
  ),
  CatalogOption(
    group: 'TIPO_PROBLEMA',
    code: 'OP-1',
    label: 'OP-1',
    description: 'Obras inconclusas',
    parentCode: 'Anexo 6',
    isDefault: true,
  ),
  CatalogOption(
    group: 'TIPO_PROBLEMA',
    code: 'B6',
    label: 'B6',
    description: 'Alcantarillado · Atoro',
    parentCode: 'Formato 1',
    isDefault: true,
  ),
  CatalogOption(
    group: 'ESTADO_RECLAMO',
    code: 'PENDIENTE',
    label: 'Pendiente',
    isDefault: true,
  ),
  CatalogOption(
    group: 'ESPECIALIDAD_CUADRILLA',
    code: 'Agua',
    label: 'Agua',
    isDefault: true,
  ),
  CatalogOption(
    group: 'ESPECIALIDAD_CUADRILLA',
    code: 'Alcantarillado',
    label: 'Alcantarillado',
  ),
];
