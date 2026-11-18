import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/ui/features/supervisor/view_models/supervisor_os_view_model.dart';

import '../../helpers/fake_catalog_repository.dart';
import '../../helpers/os_export_fixtures.dart';

void main() {
  late ExportSupervisorRepository supervisor;
  late ExportOsRepository local;
  late SupervisorOsViewModel vm;

  setUp(() async {
    supervisor = ExportSupervisorRepository();
    local = ExportOsRepository();
    vm = SupervisorOsViewModel(
        osRepository: local,
        supervisorRepository: supervisor,
        catalogRepository: FakeCatalogRepository());
    await vm.cargarTodo();
  });
  tearDown(() async {
    vm.dispose();
    await local.changes.close();
  });

  test('consulta datos nuevos al exportar y conserva las órdenes de la bandeja',
      () async {
    final calls = supervisor.calls;
    supervisor.orders = [
      completedExportOrder,
      completedExportOrder.copyWith(id: 8)
    ];
    final report = await vm.exportCompletedOrders();
    expect(report?.orderCount, 2);
    expect(supervisor.calls, calls + 1);
    expect(vm.osArchivadas.length, 1);
    expect(vm.isExporting, isFalse);
    expect(vm.exportErrorMessage, isNull);
  });

  test('excluye del Excel los reportes pendientes de sincronización', () async {
    local.reports = [pendingExportReport(7)];
    expect(await vm.exportCompletedOrders(), isNull);
    expect(vm.exportErrorMessage, contains('sincronizadas'));
    expect(vm.isExporting, isFalse);
  });

  test('no exporta la lista anterior si falla la consulta al servidor',
      () async {
    supervisor.failure = DioException(
        requestOptions: RequestOptions(path: '/supervisor/ordenes-servicio'));
    expect(await vm.exportCompletedOrders(), isNull);
    expect(vm.exportErrorMessage, contains('conexion'));
    expect(vm.isExporting, isFalse);
  });

  test('impide solicitudes de exportación simultáneas', () async {
    final response = Completer<List<Os>>();
    supervisor.nextResponse = response;
    final export = vm.exportCompletedOrders();
    expect(vm.isExporting, isTrue);
    final calls = supervisor.calls;
    expect(await vm.exportCompletedOrders(), isNull);
    expect(supervisor.calls, calls);
    response.complete([completedExportOrder]);
    expect((await export)?.orderCount, 1);
    expect(vm.isExporting, isFalse);
  });

  test(
      'salir del módulo durante la consulta no notifica un ViewModel descartado',
      () async {
    final other = SupervisorOsViewModel(
        osRepository: local, supervisorRepository: supervisor);
    await other.cargarTodo();
    final response = Completer<List<Os>>();
    supervisor.nextResponse = response;
    final export = other.exportCompletedOrders();
    other.dispose();
    response.complete([completedExportOrder]);
    expect(await export, isNull);
  });
}
