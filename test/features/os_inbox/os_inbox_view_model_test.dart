import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/data/repositories/auth_repository.dart';
import 'package:hydra/data/repositories/os_repository.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/models/os_start_result.dart';
import 'package:hydra/domain/models/pending_sync_report.dart';
import 'package:hydra/domain/use_cases/start_os_use_case.dart';
import 'package:hydra/domain/use_cases/sync_pending_reports_use_case.dart';
import 'package:hydra/ui/features/os_inbox/view_models/os_inbox_view_model.dart';

class _FakeOsRepository implements OsRepository {
  _FakeOsRepository({required this.orders, required this.reports});

  final List<Os> orders;
  final List<PendingSyncReport> reports;
  final _controller = StreamController<void>.broadcast();

  @override
  Stream<void> get syncStream => _controller.stream;

  @override
  Future<List<Os>> getAssignedOrders() async => orders;

  @override
  Future<List<PendingSyncReport>> getPendingReports() async => reports;

  Future<void> close() => _controller.close();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<String?> getUserName() async => 'Líder';

  @override
  Future<String?> getUserRole() async => 'GASFITERO';

  @override
  Future<String?> getUserCode() async => 'G-01';

  @override
  Future<int?> getUserId() async => 10;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStartOsUseCase implements StartOsUseCase {
  _FakeStartOsUseCase();

  static const result = OsStartResult(
    startedAt: '2026-07-16T15:00:00.000Z',
    queuedOffline: true,
  );

  @override
  Future<OsStartResult> call(int ordenId) async => result;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSyncPendingReportsUseCase implements SyncPendingReportsUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

PendingSyncReport _pendingReport(int osId) => PendingSyncReport(
      osId: osId,
      insumosUtilizados: null,
      observacionesGasfitero: 'Trabajo guardado localmente',
      rutaCarpetaEvidencias: null,
      trabajoEjecutado: null,
      problemas: null,
      soluciones: null,
      comentariosInstrucciones: null,
      latitud: null,
      longitud: null,
      fotosProblemaUrls: null,
      fotosSolucionUrls: null,
      fechaEjecucionInicio: null,
      fechaEjecucionFin: null,
      status: 'PENDING_SYNC',
      createdAt: '2026-07-16T00:00:00',
    );

void main() {
  test('una O.S. pendiente de sincronización aparece en Archivadas', () async {
    final repository = _FakeOsRepository(
      orders: const [
        Os(id: 7, numeroOrden: '0000007', estadoOrden: 'EN_PROCESO'),
      ],
      reports: [_pendingReport(7)],
    );
    final viewModel = OsInboxViewModel(
      osRepository: repository,
      authRepository: _FakeAuthRepository(),
      startOsUseCase: _FakeStartOsUseCase(),
      syncPendingReportsUseCase: _FakeSyncPendingReportsUseCase(),
    );

    await Future<void>.delayed(Duration.zero);

    expect(viewModel.osActivas, isEmpty);
    expect(viewModel.osArchivadas, hasLength(1));
    expect(
      viewModel.osArchivadas.single.estadoOrden,
      OsInboxViewModel.pendingSyncStatus,
    );
    expect(viewModel.pendingSyncCount, 1);
    expect(viewModel.pendingSyncOrders.single.numeroOrden, '0000007');

    viewModel.dispose();
    await repository.close();
  });

  test('recupera una referencia local aunque no exista caché de la O.S.',
      () async {
    final repository = _FakeOsRepository(
      orders: const [],
      reports: [_pendingReport(12)],
    );
    final viewModel = OsInboxViewModel(
      osRepository: repository,
      authRepository: _FakeAuthRepository(),
      startOsUseCase: _FakeStartOsUseCase(),
      syncPendingReportsUseCase: _FakeSyncPendingReportsUseCase(),
    );

    await Future<void>.delayed(Duration.zero);

    expect(viewModel.osArchivadas.single.id, 12);
    expect(
      viewModel.osArchivadas.single.estadoOrden,
      OsInboxViewModel.pendingSyncStatus,
    );

    viewModel.dispose();
    await repository.close();
  });

  test('inicia una O.S. localmente cuando el evento queda en cola offline',
      () async {
    const order = Os(
      id: 21,
      numeroOrden: '0000021',
      estadoOrden: 'ASIGNADO',
    );
    final repository = _FakeOsRepository(orders: [order], reports: []);
    final viewModel = OsInboxViewModel(
      osRepository: repository,
      authRepository: _FakeAuthRepository(),
      startOsUseCase: _FakeStartOsUseCase(),
      syncPendingReportsUseCase: _FakeSyncPendingReportsUseCase(),
    );

    await Future<void>.delayed(Duration.zero);
    await viewModel.startOs(order);

    expect(viewModel.osActivas.single.estadoOrden, 'EN_PROCESO');
    expect(
      viewModel.osActivas.single.fechaEjecucionInicio,
      '2026-07-16T15:00:00.000Z',
    );

    viewModel.dispose();
    await repository.close();
  });
}
