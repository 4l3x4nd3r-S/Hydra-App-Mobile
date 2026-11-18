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
  final int pendingSyncCount;
  final List<Os> pendingSyncOrders;
  final bool isSyncing;
  final Future<void> Function()? onSync;
  final bool showOperationalDetails;

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
    this.pendingSyncCount = 0,
    this.pendingSyncOrders = const [],
    this.isSyncing = false,
    this.onSync,
    this.showOperationalDetails = true,
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
        if (widget.pendingSyncCount > 0)
          Semantics(
            button: true,
            label: 'Ver órdenes de servicio guardadas en este dispositivo',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showPendingSyncOrders(c),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      color: Color(0xFFF59E0B),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.pendingSyncCount == 1
                                ? '1 O.S. guardada en este dispositivo'
                                : '${widget.pendingSyncCount} O.S. guardadas en este dispositivo',
                            style: TextStyle(
                              color: c.onSurface,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Toca para revisar qué órdenes están pendientes.',
                            style: TextStyle(
                              color: c.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFF59E0B),
                      size: 20,
                    ),
                    TextButton(
                      onPressed: widget.isSyncing ? null : widget.onSync,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFF59E0B),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: widget.isSyncing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFF59E0B),
                              ),
                            )
                          : const Text(
                              'REINTENTAR',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: widget.isLoading
                ? Center(
                    key: const ValueKey('loading'),
                    child: CircularProgressIndicator(color: c.primary),
                  )
                : IndexedStack(
                    key: const ValueKey('content'),
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
        ),
      ],
    );
  }

  Future<void> _showPendingSyncOrders(AppColors c) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.72,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.onSurfaceVariant.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 10, 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFF59E0B).withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.cloud_off_outlined,
                          color: Color(0xFFF59E0B),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'O.S. guardadas sin conexión',
                              style: TextStyle(
                                color: c.onSurface,
                                fontFamily: 'Outfit',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${widget.pendingSyncOrders.length} pendientes de enviar al servidor',
                              style: TextStyle(
                                color: c.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Cerrar',
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: c.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: c.border.withValues(alpha: 0.6)),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.pendingSyncOrders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) {
                      final os = widget.pendingSyncOrders[index];
                      return _buildPendingOrderTile(c, os);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton.icon(
                      onPressed: widget.isSyncing
                          ? null
                          : () async {
                              await widget.onSync?.call();
                              if (sheetContext.mounted) {
                                Navigator.of(sheetContext).pop();
                              }
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: const Color(0xFF1F2937),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.sync_rounded, size: 19),
                      label: const Text(
                        'REINTENTAR SINCRONIZACIÓN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPendingOrderTile(AppColors c, Os os) {
    final number = os.numeroOrden?.trim().isNotEmpty == true
        ? os.numeroOrden!.trim()
        : os.id.toString().padLeft(7, '0');
    final description = os.reclamo?.descripcion?.trim().isNotEmpty == true
        ? os.reclamo!.descripcion!.trim()
        : (os.observacionesGasfitero?.trim().isNotEmpty == true
            ? os.observacionesGasfitero!.trim()
            : 'Reporte almacenado localmente');

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Color(0xFFF59E0B),
              size: 19,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'O.S. N° $number',
                        style: TextStyle(
                          color: c.onSurface,
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      'POR SINCRONIZAR',
                      style: TextStyle(
                        color: Color(0xFFF59E0B),
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: c.onSurfaceVariant,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
                if (os.reclamo?.direccion?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: c.onSurfaceVariant,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          os.reclamo!.direccion!.trim(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: c.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTabs(AppColors c) {
    final tabs = [
      ('ACTIVAS', widget.osActivas.length, c.primary),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
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
                    style: TextStyle(color: c.onSurfaceVariant, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

      if (widget.onRefresh != null) {
        return RefreshIndicator(onRefresh: widget.onRefresh!, child: child);
      }

      return child;
    }

    final child = ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: osList.length,
      itemBuilder: (context, index) {
        final os = osList[index];
        final readOnly = !(widget.isLiderOfOs?.call(os) ?? true);

        String? asignadoStr;
        if (os.responsable != null) {
          asignadoStr = os.responsable!.nombre ?? 'Sin nombre';
        } else if (os.cuadrilla != null) {
          final cu = os.cuadrilla!;
          final nombreCompleto = cu.lider?.nombre ?? '';
          final partesNombre = nombreCompleto.split(' ');
          final primerNombre = partesNombre.isNotEmpty ? partesNombre[0] : '';
          final primerApellido = partesNombre.length > 1 ? partesNombre[1] : '';
          final codigoLimpio =
              (cu.codigoGrupo ?? cu.id.toString()).replaceAll('#', '').trim();
          asignadoStr =
              '$codigoLimpio${primerNombre.isNotEmpty ? ' ($primerNombre $primerApellido)'.trimRight() : ''}';
        } else if (os.cuadrillaId != null) {
          asignadoStr = 'Cuadrilla ${os.cuadrillaId}';
        }

        return OsListTile(
          showOperationalDetails: widget.showOperationalDetails,
          data: OsListTileData(
            id: os.id,
            numeroOrden: os.numeroOrden,
            fechaProgramacion: os.fechaProgramacion,
            tipoProblema: os.reclamo?.tipoProblema,
            descripcion: os.reclamo?.descripcion,
            direccion: os.reclamo?.direccion,
            asignadoA: asignadoStr,
            estado: os.estadoOrden,
            isReadOnly: readOnly,
            onTap: onTap != null ? () => onTap(os) : null,
          ),
          c: c,
        );
      },
    );

    if (widget.onRefresh != null) {
      return RefreshIndicator(onRefresh: widget.onRefresh!, child: child);
    }

    return child;
  }
}
