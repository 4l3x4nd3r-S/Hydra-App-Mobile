import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/domain/models/reclamo.dart';
import 'package:hydra/domain/models/cuadrilla.dart';
import 'package:hydra/domain/models/gasfitero.dart';
import 'package:hydra/data/repositories/auth_repository.dart';
import 'package:hydra/data/repositories/supervisor_repository.dart';
import 'package:hydra/ui/features/supervisor/view_models/supervisor_view_model.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<String?> getUserName() async => 'Supervisor Test';

  @override
  Future<String?> getUserRole() async => 'SUPERVISOR';

  @override
  Future<String?> getUserCode() async => 'SUP001';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSupervisorRepository implements SupervisorRepository {
  List<Reclamo> reclamos = [];
  List<Cuadrilla> cuadrillas = [];
  List<Gasfitero> personal = [];
  Exception? reclamosException;

  @override
  Future<List<Reclamo>> getReclamos() async {
    if (reclamosException != null) throw reclamosException!;
    return reclamos;
  }

  @override
  Future<List<Cuadrilla>> getCuadrillas() async => cuadrillas;

  @override
  Future<List<Gasfitero>> getgasfiteros() async => personal;

  @override
  Future<List<Gasfitero>> getgasfiterosDisponibles() async => [];

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

  tearDown(() => vm.dispose());

  group('Roles visibles del personal', () {
    test('conserva las funciones y cuadrillas entregadas por el backend',
        () async {
      const principal = Gasfitero(
        id: 10,
        nombre: 'Principal',
        dni: '71234567',
        celular: '912345678',
        cargo: 'GASFITERO',
        area: 'MANTENIMIENTO',
        rolEnCuadrilla: 'LIDER',
        funcionVisible: 'Gasfitero principal',
        esPrincipal: true,
        cuadrillaId: 1,
        codigoCuadrilla: 'Cuadrilla 001',
      );
      const apoyo = Gasfitero(
        id: 11,
        nombre: 'Apoyo',
        cargo: 'GASFITERO',
        area: 'MANTENIMIENTO',
        rolEnCuadrilla: 'APOYO',
        funcionVisible: 'Gasfitero de apoyo',
        cuadrillaId: 1,
        codigoCuadrilla: 'Cuadrilla 001',
      );
      const sinCuadrilla = Gasfitero(
        id: 12,
        nombre: 'Disponible',
        cargo: 'GASFITERO_PRINCIPAL',
        area: 'MANTENIMIENTO',
        funcionVisible: 'Gasfitero',
      );
      fakeRepo.personal = [principal, apoyo, sinCuadrilla];

      await vm.cargarTodo();

      final personal = vm.personalMantenimientoOrdenado;
      expect(personal[0].funcionVisible, 'Gasfitero principal');
      expect(personal[0].dni, '71234567');
      expect(personal[0].celular, '912345678');
      expect(personal[0].esPrincipal, isTrue);
      expect(personal[1].funcionVisible, 'Gasfitero de apoyo');
      expect(personal[1].codigoCuadrilla, 'Cuadrilla 001');
      expect(personal[2].funcionVisible, 'Gasfitero');
      expect(personal[2].cuadrillaId, isNull);
    });

    test('respeta el orden de personal definido por el backend', () async {
      const primero = Gasfitero(
        id: 20,
        nombre: 'Primero',
        funcionVisible: 'Gasfitero de apoyo',
      );
      const segundo = Gasfitero(
        id: 21,
        nombre: 'Segundo',
        funcionVisible: 'Gasfitero',
      );
      fakeRepo.personal = [primero, segundo];

      await vm.cargarTodo();

      expect(
        vm.personalMantenimientoOrdenado.map((persona) => persona.id),
        [20, 21],
      );
    });
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

    test('reclamosAsignados incluye ASIGNADO, EN PROCESO y EN_PROCESO',
        () async {
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
    test('DioException 500: loadingReclamos=false, errorMessage poblado',
        () async {
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
