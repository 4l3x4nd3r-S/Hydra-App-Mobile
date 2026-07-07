import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hydra/domain/models/reclamo.dart';
import 'package:hydra/domain/models/cuadrilla.dart';
import 'package:hydra/domain/use_cases/create_os_from_reclamo_use_case.dart';
import 'package:hydra/ui/core/theme/app_colors.dart';
import 'package:hydra/ui/features/supervisor/views/reclamo_detalle_view.dart';
import 'package:hydra/ui/features/supervisor/view_models/reclamo_detalle_view_model.dart';

import 'reclamo_detalle_view_model_test.dart';

class TestAppColors extends AppColors {
  TestAppColors()
      : super(
          primary: const Color(0xFF0A2472),
          background: const Color(0xFFF5F7FA),
          surface: Colors.white,
          onSurface: const Color(0xFF1A1A1A),
          onSurfaceVariant: const Color(0xFF6B7280),
          border: const Color(0xFFE5E7EB),
        );
}

void main() {
  final testReclamo = Reclamo(
    id: 1,
    formato: 'F-001',
    codigoSolicitud: 'CS-001',
    estado: 'PENDIENTE',
    descripcion: 'Fuga visible en tuberia principal',
    direccion: 'Av. Peru 123',
    nombreSolicitante: 'Juan Perez',
    telefono: '987654321',
    email: 'juan@example.com',
    numeroMedidor: 'M-001',
    canalEntrada: 'TELEFONO',
    tipoProblema: 'FUGA',
    fechaRegistro: '2026-07-01T10:00:00',
  );

  final testCuadrillas = [
    Cuadrilla(id: 1, codigoGrupo: 'Grupo #1'),
    Cuadrilla(id: 2, codigoGrupo: 'Grupo #2'),
  ];

  Widget createTestWidget({
    required FakeCreateOsFromReclamoUseCase fakeUseCase,
    required ReclamoDetalleViewModel vm,
  }) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [TestAppColors()],
      ),
      home: MultiProvider(
        providers: [
          Provider<CreateOsFromReclamoUseCase>.value(value: fakeUseCase),
          ChangeNotifierProvider<ReclamoDetalleViewModel>.value(value: vm),
        ],
        child: ReclamoDetalleView(
          reclamo: testReclamo,
          cuadrillas: testCuadrillas,
        ),
      ),
    );
  }

  group('ReclamoDetalleView', () {
    testWidgets('muestra el boton para asignar cuadrilla', (tester) async {
      final fakeUseCase = FakeCreateOsFromReclamoUseCase();
      final vm = ReclamoDetalleViewModel(
        reclamo: testReclamo,
        createOsUseCase: fakeUseCase,
      );
      await tester.pumpWidget(createTestWidget(
        fakeUseCase: fakeUseCase,
        vm: vm,
      ));

      expect(find.text('ASIGNAR A UNA CUADRILLA'), findsOneWidget);
      expect(find.text('Reclamo #1'), findsOneWidget);
      expect(find.text('Fuga visible en tuberia principal'), findsOneWidget);
    });

    testWidgets('al presionar ASIGNAR abre modal con cuadrillas y boton',
        (tester) async {
      final fakeUseCase = FakeCreateOsFromReclamoUseCase();
      final vm = ReclamoDetalleViewModel(
        reclamo: testReclamo,
        createOsUseCase: fakeUseCase,
      );
      await tester.pumpWidget(createTestWidget(
        fakeUseCase: fakeUseCase,
        vm: vm,
      ));

      await tester.scrollUntilVisible(
        find.text('ASIGNAR A UNA CUADRILLA'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('ASIGNAR A UNA CUADRILLA'));
      await tester.pumpAndSettle();

      expect(find.text('Seleccionar Cuadrilla'), findsOneWidget);
      expect(find.text('Grupo #1'), findsOneWidget);
      expect(find.text('Grupo #2'), findsOneWidget);
      expect(find.text('CONFIRMAR Y CREAR O.S.'), findsOneWidget);
    });

    testWidgets('boton CONFIRMAR deshabilitado si no se selecciona cuadrilla',
        (tester) async {
      final fakeUseCase = FakeCreateOsFromReclamoUseCase();
      final vm = ReclamoDetalleViewModel(
        reclamo: testReclamo,
        createOsUseCase: fakeUseCase,
      );
      await tester.pumpWidget(createTestWidget(
        fakeUseCase: fakeUseCase,
        vm: vm,
      ));

      await tester.scrollUntilVisible(
        find.text('ASIGNAR A UNA CUADRILLA'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('ASIGNAR A UNA CUADRILLA'));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'CONFIRMAR Y CREAR O.S.'),
      );
      expect(button.onPressed, isNull);
    });
  });
}
