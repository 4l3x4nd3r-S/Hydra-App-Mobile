import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/domain/models/reclamo.dart';
import 'package:hydra/domain/models/cuadrilla.dart';
import 'package:hydra/domain/models/tecnico.dart';
import 'package:hydra/data/repositories/auth_repository.dart';
import 'package:hydra/data/repositories/supervisor_repository.dart';
import 'package:hydra/ui/features/supervisor/view_models/supervisor_view_model.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<String?> getUserName() async => 'Supervisor Test';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSupervisorRepository implements SupervisorRepository {
  List<Reclamo> reclamos = [];
  Exception? reclamosException;

  @override
  Future<List<Reclamo>> getReclamos() async {
    if (reclamosException != null) throw reclamosException!;
    return reclamos;
  }

  @override
  Future<List<Cuadrilla>> getCuadrillas() async => [];

  @override
  Future<List<Tecnico>> getTecnicos({String? area}) async => [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeSupervisorRepository fakeRepo;
  late SupervisorViewModel vm;

  setUp(() {
    fakeRepo = _FakeSupervisorRepository();
    vm = SupervisorViewModel(
      supervisorRepository: fakeRepo,
      authRepository: _FakeAuthRepository(),
    );
  });

  group('Getters de filtrado de reclamos', () {
    test('reclamosPendientes filtra por estado PENDIENTE', () async {
      fakeRepo.reclamos = [
        Reclamo(id: 1, estado: 'PENDIENTE'),
        Reclamo(id: 2, estado: 'ASIGNADO'),
        Reclamo(id: 3, estado: 'PENDIENTE'),
        Reclamo(id: 4, estado: 'ATENDIDO'),
      ];
      await vm.cargarTodo();

      final pendientes = vm.reclamosPendientes;
      expect(pendientes.length, 2);
      expect(pendientes.map((r) => r.id), [1, 3]);
    });

    test('reclamosAsignados incluye ASIGNADO, EN PROCESO y EN_PROCESO', () async {
      fakeRepo.reclamos = [
        Reclamo(id: 1, estado: 'PENDIENTE'),
        Reclamo(id: 2, estado: 'ASIGNADO'),
        Reclamo(id: 3, estado: 'EN PROCESO'),
        Reclamo(id: 4, estado: 'EN_PROCESO'),
        Reclamo(id: 5, estado: 'ATENDIDO'),
      ];
      await vm.cargarTodo();

      final asignados = vm.reclamosAsignados;
      expect(asignados.length, 3);
      expect(asignados.map((r) => r.id), [2, 3, 4]);
    });

    test('reclamosCerrados incluye ATENDIDO, RECHAZADO, COMPLETADO', () async {
      fakeRepo.reclamos = [
        Reclamo(id: 1, estado: 'PENDIENTE'),
        Reclamo(id: 2, estado: 'ATENDIDO'),
        Reclamo(id: 3, estado: 'RECHAZADO'),
        Reclamo(id: 4, estado: 'COMPLETADO'),
        Reclamo(id: 5, estado: 'ASIGNADO'),
      ];
      await vm.cargarTodo();

      final cerrados = vm.reclamosCerrados;
      expect(cerrados.length, 3);
      expect(cerrados.map((r) => r.id), [2, 3, 4]);
    });

    test('reclamos sin estado (null) caen en PENDIENTES', () async {
      fakeRepo.reclamos = [
        Reclamo(id: 1, estado: null),
        Reclamo(id: 2, estado: 'ASIGNADO'),
      ];
      await vm.cargarTodo();

      final pendientes = vm.reclamosPendientes;
      final asignados = vm.reclamosAsignados;

      expect(pendientes.length, 1);
      expect(pendientes[0].id, 1);
      expect(asignados.length, 1);
      expect(asignados[0].id, 2);
    });
  });

  group('Manejo de errores al cargar reclamos', () {
    test('DioException 500: loadingReclamos=false, errorMessage poblado', () async {
      fakeRepo.reclamosException = DioException(
        requestOptions: RequestOptions(path: '/reclamos'),
        response: Response(
          requestOptions: RequestOptions(path: '/reclamos'),
          statusCode: 500,
        ),
      );

      await vm.cargarTodo();

      expect(vm.loadingReclamos, false);
      expect(vm.errorMessageReclamos, contains('servidor'));
      expect(vm.reclamos, isEmpty);
      expect(vm.reclamosPendientes, isEmpty);
    });
  });

  group('Notificacion en modo silent', () {
    test('cargarTodo(silent: true) notifica a los listeners', () async {
      fakeRepo.reclamos = [Reclamo(id: 1, estado: 'PENDIENTE')];
      await vm.cargarTodo();

      var listenerCalled = false;
      vm.addListener(() => listenerCalled = true);

      fakeRepo.reclamos = [Reclamo(id: 2, estado: 'ASIGNADO')];
      await vm.cargarTodo(silent: true);

      expect(listenerCalled, true);
      expect(vm.reclamosAsignados.length, 1);
      expect(vm.reclamosAsignados[0].id, 2);
    });

    test('cargarTodo(silent: true) actualiza getters con datos nuevos',
        () async {
      fakeRepo.reclamos = [
        Reclamo(id: 1, estado: 'PENDIENTE'),
        Reclamo(id: 2, estado: 'PENDIENTE'),
      ];
      await vm.cargarTodo();
      expect(vm.reclamosPendientes.length, 2);
      expect(vm.reclamosAsignados.length, 0);

      fakeRepo.reclamos = [
        Reclamo(id: 1, estado: 'PENDIENTE'),
        Reclamo(id: 2, estado: 'ASIGNADO'),
      ];
      await vm.cargarTodo(silent: true);

      expect(vm.reclamosPendientes.length, 1);
      expect(vm.reclamosPendientes[0].id, 1);
      expect(vm.reclamosAsignados.length, 1);
      expect(vm.reclamosAsignados[0].id, 2);
    });
  });
}
