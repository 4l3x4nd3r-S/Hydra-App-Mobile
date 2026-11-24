/// Fechas que llegan del backend de Hydra.
///
/// El backend guarda y envía todas las fechas en **hora de Perú (UTC-5)** sin
/// zona horaria (por ejemplo `2026-11-24T08:00:12`). Si se parsearan tal cual,
/// `DateTime.tryParse` usaría la zona del dispositivo; aquí se fija la de Perú
/// para que la hora sea la misma en cualquier equipo.
///
/// Los valores con zona explícita (`...Z`, `...-05:00`), como los que guarda
/// la propia app en sus borradores, se respetan.
library;

final RegExp _conZona = RegExp(r'(?:[zZ]|[+-]\d{2}:?\d{2})$');

const String offsetPeru = '-05:00';

/// Convierte una fecha del servidor (o de un borrador local) a hora local
/// del dispositivo. Devuelve `null` si no hay valor o no es válido.
DateTime? parseFechaServidor(Object? raw) {
  if (raw is! String) return null;
  final valor = raw.trim();
  if (valor.isEmpty) return null;
  final conZona = _conZona.hasMatch(valor) ? valor : '$valor$offsetPeru';
  return DateTime.tryParse(conZona)?.toLocal();
}
