import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/use_cases/save_os_report_use_case.dart';
import 'package:hydra/data/services/sync_queue_storage_service.dart';
import 'package:hydra/ui/features/os_execution/view_models/os_execution_view_model.dart';

class _FakeSaveOsReportUseCase implements SaveOsReportUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSyncQueueStorageService implements SyncQueueStorageService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Map<String, dynamic>?> getDraft(int osId) async => null;

  @override
  Future<void> saveDraft({
    required int osId,
    String? insumosUtilizados,
    String? observacionesGasfitero,
    String? rutaCarpetaEvidencias,
    String? trabajoEjecutado,
    String? problemas,
    String? soluciones,
    String? comentariosInstrucciones,
    double? latitud,
    double? longitud,
    String? fotosProblemaUrls,
    String? fotosSolucionUrls,
    String? fechaEjecucionInicio,
    String? fechaEjecucionFin,
    String? pasosConfirmados,
  }) async {}
}

OsExecutionViewModel _createViewModel() => OsExecutionViewModel(
      os: const Os(id: 1),
      saveOsReportUseCase: _FakeSaveOsReportUseCase(),
      syncQueueStorageService: _FakeSyncQueueStorageService(),
    );

void main() {
  test('actualiza correctamente fechaInicio', () async {
    final viewModel = _createViewModel();
    await viewModel.listo;
    final start = DateTime.now().subtract(const Duration(hours: 2));

    viewModel.updateFechaInicio(start);

    expect(viewModel.fechaInicio, start);
    expect(viewModel.errorMsg, isNull);
    viewModel.dispose();
  });

  test('rechaza una finalizacion igual o anterior al inicio', () async {
    final viewModel = _createViewModel();
    await viewModel.listo;
    final start = DateTime.now().subtract(const Duration(hours: 2));
    viewModel.updateFechaInicio(start);

    viewModel.updateFechaFin(start);

    expect(viewModel.errorMsg, contains('anterior al inicio'));
    viewModel.dispose();
  });
}
