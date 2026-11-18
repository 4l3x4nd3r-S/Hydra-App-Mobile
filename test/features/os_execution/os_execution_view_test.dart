import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hydra/data/services/sync_queue_storage_service.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/use_cases/save_os_report_use_case.dart';
import 'package:hydra/ui/core/theme/app_theme.dart';
import 'package:hydra/ui/features/os_execution/view_models/os_execution_view_model.dart';
import 'package:hydra/ui/features/os_execution/views/os_execution_view.dart';
import 'package:hydra/ui/features/os_execution/widgets/execution_step_card.dart';
import 'package:provider/provider.dart';

class _Storage implements SyncQueueStorageService {
  _Storage(this.draft);
  final Map<String, dynamic>? draft;

  @override
  Future<Map<String, dynamic>?> getDraft(int osId) async => draft;

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

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SaveReport implements SaveOsReportUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _capture = bool.fromEnvironment('CAPTURE_EXECUTION_PREVIEWS');
const _previewKey = ValueKey('execution-preview');

Map<String, dynamic> _draft({
  bool work = false,
  bool closed = false,
  String? confirmed,
}) =>
    {
      'latitud': -12.5964638,
      'longitud': -69.1841279,
      'fotos_problema_urls': '/missing/problem.jpg',
      'fotos_solucion_urls': '/missing/solution.jpg',
      'fecha_ejecucion_inicio': '2026-11-16T08:00:00',
      if (work) 'trabajo_ejecutado': 'Se reemplazó la válvula de cierre.',
      if (closed) 'fecha_ejecucion_fin': '2026-11-16T09:00:00',
      if (confirmed != null) 'pasos_confirmados': confirmed,
    };

Future<void> _pump(
  WidgetTester tester, {
  Map<String, dynamic>? draft,
  Size size = const Size(412, 915),
  bool dark = false,
  double textScale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final theme = dark ? AppTheme.darkTheme : AppTheme.lightTheme;
  await tester.pumpWidget(MultiProvider(
    providers: [
      Provider<SyncQueueStorageService>.value(value: _Storage(draft)),
      Provider<SaveOsReportUseCase>.value(value: _SaveReport()),
    ],
    child: MaterialApp(
      theme: _capture
          ? theme.copyWith(
              textTheme: theme.textTheme.apply(fontFamily: 'Roboto'))
          : theme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: RepaintBoundary(key: _previewKey, child: child!),
      ),
      home: const OsExecutionView(
        os: Os(
            id: 7,
            numeroOrden: '0000007',
            latitud: -12.5964638,
            longitud: -69.1841279,
            fechaEjecucionInicio: '2026-11-16T08:00:00'),
      ),
    ),
  ));
  await tester.pumpAndSettle();
}

OsExecutionViewModel _vm(WidgetTester tester) => tester
    .element(find.byType(ExecutionStepCard).first)
    .read<OsExecutionViewModel>();

Future<void> _preview(WidgetTester tester, String name) async {
  if (!_capture) return;
  final boundary =
      tester.renderObject<RenderRepaintBoundary>(find.byKey(_previewKey));
  await tester.runAsync(() async {
    final picture = await boundary.toImage();
    final bytes = await picture.toByteData(format: ui.ImageByteFormat.png);
    final directory = Directory('build/ui_previews');
    await directory.create(recursive: true);
    await File('${directory.path}/$name.png')
        .writeAsBytes(bytes!.buffer.asUint8List());
    picture.dispose();
  });
}

void main() {
  setUpAll(() async {
    if (!_capture) return;
    final sdkRoot = Platform.environment['FLUTTER_ROOT'];
    if (sdkRoot == null) {
      throw StateError('FLUTTER_ROOT is required for previews.');
    }
    final fonts = '$sdkRoot/bin/cache/artifacts/material_fonts';
    for (final family in ['Roboto', 'Outfit', 'Inter']) {
      final loader = FontLoader(family);
      for (final weight in ['regular', 'bold']) {
        loader.addFont(Future.value(ByteData.sublistView(
            await File('$fonts/roboto-$weight.ttf').readAsBytes())));
      }
      await loader.load();
    }
    final icons = FontLoader('MaterialIcons');
    icons.addFont(Future.value(ByteData.sublistView(
        await File('$fonts/materialicons-regular.otf').readAsBytes())));
    await icons.load();
  });

  testWidgets(
      'muestra el paso pendiente sin error y contrae la ubicación registrada',
      (tester) async {
    await _pump(tester, draft: _draft(confirmed: '0'));
    expect(find.text('Paso 2 de 5 · Fotos del problema'), findsOneWidget);
    expect(find.text('1 de 5 pasos completados'), findsOneWidget);
    // El borrador trae una foto pero nadie la confirmó: el paso queda abierto
    // y pide la confirmación del técnico. Los pasos todavía bloqueados no
    // piden nada.
    expect(find.text('Por confirmar'), findsOneWidget);
    expect(find.byType(FlutterMap), findsNothing);
    expect(find.text('Finalizar tarea'), findsNothing);
    expect(
        tester
            .widgetList<ExecutionStepCard>(find.byType(ExecutionStepCard))
            .any((card) => card.hasError),
        isFalse);
    expect(tester.takeException(), isNull);
    await _preview(tester, 'execution-phone-light');
  });

  testWidgets(
      'restaura un registro completo y permite revisar el cierre y la firma opcional',
      (tester) async {
    await _pump(tester,
        draft: _draft(work: true, closed: true, confirmed: '0,1,2,3'));
    expect(find.text('5 de 5 pasos completados'), findsOneWidget);
    expect(find.text('Finalizar tarea'), findsOneWidget);
    expect(find.byType(FlutterMap), findsNothing);
    await tester.ensureVisible(find.text('Cierre y conformidad'));
    await tester.tap(find.text('Cierre y conformidad'));
    await tester.pumpAndSettle();
    expect(find.text('Firma de conformidad (opcional)'), findsOneWidget);
    expect(find.text('Registrar firma de conformidad'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'la acción de continuar lleva al paso pendiente sin marcarlo como error',
      (tester) async {
    await _pump(tester, draft: _draft(confirmed: '0'));
    await tester.ensureVisible(find.text('Ir al paso 2'));
    await tester.tap(find.text('Ir al paso 2'));
    await tester.pumpAndSettle();
    final current = find.byType(ExecutionStepCard).at(1);
    expect(tester.getRect(current).overlaps(Offset.zero & const Size(412, 915)),
        isTrue);
    expect(_vm(tester).showValidationErrors, isFalse);
    expect(_vm(tester).pasoPendiente, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'al retirar la evidencia vuelve al paso pendiente sin ocultar el trabajo registrado',
      (tester) async {
    await _pump(tester, draft: _draft(work: true, confirmed: '0,1,2,3'));
    await tester.ensureVisible(find.text('Fotos del problema'));
    await tester.tap(find.text('Fotos del problema'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.bySemanticsLabel('Quitar foto 1'));
    await tester.tap(find.bySemanticsLabel('Quitar foto 1'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 2 de 5 · Fotos del problema'), findsOneWidget);
    expect(_vm(tester).trabajoEjecutadoController.text,
        'Se reemplazó la válvula de cierre.');
    expect(_vm(tester).mostrarCierre, isTrue);
    expect(find.text('Finalizar tarea'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'escribir el trabajo no desplaza el campo ni pierde el foco y el cierre '
      'aparece recién al confirmarlo', (tester) async {
    await _pump(tester, draft: _draft(confirmed: '0,1,2'));
    final field = find.byType(TextField).first;
    await tester.ensureVisible(field);
    await tester.enterText(field, 'Se reemplazó la válvula.');
    await tester.pumpAndSettle();
    final editable =
        tester.widget<EditableText>(find.byType(EditableText).first);
    expect(editable.focusNode.hasFocus, isTrue);
    // Escribir no revela el cierre: hace falta la confirmación del técnico.
    expect(_vm(tester).mostrarCierre, isFalse);
    expect(tester.getRect(field).overlaps(Offset.zero & const Size(412, 915)),
        isTrue);
    // Regresión: el bloque NO se pliega al tener datos; tiene que seguir
    // abierto con su botón para que el técnico confirme.
    expect(find.text('Confirmar trabajo ejecutado'), findsOneWidget);
    expect(find.text('Por confirmar'), findsOneWidget);
    await _preview(tester, 'execution-por-confirmar');

    await tester.ensureVisible(find.text('Confirmar trabajo ejecutado'));
    await tester.tap(find.text('Confirmar trabajo ejecutado'));
    await tester.pumpAndSettle();
    expect(_vm(tester).mostrarCierre, isTrue);
    // Recién al confirmar se pliega el bloque y aparece el siguiente.
    expect(find.text('Confirmar trabajo ejecutado'), findsNothing);
    expect(find.text('Confirmado'), findsWidgets);

    expect(tester.takeException(), isNull);
  });

  for (final dark in [false, true]) {
    testWidgets(
        'adapta los controles a 320 px con texto ampliado en tema ${dark ? 'oscuro' : 'claro'}',
        (tester) async {
      await _pump(tester,
          draft: _draft(work: true, confirmed: '0,1,2,3'),
          size: const Size(320, 740),
          textScale: 1.5,
          dark: dark);
      await tester.ensureVisible(find.text('Cierre y conformidad'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await _preview(tester, 'execution-small-${dark ? 'dark' : 'light'}');
    });
  }

  testWidgets(
      'la hoja de firma deja los botones por encima de la barra del sistema',
      (tester) async {
    // Tablets con taskbar / navegación de Android en modo borde a borde.
    const screen = Size(820, 1180);
    tester.view.padding = const FakeViewPadding(bottom: 48);
    addTearDown(tester.view.resetPadding);

    await _pump(tester,
        draft: _draft(work: true, closed: true, confirmed: '0,1,2,3'),
        size: screen);

    await tester.ensureVisible(find.text('Cierre y conformidad'));
    await tester.tap(find.text('Cierre y conformidad'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Registrar firma de conformidad'));
    await tester.tap(find.text('Registrar firma de conformidad'));
    await tester.pumpAndSettle();

    final guardar =
        tester.getRect(find.widgetWithText(ElevatedButton, 'Guardar Firma'));
    final limpiar = tester.getRect(find.widgetWithText(TextButton, 'Limpiar'));

    // Ninguno queda debajo del área reservada por la barra del sistema.
    expect(guardar.bottom, lessThanOrEqualTo(screen.height - 48));
    expect(limpiar.bottom, lessThanOrEqualTo(screen.height - 48));
    expect(tester.takeException(), isNull);

    await _preview(tester, 'execution-firma-tablet');
  });

  testWidgets('presenta el formulario centrado en una tableta', (tester) async {
    await _pump(tester, size: const Size(820, 1180));
    expect(tester.getSize(find.byType(ExecutionStepCard).first).width,
        lessThanOrEqualTo(760));
    expect(tester.takeException(), isNull);
    await _preview(tester, 'execution-tablet-light');
  });
}
