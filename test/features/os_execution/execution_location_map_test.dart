import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/data/services/app_environment.dart';
import 'package:hydra/ui/core/theme/app_theme.dart';
import 'package:hydra/ui/features/os_execution/widgets/execution_location_map.dart';
import 'package:latlong2/latlong.dart';

class _TestTiles extends TileProvider {
  final _pixel = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGNgYGBgAAAABQABpfZFQAAAAABJRU5ErkJggg==');

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) =>
      MemoryImage(_pixel);
}

const _location = LatLng(-12.5964638, -69.1841279);

Future<void> _pump(
  WidgetTester tester, {
  double width = 360,
  LatLng location = _location,
  bool dark = false,
  double textScale = 1,
}) async {
  tester.view.physicalSize = Size(width, 900);
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
        body: Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
          width: width,
          child: ExecutionLocationMap(
              location: location, tileProvider: _TestTiles())),
    )),
  ));
  await tester.pumpAndSettle();
}

MapController _controller(WidgetTester tester) =>
    tester.widget<FlutterMap>(find.byType(FlutterMap)).mapController!;

void main() {
  testWidgets('amplía el área del mapa conservando el zoom y las coordenadas',
      (tester) async {
    await _pump(tester);
    expect(tester.getSize(find.byType(FlutterMap)).height, 300);
    expect(_controller(tester).camera.zoom, 16);
    expect(_controller(tester).camera.center, _location);
    expect(
        tester
            .widget<MarkerLayer>(find.byType(MarkerLayer))
            .markers
            .single
            .alignment,
        Alignment.topCenter);
    expect(
        tester
            .widget<MarkerLayer>(find.byType(MarkerLayer))
            .markers
            .single
            .point,
        _location);
    expect(tester.takeException(), isNull);
  });

  testWidgets('la altura se adapta a la tableta sin aumentar el zoom',
      (tester) async {
    await _pump(tester, width: 760);
    expect(tester.getSize(find.byType(FlutterMap)).height, 420);
    expect(_controller(tester).camera.zoom, 16);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'centrar vuelve al registro GPS sin cambiar el zoom ni el marcador',
      (tester) async {
    await _pump(tester);
    final controller = _controller(tester);
    controller.move(const LatLng(-12.59, -69.18), 17);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Centrar en la ubicación registrada'));
    await tester.pumpAndSettle();
    expect(controller.camera.center, _location);
    expect(controller.camera.zoom, 17);
    expect(
        tester
            .widget<MarkerLayer>(find.byType(MarkerLayer))
            .markers
            .single
            .point,
        _location);
  });

  testWidgets(
      'pantalla completa conserva el encuadre y permite regresar al formulario',
      (tester) async {
    await _pump(tester);
    final center = const LatLng(-12.59, -69.18);
    _controller(tester).move(center, 15.5);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Ampliar mapa'));
    await tester.pumpAndSettle();
    expect(find.text('Ubicación del trabajo'), findsOneWidget);
    expect(_controller(tester).camera.center, center);
    expect(_controller(tester).camera.zoom, 15.5);
    expect(tester.getSize(find.byType(FlutterMap)).height, greaterThan(700));
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byTooltip('Ampliar mapa'), findsOneWidget);
    expect(_controller(tester).camera.zoom, 15.5);
    expect(tester.takeException(), isNull);
  });

  testWidgets('actualizar el GPS mueve el marcador a las coordenadas nuevas',
      (tester) async {
    await _pump(tester);
    _controller(tester).move(_location, 17);
    const updated = LatLng(-12.595, -69.183);
    await _pump(tester, location: updated);
    expect(_controller(tester).camera.center, updated);
    expect(_controller(tester).camera.zoom, 17);
    expect(
        tester
            .widget<MarkerLayer>(find.byType(MarkerLayer))
            .markers
            .single
            .point,
        updated);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'alta densidad usa imágenes nítidas del servidor sin simular otro zoom',
      (tester) async {
    await _pump(tester);
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(720, 1800);
    await tester.pumpAndSettle();
    final tiles = tester.widget<TileLayer>(find.byType(TileLayer));
    expect(tiles.urlTemplate, AppEnvironment.locationMapTileUrl);
    if (AppEnvironment.locationMapTileUrl.contains('{r}')) {
      expect(tiles.resolvedRetinaMode, RetinaMode.server);
    } else {
      expect(tiles.resolvedRetinaMode, RetinaMode.disabled);
    }
    expect(_controller(tester).camera.zoom, 16);
  });

  testWidgets('el mapa y sus controles caben en modo oscuro con texto ampliado',
      (tester) async {
    await _pump(tester, width: 320, dark: true, textScale: 1.5);
    expect(find.byTooltip('Ampliar mapa'), findsOneWidget);
    expect(find.text('© OpenStreetMap contributors, © CARTO'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
