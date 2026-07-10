import 'package:flutter/material.dart';
import '../../../../domain/models/os.dart';
import '../../../core/theme/app_colors.dart';
import 'os_list_tile.dart';

class OsInboxContent extends StatefulWidget {
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
  State<OsInboxContent> createState() => _OsInboxContentState();
}

class _OsInboxContentState extends State<OsInboxContent> {
  int _selectedSubTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;

    return Column(
      children: [
        if (widget.errorMessage != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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
                    widget.errorMessage!,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildSubTabs(c),
            ),
          ),
        ),
        Expanded(
          child: widget.isLoading
              ? Center(
                  child: CircularProgressIndicator(color: c.primary))
              : IndexedStack(
                  index: _selectedSubTabIndex,
                  children: [
                    _buildListaPorEstado(
                      c,
                      widget.osActivas,
                      'No hay ordenes de servicio activas',
                      Icons.engineering_outlined,
                      widget.onTapActiva,
                    ),
                    _buildListaPorEstado(
                      c,
                      widget.osArchivadas,
                      'No hay ordenes de servicio archivadas',
                      Icons.archive_outlined,
                      widget.onTapArchivada,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildSubTabs(AppColors c) {
    final tabs = [
      ('ACTIVAS', widget.osActivas.length, const Color(0xFF0A2472)),
      ('ARCHIVADAS', widget.osArchivadas.length, const Color(0xFF22C55E)),
    ];

    return Row(
      children: tabs.asMap().entries.map((entry) {
        final i = entry.key;
        final (label, count, color) = entry.value;
        final isSelected = _selectedSubTabIndex == i;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedSubTabIndex = i),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? color : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 12,
                        color: isSelected ? color : c.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListaPorEstado(
    AppColors c,
    List<Os> osList,
    String emptyMsg,
    IconData emptyIcon,
    void Function(Os os)? onTap,
  ) {
    if (osList.isEmpty) {
      final child = ListView(
        children: [
          SizedBox(
            height: 220,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(emptyIcon,
                      size: 48,
                      color: c.onSurfaceVariant.withValues(alpha: 0.4)),
                  const SizedBox(height: 12),
                  Text(
                    emptyMsg,
                    style: TextStyle(
                        color: c.onSurfaceVariant, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

      if (widget.onRefresh != null) {
        return RefreshIndicator(
            onRefresh: widget.onRefresh!, child: child);
      }

      return child;
    }

    final child = ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: osList.length,
      itemBuilder: (context, index) {
        final os = osList[index];
        final readOnly = !(widget.isLiderOfOs?.call(os) ?? true);

        String? cuadrillaStr;
        if (os.cuadrilla != null) {
          final cu = os.cuadrilla!;
          final nombreCompleto = cu.lider?.nombre ?? '';
          final partesNombre = nombreCompleto.split(' ');
          final primerNombre =
              partesNombre.isNotEmpty ? partesNombre[0] : '';
          final primerApellido =
              partesNombre.length > 1 ? partesNombre[1] : '';
          final codigoLimpio =
              (cu.codigoGrupo ?? cu.id.toString())
                  .replaceAll('#', '')
                  .trim();
          cuadrillaStr =
              '$codigoLimpio${primerNombre.isNotEmpty ? ' ($primerNombre $primerApellido)'.trimRight() : ''}';
        } else if (os.cuadrillaId != null) {
          cuadrillaStr = 'Cuadrilla ${os.cuadrillaId}';
        }

        return OsListTile(
          data: OsListTileData(
            id: os.id,
            numeroOrden: os.numeroOrden,
            fechaProgramacion: os.fechaProgramacion,
            tipoProblema: os.reclamo?.tipoProblema,
            descripcion: os.reclamo?.descripcion,
            direccion: os.reclamo?.direccion,
            cuadrilla: cuadrillaStr,
            estado: os.estadoOrden,
            isReadOnly: readOnly,
            onTap: onTap != null ? () => onTap(os) : null,
          ),
          c: c,
        );
      },
    );

    if (widget.onRefresh != null) {
      return RefreshIndicator(
          onRefresh: widget.onRefresh!, child: child);
    }

    return child;
  }
}
