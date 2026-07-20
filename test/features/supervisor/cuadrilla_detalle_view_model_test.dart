import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/data/repositories/supervisor_repository.dart';
import 'package:hydra/domain/models/cuadrilla.dart';
import 'package:hydra/domain/models/gasfitero.dart';
import 'package:hydra/ui/features/supervisor/view_models/cuadrilla_detalle_view_model.dart';

const _lider = Gasfitero(
  id: 1,
  nombre: 'Raul Coral Murrieta',
  cargo: 'GASFITERO PRINCIPAL',
  puedeSerGasfitero: true,
);
const _apoyo = Gasfitero(
  id: 2,
  nombre: 'Juan David Quispe Guerra',
  cargo: 'GASFITERO',
  puedeSerGasfitero: true,
);
const _disponibleUno = Gasfitero(
  id: 3,
  nombre: 'Juan Pablo Rodriguez Chapiama',
  cargo: 'GASFITERO',
  puedeSerGasfitero: true,
);
const _disponibleDos = Gasfitero(
  id: 4,
  nombre: 'Yordy Dancuart Guerra',
  cargo: 'GASFITERO',
  puedeSerGasfitero: true,
);

class _FakeSupervisorRepository implements SupervisorRepository {
  Cuadrilla current = const Cuadrilla(
    id: 10,
    codigoGrupo: 'Cuadrilla 001',
    especialidad: 'Agua',
    lider: _lider,
    apoyos: [_apoyo],
  );

  int updateCalls = 0;
  int? receivedLeaderId;
  List<int>? receivedSupportIds;

  final Map<int, Gasfitero> _people = const {
    1: _lider,
    2: _apoyo,
    3: _disponibleUno,
    4: _disponibleDos,
  };

  @override
  Future<Cuadrilla> getCuadrilla(int id) async => current;

  @override
  Future<List<Gasfitero>> getgasfiterosDisponibles() async => const [
        _disponibleUno,
        _disponibleDos,
      ];

  @override
  Future<Cuadrilla> updateCuadrillaPersonal({
    required int cuadrillaId,
    required int liderId,
    required List<int> apoyosIds,
    int? choferId,
  }) async {
    updateCalls++;
    receivedLeaderId = liderId;
    receivedSupportIds = [...apoyosIds];
    current = current.copyWith(
      lider: _people[liderId],
      apoyos: apoyosIds.map((id) => _people[id]!).toList(),
    );
    return current;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeSupervisorRepository repository;
  late CuadrillaDetalleViewModel viewModel;

  setUp(() async {
    repository = _FakeSupervisorRepository();
    viewModel = CuadrillaDetalleViewModel(
      supervisorRepository: repository,
      cuadrilla: repository.current,
      gasfiteros: const [],
    );
    await Future<void>.delayed(Duration.zero);
  });

  tearDown(() => viewModel.dispose());

  test('guarda varios apoyos juntos en una sola operación', () async {
    final updated = await viewModel.updateSupports({2, 3, 4});

    expect(updated, isTrue);
    expect(repository.updateCalls, 1);
    expect(repository.receivedLeaderId, 1);
    expect(repository.receivedSupportIds, [2, 3, 4]);
    expect(viewModel.current.apoyos.map((persona) => persona.id), [2, 3, 4]);
  });

  test('al cambiar principal mantiene uno solo y mueve al anterior a apoyo',
      () async {
    final updated = await viewModel.changeLeader(2);

    expect(updated, isTrue);
    expect(repository.updateCalls, 1);
    expect(repository.receivedLeaderId, 2);
    expect(repository.receivedSupportIds, [1]);
    expect(viewModel.current.lider?.id, 2);
    expect(viewModel.current.apoyos.map((persona) => persona.id), [1]);
  });

  test('los candidatos incluyen apoyos actuales y personal disponible', () {
    expect(viewModel.candidatosApoyo.map((persona) => persona.id), [2, 3, 4]);
    expect(
        viewModel.candidatosLider.map((persona) => persona.id), [2, 3, 1, 4]);
  });
}
