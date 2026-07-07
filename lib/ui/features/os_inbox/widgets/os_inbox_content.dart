import 'package:flutter/material.dart';
import '../../../../domain/models/os.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_card.dart';
import 'os_list_tile.dart';

class OsInboxContent extends StatelessWidget {
  final List<Os> osActivas;
  final List<Os> osArchivadas;
  final bool isLoading;
  final String? errorMessage;
  final bool Function(Os os)? isLiderOfOs;
  final void Function(Os os)? onTapActiva;
  final void Function(Os os)? onTapArchivada;
  final Future<void> Function()? onRefresh;

  const OsInboxContent({
    super.key,
    required this.osActivas,
    required this.osArchivadas,
    this.isLoading = false,
    this.errorMessage,
    this.isLiderOfOs,
    this.onTapActiva,
    this.onTapArchivada,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;

    Widget content = SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errorMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: Color(0xFFDC2626), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFFDC2626),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),

          _buildSection(
            title: 'ACTIVAS',
            osList: osActivas,
            emptyMessage: 'No hay ordenes de servicio activas',
            c: c,
            onTap: onTapActiva,
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'ARCHIVADAS',
            osList: osArchivadas,
            emptyMessage: 'No hay ordenes de servicio archivadas',
            c: c,
            onTap: onTapArchivada,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: content,
      );
    }

    return content;
  }

  Widget _buildSection({
    required String title,
    required List<Os> osList,
    required String emptyMessage,
    required AppColors c,
    void Function(Os os)? onTap,
  }) {
    final tiles = osList.map((os) {
      final readOnly = !(isLiderOfOs?.call(os) ?? true);
      
      String? cuadrillaStr;
      if (os.cuadrilla != null) {
        final c = os.cuadrilla!;
        final nombreCompleto = c.lider?.nombre ?? '';
        final partesNombre = nombreCompleto.split(' ');
        final primerNombre = partesNombre.isNotEmpty ? partesNombre[0] : '';
        final primerApellido = partesNombre.length > 1 ? partesNombre[1] : '';
        final codigoLimpio = (c.codigoGrupo ?? c.id.toString()).replaceAll('#', '').trim();
        cuadrillaStr = '$codigoLimpio${primerNombre.isNotEmpty ? ' ($primerNombre $primerApellido)'.trimRight() : ''}';
      } else if (os.cuadrillaId != null) {
        cuadrillaStr = 'Cuadrilla ${os.cuadrillaId}';
      }

      return OsListTile(
        data: OsListTileData(
          id: os.id,
          numeroOrden: os.numeroOrden,
          fechaProgramacion: os.fechaProgramacion,
          tipoProblema: os.reclamo?.tipoProblema ?? os.problemas,
          direccion: os.reclamo?.direccion,
          cuadrilla: cuadrillaStr,
          estado: os.estadoOrden,
          isReadOnly: readOnly,
          onTap: onTap != null ? () => onTap(os) : null,
        ),
        c: c,
      );
    }).toList();

    return SectionCard(
      title: title,
      count: osList.length,
      emptyMessage: emptyMessage,
      c: c,
      tiles: tiles,
    );
  }
}
