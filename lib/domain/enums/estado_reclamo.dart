enum EstadoReclamo {
  pendiente('PENDIENTE'),
  asignado('ASIGNADO'),
  enProceso('EN PROCESO'),
  atendido('ATENDIDO');

  const EstadoReclamo(this.label);
  final String label;
}
