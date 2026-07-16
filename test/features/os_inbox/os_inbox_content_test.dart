import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/models/reclamo.dart';
import 'package:hydra/ui/core/theme/app_colors.dart';
import 'package:hydra/ui/features/os_inbox/widgets/os_inbox_content.dart';

void main() {
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
