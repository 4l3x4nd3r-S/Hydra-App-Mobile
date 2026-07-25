import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/ui/core/theme/app_colors.dart';
import 'package:hydra/ui/features/supervisor/widgets/reclamo_list_tile.dart';
import 'package:hydra/ui/features/supervisor/widgets/reclamo_tile_data.dart';

void main() {
  Widget construirTarjeta({
    String? codigoSolicitud,
    String? tipoProblema,
    String? tipoProblemaDescripcion,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ReclamoListTile(
          c: AppColors.light,
          data: ReclamoTileData(
            id: 2026,
            codigoSolicitud: codigoSolicitud,
            tipoProblema: tipoProblema,
            tipoProblemaDescripcion: tipoProblemaDescripcion,
          ),
        ),
      ),
    );
  }

  testWidgets('muestra el código de solicitud registrado', (tester) async {
    await tester.pumpWidget(construirTarjeta(codigoSolicitud: '43787'));

    expect(find.text('Solicitud N° 43787'), findsOneWidget);
    expect(find.textContaining('REC-'), findsNothing);
  });

  testWidgets('no reemplaza un código ausente por el ID del reclamo',
      (tester) async {
    await tester.pumpWidget(construirTarjeta());

    expect(find.text('Solicitud N° -----'), findsOneWidget);
    expect(find.text('Solicitud N° 2026'), findsNothing);
  });

  testWidgets('muestra el significado del tipo de problema', (tester) async {
    await tester.pumpWidget(
      construirTarjeta(
        tipoProblema: 'OP-1',
        tipoProblemaDescripcion: 'Obras inconclusas',
      ),
    );

    expect(find.text('OP-1 · Obras inconclusas'), findsOneWidget);
  });
}
