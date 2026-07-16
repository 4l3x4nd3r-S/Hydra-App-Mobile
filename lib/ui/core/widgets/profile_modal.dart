import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProfileModal extends StatelessWidget {
  final String userName;
  final String role;
  final String? dni;
  final String? cuadrilla;
  final String area;

  const ProfileModal({
    super.key,
    required this.userName,
    required this.role,
    this.dni,
    this.cuadrilla,
    this.area = 'Mantenimiento',
  });

  static void show(
    BuildContext context, {
    required String userName,
    required String role,
    String? dni,
    String? cuadrilla,
    String area = 'Mantenimiento',
  }) {
    showDialog(
      context: context,
      builder: (context) => ProfileModal(
        userName: userName,
        role: role,
        dni: dni,
        cuadrilla: cuadrilla,
        area: area,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final isSupervisor = role.toUpperCase() == 'SUPERVISOR';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: c.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with avatar
            CircleAvatar(
              radius: 46,
              backgroundColor: c.primary.withValues(alpha: 0.1),
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                style: TextStyle(
                  color: c.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              userName.isNotEmpty ? userName : 'Usuario',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: c.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                role.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: c.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Info Fields
            _buildInfoRow(context, Icons.badge_outlined, 'Nombres y Apellidos',
                userName.isNotEmpty ? userName : '-'),
            const SizedBox(height: 12),
            if (dni != null && dni!.trim().isNotEmpty) ...[
              _buildInfoRow(context, Icons.credit_card_rounded, 'CÓDIGO', dni!),
              const SizedBox(height: 12),
            ],
            _buildInfoRow(
              context,
              Icons.business_outlined,
              'Área',
              area,
            ),

            if (!isSupervisor) ...[
              const SizedBox(height: 12),
              _buildInfoRow(context, Icons.group_work_outlined, 'Cuadrilla',
                  _cuadrillaValue(cuadrilla)),
            ],

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: c.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Cerrar',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _cuadrillaValue(String? value) {
    final normalized = (value ?? '').trim().replaceFirst(
          RegExp(r'^(cuadrilla\s*)+', caseSensitive: false),
          '',
        );
    return normalized.isEmpty ? 'Sin asignar' : normalized;
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    final c = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: c.border),
            ),
            child: Icon(icon, color: c.onSurfaceVariant, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: c.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: c.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
