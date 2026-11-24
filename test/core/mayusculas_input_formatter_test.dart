import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/core/utils/mayusculas_input_formatter.dart';

void main() {
  test('convierte a mayúsculas conservando el cursor', () {
    const formatter = MayusculasInputFormatter();
    final resultado = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(
        text: 'raul',
        selection: TextSelection.collapsed(offset: 4),
      ),
    );
    expect(resultado.text, 'RAUL');
    expect(resultado.selection.baseOffset, 4);
  });

  testWidgets('el campo muestra en mayúsculas lo escrito en minúsculas',
      (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TextField(
          controller: controller,
          inputFormatters: const [MayusculasInputFormatter()],
        ),
      ),
    ));
    await tester.enterText(find.byType(TextField), 'juanpablo');
    expect(controller.text, 'JUANPABLO');
  });
}
