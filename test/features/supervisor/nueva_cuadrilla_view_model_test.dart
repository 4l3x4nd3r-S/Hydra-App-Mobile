import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/data/repositories/supervisor_repository.dart';
import 'package:hydra/domain/models/gasfitero.dart';
import 'package:hydra/ui/features/supervisor/view_models/nueva_cuadrilla_view_model.dart';

class _FakeSupervisorRepository implements SupervisorRepository {
  final personal = const [
    Gasfitero(
      id: 1,
      nombre: 'Mantenimiento Uno',
      cargo: 'GASFITERO',
      area: 'MANTENIMIENTO',
    ),
    Gasfitero(
      id: 2,
      nombre: 'Mantenimiento Dos',
      cargo: 'GASFITERO',
      area: 'MANTENIMIENTO',
    ),
    Gasfitero(
      id: 3,
      nombre: 'Distribución',
      cargo: 'GASFITERO',
      area: 'DISTRIBUCION',
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
    );
    await Future<void>.delayed(Duration.zero);
  });

  tearDown(() => viewModel.dispose());

  test('Agua y Desagüe usan exclusivamente personal de Mantenimiento', () {
    expect(
      viewModel.gasfiterosDisponiblesParaRol.map((persona) => persona.id),
      [1, 2],
    );

    viewModel.setEspecialidad(EspecialidadOption.desague);

    expect(
      viewModel.gasfiterosDisponiblesParaRol.map((persona) => persona.id),
      [1, 2],
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
