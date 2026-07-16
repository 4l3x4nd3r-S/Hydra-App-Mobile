import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/use_cases/save_os_report_use_case.dart';
import 'package:hydra/ui/features/os_execution/view_models/os_execution_view_model.dart';

class _FakeSaveOsReportUseCase implements SaveOsReportUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

OsExecutionViewModel _createViewModel() => OsExecutionViewModel(
      os: const Os(id: 1),
      saveOsReportUseCase: _FakeSaveOsReportUseCase(),
    );

void main() {
  test('rechaza una fecha de inicio pasada', () {
    final viewModel = _createViewModel();

    final accepted = viewModel.updateFechaInicio(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    expect(accepted, isFalse);
    expect(viewModel.fechaInicio, isNull);
    expect(viewModel.errorMsg, contains('no pueden estar en el pasado'));
    viewModel.dispose();
  });

  test('al cambiar el inicio mantiene la finalización posterior', () {
    final viewModel = _createViewModel();
    final start = DateTime.now().add(const Duration(hours: 2));

    final accepted = viewModel.updateFechaInicio(start);

    expect(accepted, isTrue);
    expect(viewModel.fechaInicio, start);
    expect(viewModel.fechaFin, start.add(const Duration(minutes: 1)));
    viewModel.dispose();
  });

  test('rechaza una finalización igual o anterior al inicio', () {
    final viewModel = _createViewModel();
    final start = DateTime.now().add(const Duration(hours: 2));
    viewModel.updateFechaInicio(start);

    final accepted = viewModel.updateFechaFin(start);

    expect(accepted, isFalse);
    expect(viewModel.errorMsg, contains('debe ser posterior'));
    viewModel.dispose();
  });
}
