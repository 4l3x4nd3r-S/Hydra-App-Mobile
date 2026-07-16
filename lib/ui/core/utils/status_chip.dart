import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final Color? color;

  const StatusChip({
    super.key,
    required this.status,
    this.color,
  });

  static Color colorForStatus(String status) {
    final norm = status.toUpperCase().replaceAll(' ', '_');
    switch (norm) {
      case 'PENDIENTE':
        return const Color(0xFF60A5FA);
      case 'ASIGNADO':
      case 'EN_PROCESO':
      case 'EN PROCESO':
      case 'PENDIENTE_DE_SINCRONIZAR':
        return const Color(0xFFF59E0B);
      case 'ATENDIDO':
      case 'COMPLETADO':
      case 'CERRADO':
        return const Color(0xFF22C55E);
      case 'RECHAZADO':
      case 'ARCHIVADO':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? colorForStatus(status);
    final normalized = status.toUpperCase().replaceAll(' ', '_');
    final label =
        normalized == 'PENDIENTE_DE_SINCRONIZAR' ? 'POR SINCRONIZAR' : status;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: chipColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
