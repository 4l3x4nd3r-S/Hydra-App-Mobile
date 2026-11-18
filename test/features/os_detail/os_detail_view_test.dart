import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/domain/models/cuadrilla.dart';
import 'package:hydra/domain/models/gasfitero.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/models/reclamo.dart';
import 'package:hydra/ui/core/theme/app_theme.dart';
import 'package:hydra/ui/features/os_detail/views/os_detail_view.dart';

const _order = Os(
  id: 1,
  numeroOrden: '0000001',
  estadoOrden: 'COMPLETADO',
  reclamo: Reclamo(
    id: 2,
    codigoSolicitud: '00123',
    formato: 'Anexo 6',
    tipoProblema: 'OP-1',
    descripcion: 'Fuga en la conexión',
    direccion: 'Dirección de prueba 123',
    nombreSolicitante: 'Solicitante de prueba',
    telefono: '900000001',
  ),
  cuadrilla: Cuadrilla(
    id: 17,
    codigoGrupo: '017',
    especialidad: 'Alcantarillado',
    lider: Gasfitero(id: 3, nombre: 'Gasfitero principal de prueba'),
  ),
  trabajoEjecutado: 'Trabajo ejecutado registrado',
  fotosProblemaUrls: ['https://example.test/uploads/problema.png'],
  fotosSolucionUrls: [
    'https://example.test/uploads/solucion.png',
    'https://example.test/uploads/firma.png',
  ],
);

Future<void> _pump(
  WidgetTester tester, {
  Os order = _order,
  bool dark = false,
  double textScale = 1,
  Future<void> Function()? onStart,
}) async {
  tester.view.physicalSize = const Size(412, 915);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  // Keep layout tests independent of HTTP, disk caching and native plugins.
  // The production widget still receives the original evidence URLs.
  final image =
      await tester.runAsync(() => createTestImage(width: 4, height: 4));
  for (final url in [...order.fotosProblemaUrls, ...order.fotosSolucionUrls]) {
    PaintingBinding.instance.imageCache.putIfAbsent(
      CachedNetworkImageProvider(url),
      () => OneFrameImageStreamCompleter(
          SynchronousFuture(ImageInfo(image: image!.clone()))),
    );
  }
  image?.dispose();
  addTearDown(() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  });
  await tester.pumpWidget(MaterialApp(
    theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: OsDetailView(
        os: order, isGasfiteroView: true, onRegistrarSolucion: onStart),
  ));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
      'abre con datos del reclamo y asignación plegados y evidencias visibles',
      (tester) async {
    await _pump(tester);
    expect(find.text('Información del reclamo'), findsOneWidget);
    expect(find.text('Cuadrilla y responsables'), findsOneWidget);
    expect(find.text('Solicitante de prueba'), findsNothing);
    expect(find.text('Gasfitero principal de prueba'), findsNothing);
    expect(find.text('FOTOS DEL PROBLEMA'), findsOneWidget);
    expect(find.text('FOTOS DE LA SOLUCIÓN'), findsOneWidget);
    expect(find.text('FIRMA DE CONFORMIDAD DEL USUARIO'), findsOneWidget);
    final images =
        tester.widgetList<CachedNetworkImage>(find.byType(CachedNetworkImage));
    expect(images.map((image) => image.imageUrl), [
      ..._order.fotosProblemaUrls,
      ..._order.fotosSolucionUrls,
    ]);
    final work =
        tester.getTopLeft(find.text('Trabajo ejecutado registrado')).dy;
    expect(tester.getTopLeft(find.text('FOTOS DE LA SOLUCIÓN')).dy,
        lessThan(work));
    expect(tester.getTopLeft(find.text('FIRMA DE CONFORMIDAD DEL USUARIO')).dy,
        lessThan(work));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'permite desplegar y volver a plegar el reclamo con sus datos originales',
      (tester) async {
    await _pump(tester);
    await tester.tap(find.text('Información del reclamo'));
    await tester.pumpAndSettle();
    expect(find.text('00123'), findsOneWidget);
    expect(find.text('Solicitante de prueba'), findsOneWidget);
    expect(find.text('Fuga en la conexión'), findsOneWidget);
    await tester.ensureVisible(find.text('Información del reclamo'));
    await tester.tap(find.text('Información del reclamo'));
    await tester.pumpAndSettle();
    expect(find.text('Solicitante de prueba'), findsNothing);
    expect(find.text('FOTOS DEL PROBLEMA'), findsOneWidget);
  });

  testWidgets('la cuadrilla se consulta por separado y vuelve a plegarse',
      (tester) async {
    await _pump(tester);
    await tester.tap(find.text('Cuadrilla y responsables'));
    await tester.pumpAndSettle();
    expect(find.text('017 · Alcantarillado'), findsOneWidget);
    expect(find.text('Gasfitero principal de prueba'), findsOneWidget);
    expect(find.text('Solicitante de prueba'), findsNothing);
    await tester.tap(find.text('Cuadrilla y responsables'));
    await tester.pumpAndSettle();
    expect(find.text('Gasfitero principal de prueba'), findsNothing);
  });

  testWidgets(
      'las evidencias siguen abriendo la imagen original para ampliarla',
      (tester) async {
    await _pump(tester);
    await tester.tap(find.byType(CachedNetworkImage).first);
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.text('Foto 1'), findsOneWidget);
    expect(
        tester
            .widgetList<CachedNetworkImage>(find.byType(CachedNetworkImage))
            .any((image) => image.imageUrl == _order.fotosProblemaUrls.single),
        isTrue);
    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsNothing);
  });

  testWidgets(
      'mantiene disponible el registro de solución aunque los datos estén plegados',
      (tester) async {
    var started = false;
    await _pump(tester, order: const Os(id: 2, estadoOrden: 'ASIGNADO'),
        onStart: () async {
      started = true;
    });
    expect(find.text('Información del reclamo'), findsOneWidget);
    expect(find.text('FOTOS DEL PROBLEMA'), findsNothing);
    await tester.tap(find.text('REGISTRAR SOLUCION'));
    await tester.pumpAndSettle();
    expect(started, isTrue);
  });

  for (final dark in [false, true]) {
    testWidgets(
        'presenta el resumen con texto ampliado en tema ${dark ? 'oscuro' : 'claro'}',
        (tester) async {
      await _pump(tester, dark: dark, textScale: 1.5);
      tester.view.physicalSize = const Size(320, 740);
      await tester.pumpAndSettle();
      expect(find.text('Información del reclamo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
