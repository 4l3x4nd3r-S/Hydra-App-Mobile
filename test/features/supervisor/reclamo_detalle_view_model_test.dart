import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/models/reclamo.dart';
import 'package:hydra/data/repositories/supervisor_repository.dart';
import 'package:hydra/domain/use_cases/create_os_from_reclamo_use_case.dart';
import 'package:hydra/ui/features/supervisor/view_models/reclamo_detalle_view_model.dart';

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
      numeroOrden: 'OS-20260703-0001',
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
    formato: 'F-001',
    codigoSolicitud: 'CS-001',
    estado: 'PENDIENTE',
    descripcion: 'Fuga visible',
    direccion: 'Av. Peru 123',
  );

  setUp(() {
    fakeUseCase = FakeCreateOsFromReclamoUseCase();
    vm = ReclamoDetalleViewModel(
      reclamo: testReclamo,
      createOsUseCase: fakeUseCase,
    );
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
}
