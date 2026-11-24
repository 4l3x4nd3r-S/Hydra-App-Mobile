import 'package:flutter/services.dart';

/// Convierte a mayúsculas todo lo que se escribe en el campo, conservando la
/// posición del cursor y la selección (se usa en el código de empleado).
class MayusculasInputFormatter extends TextInputFormatter {
  const MayusculasInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final mayusculas = newValue.text.toUpperCase();
    if (mayusculas == newValue.text) return newValue;
    return newValue.copyWith(text: mayusculas);
  }
}
