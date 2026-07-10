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
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: (r.estado ?? 'PENDIENTE')
                  .toUpperCase() ==
              'PENDIENTE'
          ? _buildStickyActionBar(c, r, vm)
          : null,
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

  Widget _buildStickyActionBar(
      AppColors c, Reclamo r, ReclamoDetalleViewModel vm) {
    return Material(
      color: c.surface,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: c.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: c.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.assignment_outlined,
                        size: 18, color: c.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Asignar a una cuadrilla para crear Orden de Servicio',
                        style: TextStyle(
                          color: c.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: c.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
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
                      fontFamily: 'Outfit',
                      letterSpacing: 0.3,
                    ),
                  ),
                  onPressed: vm.creandoOs
                      ? null
                      : () => _mostrarModalAsignarCuadrilla(),
                ),
              ),
            ],
          ),
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
          mainAxisSize: MainAxisSize.min,
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
      isScrollControlled: true,
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
    final maxHeight =
        MediaQuery.of(context).size.height * 0.85;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color:
                      c.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Seleccionar Cuadrilla',
                style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: c.onSurface)),
            const SizedBox(height: 4),
            Text('Esta accion creara una Orden de Servicio',
                style: TextStyle(
                    color: c.onSurfaceVariant, fontSize: 12)),
            const SizedBox(height: 16),
            if (widget.cuadrillas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No hay cuadrillas disponibles',
                    style: TextStyle(
                        color: c.onSurfaceVariant,
                        fontSize: 14),
                  ),
                ),
              )
            else if (widget.cuadrillas.length <= 3)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.cuadrillas
                    .map((cu) => _buildCuadrillaOption(
                        cu,
                        _cuadrillaSeleccionada ==
                            cu.id))
                    .toList(),
              )
            else
              ListView(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                children: widget.cuadrillas
                    .map((cu) => _buildCuadrillaOption(
                        cu,
                        _cuadrillaSeleccionada ==
                            cu.id))
                    .toList(),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: c.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12)),
                ),
                onPressed: _procesando ||
                        _cuadrillaSeleccionada == null
                    ? null
                    : () async {
                        setState(
                            () => _procesando = true);
                        final ok = await widget.onConfirmar(
                            _cuadrillaSeleccionada!);
                        if (!context.mounted) return;
                        if (ok) {
                          Navigator.pop(context, true);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'OS creada exitosamente'),
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
                          setState(
                              () => _procesando = false);
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
          ],
        ),
      ),
    );
  }

  Widget _buildCuadrillaOption(Cuadrilla cu, bool isSelected) {
    final c = widget.c;
    final totalPersonas = (cu.lider != null ? 1 : 0) +
        (cu.chofer != null ? 1 : 0) +
        (cu.operador != null ? 1 : 0) +
        cu.apoyos.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () =>
            setState(() => _cuadrillaSeleccionada = cu.id),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? c.primary.withValues(alpha: 0.08)
                : c.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? c.primary : c.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    c.primary.withValues(alpha: 0.15),
                child: Text(
                  _getIniciales(cu.lider?.nombre),
                  style: TextStyle(
                    color: c.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            cu.codigoGrupo ??
                                'Sin código',
                            style: TextStyle(
                              color: c.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (cu.especialidad != null)
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2),
                            decoration: BoxDecoration(
                              color: c.primary
                                  .withValues(alpha: 0.12),
                              borderRadius:
                                  BorderRadius.circular(4),
                            ),
                            child: Text(
                              cu.especialidad!,
                              style: TextStyle(
                                color: c.primary,
                                fontSize: 10,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (cu.lider != null)
                      Text(
                        'Líder: ${cu.lider!.nombre}',
                        style: TextStyle(
                          color: c.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.groups_outlined,
                            size: 13,
                            color:
                                c.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          '$totalPersonas integrantes',
                          style: TextStyle(
                            color: c.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration:
                    const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? c.primary
                        : c.border,
                    width: 2,
                  ),
                  color: isSelected
                      ? c.primary
                      : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check,
                        size: 14,
                        color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getIniciales(String? nombre) {
    if (nombre == null || nombre.isEmpty) return '?';
    final partes =
        nombre.trim().split(RegExp(r'\s+'));
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'
          .toUpperCase();
    }
    return partes[0][0].toUpperCase();
  }
}
