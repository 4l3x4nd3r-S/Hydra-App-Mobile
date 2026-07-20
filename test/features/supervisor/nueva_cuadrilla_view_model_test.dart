import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/data/repositories/supervisor_repository.dart';
import 'package:hydra/domain/models/gasfitero.dart';
import 'package:hydra/ui/features/supervisor/view_models/nueva_cuadrilla_view_model.dart';
import '../../helpers/fake_catalog_repository.dart';

class _FakeSupervisorRepository implements SupervisorRepository {
  final personal = const [
    Gasfitero(
      id: 1,
      nombre: 'Mantenimiento Uno',
      cargo: 'GASFITERO',
      area: 'MANTENIMIENTO',
      puedeSerGasfitero: true,
    ),
    Gasfitero(
      id: 2,
      nombre: 'Mantenimiento Dos',
      cargo: 'GASFITERO',
      area: 'MANTENIMIENTO',
      puedeSerGasfitero: true,
    ),
    Gasfitero(
      id: 3,
      nombre: 'Chofer Único',
      cargo: 'CHOFER_CAMIONETA',
      area: 'MANTENIMIENTO',
      funcionVisible: 'Chofer',
      puedeSerChofer: true,
    ),
  ];

  @override
  Future<List<Gasfitero>> getgasfiterosDisponibles() async => personal;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late NuevaCuadrillaViewModel viewModel;

  setUp(() async {
    viewModel = NuevaCuadrillaViewModel(
      supervisorRepository: _FakeSupervisorRepository(),
      catalogRepository: FakeCatalogRepository(),
    );
    await Future<void>.delayed(Duration.zero);
  });

  tearDown(() => viewModel.dispose());

  test('usa las funciones elegibles entregadas por el backend', () {
    expect(
      viewModel.gasfiterosDisponiblesParaRol.map((persona) => persona.id),
      [1, 2],
    );
    expect(
      viewModel.choferesDisponibles.map((persona) => persona.id),
      [3],
    );

    viewModel.setEspecialidad(
      viewModel.especialidades
          .firstWhere((option) => option.value == 'Alcantarillado'),
    );

    expect(
      viewModel.gasfiterosDisponiblesParaRol.map((persona) => persona.id),
      [1, 2],
    );
    expect(
      viewModel.choferesDisponibles.map((persona) => persona.id),
      [3],
    );
  });

  test('requiere al menos dos integrantes para crear la cuadrilla', () {
    viewModel.setLider(viewModel.gasfiteros[0]);

    expect(viewModel.canSubmit, isFalse);
    expect(viewModel.validar(), isFalse);
    expect(viewModel.errorMsg, contains('al menos 2 integrantes'));

    viewModel.toggleApoyo(viewModel.gasfiteros[1]);

    expect(viewModel.canSubmit, isTrue);
    expect(viewModel.validar(), isTrue);
  });
}
