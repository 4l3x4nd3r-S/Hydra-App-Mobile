import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/models/reclamo.dart';
import '../../../../domain/models/cuadrilla.dart';
import '../../../../domain/use_cases/create_os_from_reclamo_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../view_models/reclamo_detalle_view_model.dart';

class ReclamoDetalleView extends StatelessWidget {
  final Reclamo reclamo;
  final List<Cuadrilla> cuadrillas;

  const ReclamoDetalleView({
    super.key,
    required this.reclamo,
    required this.cuadrillas,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReclamoDetalleViewModel(
        reclamo: reclamo,
        createOsUseCase:
            context.read<CreateOsFromReclamoUseCase>(),
      ),
      child: _ReclamoDetalleBody(cuadrillas: cuadrillas),
    );
  }
}

class _ReclamoDetalleBody extends StatefulWidget {
  final List<Cuadrilla> cuadrillas;
  const _ReclamoDetalleBody({required this.cuadrillas});

  @override
  State<_ReclamoDetalleBody> createState() =>
      _ReclamoDetalleBodyState();
}

class _ReclamoDetalleBodyState extends State<_ReclamoDetalleBody> {
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.watch<ReclamoDetalleViewModel>();
    final r = vm.reclamo;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: c.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Reclamo #${r.id}',
            style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: c.onSurface)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(c, 'INFORMACION DEL RECLAMO', [
              _buildEstadoChip(c, r.estado ?? 'No disponible'),
              const SizedBox(height: 16),
              _buildFieldItem(c, 'Formato', r.formato),
              _buildFieldItem(
                  c, 'Codigo de solicitud', r.codigoSolicitud),
              _buildFieldItem(c, 'Fecha de registro',
                  _formatDate(r.fechaRegistro)),
              _buildFieldItem(
                  c, 'Canal de entrada', r.canalEntrada),
              _buildFieldItem(
                  c, 'Tipo de problema', r.tipoProblema),
              _buildFieldItem(c, 'Descripcion', r.descripcion,
                  isMultiline: true),
            ]),
            const SizedBox(height: 16),
            _buildSectionCard(
                c, 'DATOS DEL RECLAMANTE', [
              _buildFieldItem(c, 'Nombres y apellidos',
                  r.nombreSolicitante),
              _buildFieldItem(
                  c, 'Direccion', r.direccion),
              _buildFieldItem(c, 'N de medidor',
                  r.numeroMedidor),
              _buildFieldItem(c, 'Celular', r.telefono),
              _buildFieldItem(
                  c, 'Correo electronico', r.email),
            ]),
            if ((r.estado ?? 'PENDIENTE').toUpperCase() == 'PENDIENTE') ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12)),
                  ),
                  icon: const Icon(
                      Icons.assignment_turned_in_rounded,
                      color: Colors.white),
                  label: const Text(
                      'ASIGNAR A UNA CUADRILLA',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Outfit')),
                  onPressed: vm.creandoOs
                      ? null
                      : () => _mostrarModalAsignarCuadrilla(),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
      AppColors c, String title, List<Widget> children) {
    return Card(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: c.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: c.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.info_outline_rounded,
                      color: c.primary, size: 16),
                ),
                const SizedBox(width: 10),
                Text(title,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: c.primary,
                        letterSpacing: 1)),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildFieldItem(AppColors c, String label, dynamic value,
      {bool isMultiline = false}) {
    final displayValue =
        value?.toString() ?? 'No disponible';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: c.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text(displayValue,
              style: TextStyle(
                  color: c.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
              maxLines: isMultiline ? 10 : 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'No disponible';
    final s = date.toString();
    return s.length > 19
        ? s.substring(0, 19).replaceAll('T', ' ')
        : s;
  }

  Widget _buildEstadoChip(AppColors c, String estado) {
    Color chipColor;
    switch (estado) {
      case 'PENDIENTE':
        chipColor = const Color(0xFF0A2472);
        break;
      case 'ASIGNADO':
        chipColor = const Color(0xFFF59E0B);
        break;
      case 'EN PROCESO':
        chipColor = const Color(0xFF3B82F6);
        break;
      case 'ATENDIDO':
        chipColor = const Color(0xFF22C55E);
        break;
      default:
        chipColor = c.onSurfaceVariant;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Future<bool?> _mostrarModalAsignarCuadrilla() {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.read<ReclamoDetalleViewModel>();
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _AsignarCuadrillaBody(
        cuadrillas: widget.cuadrillas,
        c: c,
        onConfirmar: vm.crearOsFromReclamo,
        ultimoError: vm.ultimoError,
      ),
    );
  }
}

class _AsignarCuadrillaBody extends StatefulWidget {
  final List<Cuadrilla> cuadrillas;
  final AppColors c;
  final Future<bool> Function(int) onConfirmar;
  final String? ultimoError;
  const _AsignarCuadrillaBody({
    required this.cuadrillas,
    required this.c,
    required this.onConfirmar,
    this.ultimoError,
  });

  @override
  State<_AsignarCuadrillaBody> createState() =>
      _AsignarCuadrillaBodyState();
}

class _AsignarCuadrillaBodyState
    extends State<_AsignarCuadrillaBody> {
  int? _cuadrillaSeleccionada;
  bool _procesando = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Seleccionar Cuadrilla',
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: c.onSurface)),
          const SizedBox(height: 4),
          Text(
              'Esta accion creara una Orden de Servicio',
              style: TextStyle(
                  color: c.onSurfaceVariant, fontSize: 12)),
          const SizedBox(height: 20),
          ...widget.cuadrillas.map((cu) {
            return RadioListTile<int>(
              activeColor: c.primary,
              title: Text(cu.codigoGrupo ?? '',
                  style: TextStyle(
                      color: c.onSurface,
                      fontWeight: FontWeight.bold)),
              subtitle: Text(
                  cu.especialidad ?? "Sin especialidad",
                  style: TextStyle(
                      color: c.onSurfaceVariant,
                      fontSize: 11)),
              value: cu.id,
              groupValue: _cuadrillaSeleccionada,
              onChanged: (v) => setState(
                  () => _cuadrillaSeleccionada = v),
            );
          }),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12)),
              ),
              onPressed:
                  _procesando || _cuadrillaSeleccionada == null
                      ? null
                      : () async {
                          setState(() => _procesando = true);
                          final ok = await widget.onConfirmar(
                              _cuadrillaSeleccionada!);
                          if (!context.mounted) return;
                          if (ok) {
                            Navigator.pop(context, true);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('OS creada exitosamente'),
                              backgroundColor:
                                  Color(0xFF22C55E),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text(
                                  widget.ultimoError ??
                                      'Error al crear O.S.'),
                              backgroundColor:
                                  const Color(0xFFDC2626),
                            ));
                          }
                          if (mounted) {
                            setState(() => _procesando = false);
                          }
                        },
              child: _procesando
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'CONFIRMAR Y CREAR O.S.',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit')),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
