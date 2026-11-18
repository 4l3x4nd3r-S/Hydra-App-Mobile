import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/status_chip.dart';

class OsListTileData {
  final int id;
  final String? numeroOrden;
  final String? fechaProgramacion;
  final String? tipoProblema;
  final String? descripcion;
  final String? direccion;
  final String? asignadoA;
  final String? estado;
  final bool isReadOnly;
  final VoidCallback? onTap;

  const OsListTileData({
    required this.id,
    this.numeroOrden,
    this.fechaProgramacion,
    this.tipoProblema,
    this.descripcion,
    this.direccion,
    this.asignadoA,
    this.estado,
    this.isReadOnly = false,
    this.onTap,
  });
}

class OsListTile extends StatelessWidget {
  final OsListTileData data;
  final AppColors c;
  final bool showOperationalDetails;

  const OsListTile({
    super.key,
    required this.data,
    required this.c,
    this.showOperationalDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    final orderNumber = data.numeroOrden?.trim();
    final description = data.descripcion?.trim();
    final address = data.direccion?.trim();
    final assignment = data.asignadoA?.trim();
    final problem = data.tipoProblema?.trim();

    return Card(
      color: c.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: c.border.withValues(alpha: 0.55)),
      ),
      child: InkWell(
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    orderNumber != null && orderNumber.isNotEmpty
                        ? 'N.º $orderNumber'
                        : 'Orden de servicio',
                    style: TextStyle(
                      color: c.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (data.estado?.trim().isNotEmpty ?? false)
                    Hero(
                      tag: 'os_status_${data.id}',
                      child: StatusChip(status: data.estado!),
                    ),
                ],
              ),
              if (showOperationalDetails &&
                  assignment != null &&
                  assignment.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.engineering_outlined,
                        size: 16, color: c.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Text(assignment,
                            style: TextStyle(
                              color: c.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ))),
                  ],
                ),
              ],
              if (description != null && description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                      color: c.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      height: 1.35),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 18, color: c.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(
                    address != null && address.isNotEmpty
                        ? address
                        : 'Sin dirección',
                    style: TextStyle(
                        color: c.onSurfaceVariant, fontSize: 14, height: 1.35),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
              if (showOperationalDetails &&
                  problem != null &&
                  problem.isNotEmpty) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getTipoProblemaLabel(problem).toUpperCase(),
                      style: TextStyle(
                          color: c.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 16, color: c.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(
                    _formatFecha(data.fechaProgramacion),
                    style: TextStyle(
                        color: c.onSurfaceVariant, fontSize: 13, height: 1.35),
                  )),
                  if (data.onTap != null) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.chevron_right_rounded,
                        size: 20, color: c.onSurfaceVariant),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFecha(String? fechaRaw) {
    if (fechaRaw == null || fechaRaw.trim().isEmpty)
      return 'Sin fecha programada';
    try {
      final date = DateTime.parse(fechaRaw).toLocal();
      final dia = date.day.toString().padLeft(2, '0');
      final mes = date.month.toString().padLeft(2, '0');
      final anio = date.year.toString();

      int hora = date.hour;
      final minuto = date.minute.toString().padLeft(2, '0');
      final ampm = hora >= 12 ? 'PM' : 'AM';

      if (hora == 0) {
        hora = 12;
      } else if (hora > 12) {
        hora -= 12;
      }
      final horaStr = hora.toString().padLeft(2, '0');

      return '$dia/$mes/$anio · $horaStr:$minuto $ampm';
    } catch (e) {
      // In case it's not ISO format and already somewhat formatted
      return fechaRaw;
    }
  }

  String _getTipoProblemaLabel(String? code) {
    if (code == null || code.isEmpty) return '';
    final map = {
      // OP (Anexo 6)
      'OP-1': 'Obras inconclusas (vereda o calzada pendiente)',
      'OP-2': 'Fugas en red de agua potable e inundaciones',
      'OP-3': 'Desbordes en la red de alcantarillado',
      'OP-4': 'Atoro en conexión de alcantarillado e inundaciones',
      'OP-5': 'Cortes del servicio no programados',
      'OP-6': 'Falta de accesorios de seguridad en trabajos',
      'OP-7': 'Seguridad: emanaciones del sistema de alcantarillado',

      // Agua Potable (Formato 1)
      'B1': 'Agua potable · Fugas en conexión domiciliaria',
      'B5': 'Agua potable · Fugas en red matriz',
      'B8': 'Agua potable · Falta de agua',
      'B9': 'Agua potable · Limpieza de llave de toma',
      'B10': 'Agua potable · Fuga de agua en caja de medidor',
      'B11': 'Agua potable · Mantenimiento de medidor',
      'B13': 'Agua potable · Calidad de agua',
      'B14': 'Agua potable · Instalación de medidor',
      'FALTA DE PRESIÓN DE AGUA': 'Agua potable · Presión insuficiente',
      'REPOSICIÓN DE CAJA DE MEDIDOR': 'Agua potable · Caja rota o deteriorada',
      'REPOSICIÓN DE MEDIDOR POR HURTO': 'Agua potable · Robo del medidor',
      'CAMBIO DE LLAVE DE PASO': 'Agua potable · Válvula malograda',
      'REUBICACIÓN DE CONEXION': 'Agua potable · Mover toma',
      'REPOSICIÓN DE MARCO Y TAPA DE AGUA': 'Agua potable · Cambio de cubierta',
      'NIVELACIÓN DE CAJA DE REGISTRO DE AGUA':
          'Agua potable · Ajuste a vereda',

      // Alcantarillado (Formato 1)
      'B6': 'Alcantarillado · Atoro en conexión domiciliaria',
      'B7': 'Alcantarillado · Atoro en red matriz',
      'B12': 'Alcantarillado · Buzón sin tapa',
      'REPOSICIÓN DE MARCO Y TAPA DE ALCANTARILLADO':
          'Alcantarillado · Tapa dañada',
      'NIVELACIÓN DE CAJA DE REGISTRO DE ALCANTARILLADO':
          'Alcantarillado · Alinear caja',
      'REPOSICIÓN DE TUBERIA DE CONCRETO A PVC - ALCANTARILLADO':
          'Alcantarillado · Modernización',

      // Otros
      'A1': 'Otros · Filtración externa',
      'TRABAJOS COLATERAS': 'Otros · Daños incidentales',
      'OTROS': 'Otros · Reclamos generales',
    };
    return map.containsKey(code) ? '$code - ${map[code]}' : code;
  }
}
