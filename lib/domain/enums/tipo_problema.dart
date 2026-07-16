enum TipoProblema {
  op1('OP-1', 'Obras inconclusas'),
  op2('OP-2', 'Fugas en la red de agua potable e inundaciones'),
  op3('OP-3', 'Desbordes en la red de alcantarillado'),
  op4('OP-4', 'Atoro en conexión de alcantarillado e inundaciones'),
  op5('OP-5', 'Cortes del servicio'),
  op6('OP-6', 'Falta de accesorios de seguridad'),
  op7('OP-7', 'Seguridad: emanaciones del sistema de alcantarillado');

  const TipoProblema(this.label, this.resumen);
  final String label;
  final String resumen;

  static String etiquetaDescriptiva(String? codigo) {
    final value = codigo?.trim() ?? '';
    if (value.isEmpty) return '';

    final normalized = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    for (final tipo in values) {
      final candidate =
          tipo.label.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
      if (candidate == normalized) {
        return '${tipo.label} · ${tipo.resumen}';
      }
    }
    return value;
  }
}
