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

  const OsListTile({
    super.key,
    required this.data,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: c.surface,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: c.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: O.S. No. / Status / Pill
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: c.onSurfaceVariant.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            data.numeroOrden != null
                                ? 'N° ${data.numeroOrden}'
                                : 'N° ${data.id}',
                            style: TextStyle(
                              color: c.onSurfaceVariant,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (data.asignadoA != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.engineering_outlined,
                                  size: 14, color: c.onSurface),
                              const SizedBox(width: 4),
                              Text(
                                data.asignadoA!,
                                style: TextStyle(
                                  color: c.onSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (data.estado != null)
                    Hero(
                      tag: 'os_status_${data.id}',
                      child: StatusChip(status: data.estado!),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Descripción (contenido principal)
              if (data.descripcion != null) ...[
                Text(
                  data.descripcion!,
                  style: TextStyle(
                    color: c.onSurface,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.35,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
              ],

              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 16, color: c.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      data.direccion ?? 'Sin dirección',
                      style: TextStyle(
                        color: c.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Tipo Problema (chip secundario)
              if (data.tipoProblema != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getTipoProblemaLabel(data.tipoProblema).toUpperCase(),
                      style: TextStyle(
                        color: c.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              Divider(height: 1, color: c.border.withValues(alpha: 0.5)),
              const SizedBox(height: 12),

              // Footer: Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 14, color: c.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _formatFecha(data.fechaProgramacion),
                            style: TextStyle(
                              color: c.onSurfaceVariant,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: c.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFecha(String? fechaRaw) {
    if (fechaRaw == null || fechaRaw.isEmpty) return 'No programado';
    try {
      final date = DateTime.parse(fechaRaw);
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

      return 'Programado: $dia/$mes/$anio - $horaStr:$minuto $ampm';
    } catch (e) {
      // In case it's not ISO format and already somewhat formatted
      return 'Programado: $fechaRaw';
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
      'NIVELACIÓN DE CAJA DE REGISTRO DE AGUA': 'Agua potable · Ajuste a vereda',
      
      // Alcantarillado (Formato 1)
      'B6': 'Alcantarillado · Atoro en conexión domiciliaria',
      'B7': 'Alcantarillado · Atoro en red matriz',
      'B12': 'Alcantarillado · Buzón sin tapa',
      'REPOSICIÓN DE MARCO Y TAPA DE ALCANTARILLADO': 'Alcantarillado · Tapa dañada',
      'NIVELACIÓN DE CAJA DE REGISTRO DE ALCANTARILLADO': 'Alcantarillado · Alinear caja',
      'REPOSICIÓN DE TUBERIA DE CONCRETO A PVC - ALCANTARILLADO': 'Alcantarillado · Modernización',
      
      // Otros
      'A1': 'Otros · Filtración externa',
      'TRABAJOS COLATERAS': 'Otros · Daños incidentales',
      'OTROS': 'Otros · Reclamos generales',
    };
    return map.containsKey(code) ? '$code - ${map[code]}' : code;
  }
}
