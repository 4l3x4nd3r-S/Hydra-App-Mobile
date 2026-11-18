import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils/os_excel_exporter.dart';
import '../../../../domain/models/os.dart';
import '../../../core/theme/app_colors.dart';
import '../../os_inbox/widgets/os_inbox_content.dart';
import '../view_models/supervisor_os_view_model.dart';

class SupervisorOsContent extends StatefulWidget {
  const SupervisorOsContent(
      {super.key, required this.onOpenOrder, this.onShareExport});

  final ValueChanged<Os> onOpenOrder;
  final Future<void> Function(OsExcelExport report, Rect origin)? onShareExport;

  @override
  State<SupervisorOsContent> createState() => _SupervisorOsContentState();
}

class _SupervisorOsContentState extends State<SupervisorOsContent> {
  bool _sharing = false;

  Future<void> _export(BuildContext buttonContext) async {
    if (_sharing) return;
    final box = buttonContext.findRenderObject() as RenderBox;
    final origin = box.localToGlobal(Offset.zero) & box.size;
    final vm = context.read<SupervisorOsViewModel>();
    setState(() => _sharing = true);
    try {
      final report = await vm.exportCompletedOrders();
      if (!mounted) return;
      if (report == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(vm.exportErrorMessage ?? 'No se pudo generar el Excel.'),
        ));
        return;
      }
      if (widget.onShareExport != null) {
        await widget.onShareExport!(report, origin);
      } else {
        await SharePlus.instance.share(ShareParams(
          files: [
            XFile.fromData(report.bytes, mimeType: OsExcelExporter.mimeType)
          ],
          fileNameOverrides: [report.fileName],
          title: 'Exportar órdenes realizadas',
          subject: 'Órdenes de servicio realizadas',
          sharePositionOrigin: origin,
        ));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No se pudo compartir el Excel. Intente nuevamente.'),
        ));
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SupervisorOsViewModel>();
    final c = Theme.of(context).extension<AppColors>()!;
    final busy = _sharing || vm.isExporting;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Órdenes de servicio',
                    style: TextStyle(
                        color: c.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                Builder(
                    builder: (buttonContext) => OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: c.primary,
                            side: BorderSide(color: c.border),
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: busy || vm.isLoading
                              ? null
                              : () => _export(buttonContext),
                          icon: busy
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: c.primary))
                              : const Icon(Icons.file_download_outlined,
                                  size: 20),
                          label:
                              Text(busy ? 'Generando Excel' : 'Exportar Excel'),
                        )),
              ],
            ),
          ),
        ),
        Expanded(
            child: OsInboxContent(
          osActivas: vm.osActivas,
          osArchivadas: vm.osArchivadas,
          isLoading: vm.isLoading,
          errorMessage: vm.errorMessage,
          onRefresh: vm.cargarTodo,
          onTapActiva: widget.onOpenOrder,
          onTapArchivada: widget.onOpenOrder,
        )),
      ],
    );
  }
}
