import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/status_chip.dart';
import 'reclamo_tile_data.dart';

class ReclamoListTile extends StatelessWidget {
  final ReclamoTileData data;
  final AppColors c;

  const ReclamoListTile({
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Solicitud N° ... [ ANEXO X ]
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solicitud N° ${data.codigoSolicitud ?? '-----'}',
                          style: TextStyle(
                            color: c.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getTimeAgo(data.fechaRegistro, data.estado ?? ''),
                          style: TextStyle(
                            color: c.onSurfaceVariant.withValues(alpha: 0.8),
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (data.formato != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: c.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            data.formato!.toUpperCase(),
                            style: TextStyle(
                              color: c.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (data.estado != null) StatusChip(status: data.estado!),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Description (contenido principal)
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
                      (data.tipoProblema ?? '').toUpperCase(),
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

              // Divider
              Divider(height: 1, color: c.border.withValues(alpha: 0.5)),
              const SizedBox(height: 12),

              // User Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 16, color: c.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data.nombreSolicitante ?? 'Usuario Anónimo',
                            style: TextStyle(
                              color: c.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (data.numeroSuministro != null)
                    Text(
                      'Sum: ${data.numeroSuministro}',
                      style: TextStyle(
                        color: c.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(String? fechaStr, String estado) {
    if (fechaStr == null) return '';
    try {
      final fecha = DateTime.parse(fechaStr);
      final diff = DateTime.now().difference(fecha);

      String timeText = '';
      if (diff.inDays > 0) {
        timeText = '${diff.inDays} ${diff.inDays == 1 ? "día" : "días"}';
      } else if (diff.inHours > 0) {
        timeText = '${diff.inHours} ${diff.inHours == 1 ? "hora" : "horas"}';
      } else if (diff.inMinutes > 0) {
        timeText = '${diff.inMinutes} ${diff.inMinutes == 1 ? "min" : "mins"}';
      } else {
        timeText = 'unos instantes';
      }

      if (estado == 'PENDIENTE') return 'Hace $timeText';
      if (estado == 'ASIGNADO') return 'Asignado hace $timeText';
      if (estado == 'CERRADO') {
        final date =
            '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}';
        return 'Resuelto el $date';
      }
      return 'Hace $timeText';
    } catch (e) {
      return '';
    }
  }
}
