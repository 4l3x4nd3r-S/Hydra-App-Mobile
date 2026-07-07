enum CanalEntrada {
  presencial('Presencial (Módulo Comercial)'),
  callCenter('Call Center (3er Piso)'),
  llamadaDirecta('Llamada Directa');

  const CanalEntrada(this.label);
  final String label;
}
