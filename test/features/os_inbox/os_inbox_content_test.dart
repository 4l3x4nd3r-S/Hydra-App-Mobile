import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/models/reclamo.dart';
import 'package:hydra/domain/models/cuadrilla.dart';
import 'package:hydra/domain/models/gasfitero.dart';
import 'package:hydra/ui/core/theme/app_colors.dart';
import 'package:hydra/ui/core/theme/app_theme.dart';
import 'package:hydra/ui/features/os_inbox/widgets/os_inbox_content.dart';

void main() {
  const activeOrder = Os(
    id: 2,
    numeroOrden: '0000002',
    estadoOrden: 'EN_PROCESO',
    fechaProgramacion: '2026-08-13T00:10:00',
    reclamo: Reclamo(
        id: 1,
        tipoProblema: 'OP-1',
        descripcion: 'Fuga de agua',
        direccion: 'Las Orquídeas 123'),
    cuadrilla: Cuadrilla(
        id: 17,
        codigoGrupo: '017',
        lider: Gasfitero(id: 9, nombre: 'Mario Osorio')),
  );

  Future<void> pumpInbox(
    WidgetTester tester, {
    bool showOperationalDetails = false,
    bool dark = false,
    double textScale = 1,
    void Function(Os)? onTap,
  }) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: Scaffold(
          body: OsInboxContent(
        osActivas: const [activeOrder],
        osArchivadas: [
          activeOrder.copyWith(
              id: 3, numeroOrden: '0000003', estadoOrden: 'COMPLETADO')
        ],
        showOperationalDetails: showOperationalDetails,
        onTapActiva: onTap,
        onTapArchivada: onTap,
      )),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets(
      'el resumen del gasfitero conserva los datos recibidos y oculta cuadrilla y tipo',
      (tester) async {
    Os? selected;
    await pumpInbox(tester, onTap: (os) => selected = os);
    expect(find.text('N.º 0000002'), findsOneWidget);
    expect(find.text('EN PROCESO'), findsOneWidget);
    expect(find.text('EN_PROCESO'), findsNothing);
    expect(find.text('Fuga de agua'), findsOneWidget);
    expect(find.text('Las Orquídeas 123'), findsOneWidget);
    expect(find.text('13/08/2026 · 12:10 AM'), findsOneWidget);
    expect(find.textContaining('Mario'), findsNothing);
    expect(find.textContaining('OP-1'), findsNothing);
    await tester.tap(find.text('Fuga de agua'));
    expect(selected, same(activeOrder));
    expect(selected?.estadoOrden, 'EN_PROCESO');
    expect(selected?.reclamo?.tipoProblema, 'OP-1');
    expect(selected?.cuadrilla?.id, 17);
  });

  testWidgets(
      'la lista archivada utiliza el mismo resumen y permite abrir la orden',
      (tester) async {
    Os? selected;
    await pumpInbox(tester, onTap: (os) => selected = os);
    await tester.tap(find.text('ARCHIVADAS'));
    await tester.pumpAndSettle();
    expect(find.text('N.º 0000003'), findsOneWidget);
    expect(find.text('COMPLETADO'), findsOneWidget);
    expect(find.textContaining('Mario'), findsNothing);
    expect(find.textContaining('OP-1'), findsNothing);
    await tester.tap(find.text('Fuga de agua'));
    expect(selected?.id, 3);
  });

  testWidgets('el supervisor conserva la asignación y el tipo de problema',
      (tester) async {
    await pumpInbox(tester, showOperationalDetails: true);
    expect(find.textContaining('Mario'), findsOneWidget);
    expect(find.textContaining('OP-1'), findsOneWidget);
    expect(find.text('EN PROCESO'), findsOneWidget);
  });

  for (final dark in [false, true]) {
    testWidgets(
        'la tarjeta se adapta a texto ampliado en tema ${dark ? 'oscuro' : 'claro'}',
        (tester) async {
      await pumpInbox(tester, dark: dark, textScale: 1.5);
      expect(find.text('EN PROCESO'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('al tocar el aviso muestra las O.S. guardadas localmente',
      (tester) async {
    const pendingOrder = Os(
      id: 8,
      numeroOrden: '0000008',
      estadoOrden: 'PENDIENTE DE SINCRONIZAR',
      reclamo: Reclamo(
        id: 3,
        descripcion: 'Reparación guardada sin conexión',
        direccion: 'Av. Principal 123',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [AppColors.dark]),
        home: const Scaffold(
          body: OsInboxContent(
            osActivas: [],
            osArchivadas: [pendingOrder],
            pendingSyncCount: 1,
            pendingSyncOrders: [pendingOrder],
          ),
        ),
      ),
    );

    await tester.tap(find.text('1 O.S. guardada en este dispositivo'));
    await tester.pumpAndSettle();

    expect(find.text('O.S. guardadas sin conexión'), findsOneWidget);
    expect(find.text('O.S. N° 0000008'), findsOneWidget);
    expect(find.text('Reparación guardada sin conexión'), findsOneWidget);

    await tester.tap(find.byTooltip('Cerrar'));
    await tester.pumpAndSettle();

    expect(find.text('O.S. guardadas sin conexión'), findsNothing);
  });
}
