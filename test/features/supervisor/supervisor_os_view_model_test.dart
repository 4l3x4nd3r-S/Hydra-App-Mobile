import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/models/pending_sync_report.dart';
import 'package:hydra/data/repositories/os_repository.dart';
import 'package:hydra/data/repositories/supervisor_repository.dart';
import 'package:hydra/ui/features/supervisor/view_models/supervisor_os_view_model.dart';

class _FakeOsRepository implements OsRepository {
  final List<PendingSyncReport> pendingReports;
  final StreamController<void> _syncController =
      StreamController<void>.broadcast();

  _FakeOsRepository({this.pendingReports = const []});

  @override
  Stream<void> get syncStream => _syncController.stream;

  @override
  Future<List<PendingSyncReport>> getPendingReports() async => pendingReports;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSupervisorRepository implements SupervisorRepository {
  List<Os>? osList;
  Exception? exceptionToThrow;

  @override
  Future<List<Os>> getOrdenesServicio() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return osList ?? [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeSupervisorRepository fakeSupervisorRepo;
  late _FakeOsRepository fakeOsRepo;
  late SupervisorOsViewModel vm;

  setUp(() {
    fakeSupervisorRepo = _FakeSupervisorRepository();
    fakeOsRepo = _FakeOsRepository();
    vm = SupervisorOsViewModel(
      osRepository: fakeOsRepo,
      supervisorRepository: fakeSupervisorRepo,
    );
  });

  test('cargarTodo en caso feliz: isLoading=false, errorMessage=null', () async {
    fakeSupervisorRepo.osList = [
      Os(id: 1, numeroOrden: 'OS-001', estadoOrden: 'ASIGNADO')
    ];

    await vm.cargarTodo();

    expect(vm.isLoading, false);
    expect(vm.errorMessage, isNull);
    expect(vm.osActivas.length, 1);
    expect(vm.osActivas[0].numeroOrden, 'OS-001');
  });

  test('cargarTodo con DioException 500: isLoading=false, errorMessage poblado', () async {
    fakeSupervisorRepo.exceptionToThrow = DioException(
      requestOptions: RequestOptions(path: '/supervisor/ordenes-servicio'),
      response: Response(
        requestOptions: RequestOptions(path: '/supervisor/ordenes-servicio'),
        statusCode: 500,
      ),
    );

    await vm.cargarTodo();

    expect(vm.isLoading, false);
    expect(vm.errorMessage, contains('servidor'));
    expect(vm.osActivas, isEmpty);
  });

  test('cargarTodo con excepcion generica: isLoading=false, errorMessage generico', () async {
    fakeSupervisorRepo.exceptionToThrow = Exception('Red no disponible');

    await vm.cargarTodo();

    expect(vm.isLoading, false);
    expect(vm.errorMessage, contains('inesperado'));
    expect(vm.osActivas, isEmpty);
  });
}
