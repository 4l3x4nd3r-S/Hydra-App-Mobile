import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/ui/core/theme/app_colors.dart';
import 'package:hydra/ui/core/widgets/profile_modal.dart';

void main() {
  testWidgets('muestra DNI y celular recibidos para el personal',
      (tester) async {
    tester.view.physicalSize = const Size(500, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: const Scaffold(
          body: ProfileModal(
            userName: 'Personal de prueba',
            role: 'Gasfitero',
            dni: '71234567',
            celular: '912345678',
            cuadrilla: '001',
          ),
        ),
      ),
    );

    expect(find.text('DNI'), findsOneWidget);
    expect(find.text('71234567'), findsOneWidget);
    expect(find.text('CELULAR'), findsOneWidget);
    expect(find.text('912345678'), findsOneWidget);
  });
}
