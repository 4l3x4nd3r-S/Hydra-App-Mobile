import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/domain/models/cuadrilla.dart';
import 'package:hydra/domain/models/gasfitero.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/models/reclamo.dart';
import 'package:hydra/data/repositories/supervisor_repository.dart';
import 'package:hydra/domain/use_cases/create_os_from_reclamo_use_case.dart';
import 'package:hydra/ui/features/supervisor/view_models/reclamo_detalle_view_model.dart';
import '../../helpers/fake_catalog_repository.dart';

class _FakeSupervisorRepository implements SupervisorRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCreateOsFromReclamoUseCase extends CreateOsFromReclamoUseCase {
  Exception? exceptionToThrow;
  int? lastReclamoId;
  int? lastCuadrillaId;

  FakeCreateOsFromReclamoUseCase()
      : super(supervisorRepository: _FakeSupervisorRepository());

  @override
  Future<Os> call({
    required int reclamoId,
    required int cuadrillaId,
  }) async {
    lastReclamoId = reclamoId;
    lastCuadrillaId = cuadrillaId;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return Os(
      id: 1,
      numeroOrden: '0000001',
      reclamoId: reclamoId,
      cuadrillaId: cuadrillaId,
      estadoOrden: 'ASIGNADO',
    );
  }
}

void main() {
  late FakeCreateOsFromReclamoUseCase fakeUseCase;
  late ReclamoDetalleViewModel vm;
  final testReclamo = Reclamo(
    id: 10,
    formato: 'Anexo 6',
    codigoSolicitud: '00010',
    estado: 'PENDIENTE',
    descripcion: 'Fuga visible',
    direccion: 'Av. Peru 123',
  );

  setUp(() async {
    fakeUseCase = FakeCreateOsFromReclamoUseCase();
    vm = ReclamoDetalleViewModel(
      reclamo: testReclamo,
      createOsUseCase: fakeUseCase,
      catalogRepository: FakeCatalogRepository(),
    );
    await Future<void>.delayed(Duration.zero);
  });

  test('crearOsFromReclamo devuelve true y propaga parametros correctos',
      () async {
    final ok = await vm.crearOsFromReclamo(4);

    expect(ok, true);
    expect(fakeUseCase.lastReclamoId, 10);
    expect(fakeUseCase.lastCuadrillaId, 4);
    expect(vm.creandoOs, false);
    expect(vm.ultimoError, isNull);
  });

  test('crearOsFromReclamo con DioException 400 devuelve false con mensaje',
      () async {
    fakeUseCase.exceptionToThrow = DioException(
      requestOptions: RequestOptions(path: '/supervisor/ordenes-servicio'),
      response: Response(
        requestOptions: RequestOptions(path: '/supervisor/ordenes-servicio'),
        statusCode: 400,
        data: {'detail': 'El reclamo ya tiene una O.S. activa.'},
      ),
    );

    final ok = await vm.crearOsFromReclamo(4);

    expect(ok, false);
    expect(vm.ultimoError, 'El reclamo ya tiene una O.S. activa.');
    expect(vm.creandoOs, false);
  });

  test(
      'crearOsFromReclamo con DioException 403 devuelve false con mensaje de permisos',
      () async {
    fakeUseCase.exceptionToThrow = DioException(
      requestOptions: RequestOptions(path: '/supervisor/ordenes-servicio'),
      response: Response(
        requestOptions: RequestOptions(path: '/supervisor/ordenes-servicio'),
        statusCode: 403,
      ),
    );

    final ok = await vm.crearOsFromReclamo(4);

    expect(ok, false);
    expect(vm.ultimoError, contains('permisos'));
    expect(vm.creandoOs, false);
  });

  test(
      'crearOsFromReclamo con excepcion generica devuelve false con mensaje generico',
      () async {
    fakeUseCase.exceptionToThrow = Exception('Fallo inesperado');

    final ok = await vm.crearOsFromReclamo(4);

    expect(ok, false);
    expect(vm.ultimoError, contains('Error inesperado'));
    expect(vm.creandoOs, false);
  });

  test('crearOsFromReclamo establece creandoOs a true durante la operacion',
      () async {
    final future = vm.crearOsFromReclamo(4);
    expect(vm.creandoOs, true);
    await future;
    expect(vm.creandoOs, false);
  });

  test('crearOsFromReclamo con 500 devuelve mensaje de servidor', () async {
    fakeUseCase.exceptionToThrow = DioException(
      requestOptions: RequestOptions(path: '/supervisor/ordenes-servicio'),
      response: Response(
        requestOptions: RequestOptions(path: '/supervisor/ordenes-servicio'),
        statusCode: 500,
      ),
    );

    final ok = await vm.crearOsFromReclamo(4);

    expect(ok, false);
    expect(vm.ultimoError, contains('Error del servidor'));
  });

  test('crearOsFromReclamo con 401 devuelve mensaje de sesion expirada',
      () async {
    fakeUseCase.exceptionToThrow = DioException(
      requestOptions: RequestOptions(path: '/supervisor/ordenes-servicio'),
      response: Response(
        requestOptions: RequestOptions(path: '/supervisor/ordenes-servicio'),
        statusCode: 401,
      ),
    );

    final ok = await vm.crearOsFromReclamo(4);

    expect(ok, false);
    expect(vm.ultimoError, contains('expirada'));
  });

  test('Anexo 6 filtra únicamente cuadrillas de Alcantarillado', () {
    final cuadrillas = [
      Cuadrilla(
        id: 1,
        especialidad: 'Agua',
        lider: const Gasfitero(id: 1, nombre: 'Líder Agua'),
      ),
      Cuadrilla(
        id: 2,
        especialidad: 'Alcantarillado',
        lider: const Gasfitero(id: 2, nombre: 'Líder Alcantarillado'),
      ),
    ];

    expect(vm.especialidadRequerida, 'Alcantarillado');
    expect(vm.filtrarCuadrillasCompatibles(cuadrillas).map((c) => c.id), [2]);
  });

  test('Formato 1 filtra únicamente cuadrillas de Agua', () async {
    final vmFormato1 = ReclamoDetalleViewModel(
      reclamo: testReclamo.copyWith(formato: 'Formato 1'),
      createOsUseCase: fakeUseCase,
      catalogRepository: FakeCatalogRepository(),
    );
    await Future<void>.delayed(Duration.zero);
    addTearDown(vmFormato1.dispose);
    final cuadrillas = [
      const Cuadrilla(id: 1, especialidad: 'Agua'),
      const Cuadrilla(id: 2, especialidad: 'Alcantarillado'),
    ];

    expect(vmFormato1.especialidadRequerida, 'Agua');
    expect(
      vmFormato1.filtrarCuadrillasCompatibles(cuadrillas).map((c) => c.id),
      [1],
    );
  });
}
