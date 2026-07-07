enum EstadoOrden {
  activa,
  completadaLocal,
  archivada;

  String get label => switch (this) {
        EstadoOrden.activa => 'Activa',
        EstadoOrden.completadaLocal => 'Completada (local)',
        EstadoOrden.archivada => 'Archivada',
      };

  static EstadoOrden? fromBackendString(String? estado) {
    switch (estado?.toUpperCase()) {
      case 'EN_PROCESO':
      case 'ASIGNADO':
      case 'PENDIENTE':
        return EstadoOrden.activa;
      case 'COMPLETADO':
        return EstadoOrden.completadaLocal;
      case 'ARCHIVADO':
        return EstadoOrden.archivada;
      default:
        return null;
    }
  }
}
