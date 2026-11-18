import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/core/utils/os_excel_exporter.dart';
import 'package:hydra/ui/core/theme/app_theme.dart';
import 'package:hydra/ui/features/supervisor/view_models/supervisor_os_view_model.dart';
import 'package:hydra/ui/features/supervisor/widgets/supervisor_os_content.dart';
import 'package:provider/provider.dart';

import '../../helpers/os_export_fixtures.dart';

class _ExportViewModel extends SupervisorOsViewModel {
  _ExportViewModel(ExportOsRepository local)
      : super(
            osRepository: local,
            supervisorRepository: ExportSupervisorRepository());

  int exportCalls = 0;
  Completer<OsExcelExport?>? pending;

  @override
  Future<OsExcelExport?> exportCompletedOrders() async {
    exportCalls++;
    if (pending != null) return pending!.future;
    return OsExcelExport(
        bytes: Uint8List.fromList([1, 2, 3]),
        fileName: 'ordenes.xlsx',
        orderCount: 1);
  }
}

Future<void> _pump(WidgetTester tester, _ExportViewModel vm,
    Future<void> Function(OsExcelExport, Rect) share,
    {double textScale = 1}) async {
  tester.view.physicalSize = const Size(320, 740);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(ChangeNotifierProvider<SupervisorOsViewModel>.value(
    value: vm,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: Scaffold(
          body: SupervisorOsContent(onOpenOrder: (_) {}, onShareExport: share)),
    ),
  ));
  await tester.pumpAndSettle();
}

void main() {
  late ExportOsRepository local;
  late _ExportViewModel vm;
  setUp(() async {
    local = ExportOsRepository();
    vm = _ExportViewModel(local);
    await vm.cargarTodo();
  });
  tearDown(() async {
    vm.dispose();
    await local.changes.close();
  });

  testWidgets(
      'el botón entrega el Excel al diálogo de compartir con un anclaje válido',
      (tester) async {
    OsExcelExport? shared;
    Rect? anchor;
    await _pump(tester, vm, (report, origin) async {
      shared = report;
      anchor = origin;
    });
    await tester.tap(find.text('Exportar Excel'));
    await tester.pumpAndSettle();
    expect(shared?.fileName, 'ordenes.xlsx');
    expect(anchor?.isEmpty, isFalse);
    expect(vm.exportCalls, 1);
    expect(find.text('Exportar Excel'), findsOneWidget);
  });

  testWidgets('bloquea doble pulsación hasta que termine de compartir',
      (tester) async {
    final sharing = Completer<void>();
    await _pump(tester, vm, (_, __) => sharing.future);
    await tester.tap(find.text('Exportar Excel'));
    await tester.pump();
    final button =
        tester.widget<OutlinedButton>(find.byType(OutlinedButton).first);
    expect(button.onPressed, isNull);
    expect(vm.exportCalls, 1);
    sharing.complete();
    await tester.pumpAndSettle();
    expect(find.text('Exportar Excel'), findsOneWidget);
  });

  testWidgets('permite reintentar cuando falla el diálogo de compartir',
      (tester) async {
    await _pump(tester, vm, (_, __) async => throw StateError('No disponible'));
    await tester.tap(find.text('Exportar Excel'));
    await tester.pumpAndSettle();
    expect(find.text('No se pudo compartir el Excel. Intente nuevamente.'),
        findsOneWidget);
    expect(
        tester
            .widget<OutlinedButton>(find.byType(OutlinedButton).first)
            .onPressed,
        isNotNull);
  });

  testWidgets('no abre el diálogo si el usuario sale durante la exportación',
      (tester) async {
    var shares = 0;
    final response = Completer<OsExcelExport?>();
    vm.pending = response;
    await _pump(tester, vm, (_, __) async {
      shares++;
    });
    await tester.tap(find.text('Exportar Excel'));
    await tester.pump();
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    response.complete(OsExcelExport(
        bytes: Uint8List(0), fileName: 'ordenes.xlsx', orderCount: 1));
    await tester.pumpAndSettle();
    expect(shares, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'la cabecera se adapta a una pantalla estrecha con texto ampliado',
      (tester) async {
    // Leave the inbox empty so this check covers the new export header.
    await _pump(tester, vm, (_, __) async {}, textScale: 1.5);
    expect(find.text('Exportar Excel'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
