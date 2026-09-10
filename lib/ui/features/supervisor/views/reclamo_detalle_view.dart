import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/catalog_repository.dart';
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
        createOsUseCase: context.read<CreateOsFromReclamoUseCase>(),
        catalogRepository: context.read<CatalogRepository>(),
      ),
      child: _ReclamoDetalleBody(cuadrillas: cuadrillas),
    );
  }
}

class _ReclamoDetalleBody extends StatefulWidget {
  final List<Cuadrilla> cuadrillas;
  const _ReclamoDetalleBody({
    required this.cuadrillas,
  });

  @override
  State<_ReclamoDetalleBody> createState() => _ReclamoDetalleBodyState();
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
          icon: Icon(Icons.arrow_back_ios_rounded, color: c.primary),
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
            _buildSectionCard(
              c,
              title: 'INFORMACIÓN DEL RECLAMO',
              subtitle: 'Resumen de la solicitud registrada',
              icon: Icons.assignment_outlined,
              trailing: Hero(
                tag: 'reclamo_status_${r.id}',
                child: _buildEstadoChip(c, r.estado ?? 'No disponible'),
              ),
              child: _buildInfoGrid(c, [
                _DetailItem(
                  icon: Icons.description_outlined,
                  label: 'Formato',
                  value: r.formato,
                  span: 6,
                ),
                _DetailItem(
                  icon: Icons.tag_rounded,
                  label: 'Código de solicitud',
                  value: r.codigoSolicitud,
                  span: 6,
                ),
                _DetailItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Fecha de registro',
                  value: r.fechaRegistro,
                  span: 12,
                  dateTime: true,
                ),
                _DetailItem(
                  icon: Icons.login_rounded,
                  label: 'Canal de entrada',
                  value: r.canalEntrada,
                  span: 12,
                ),
                _DetailItem(
                  icon: Icons.build_outlined,
                  label: 'Tipo de problema',
                  value: r.tipoProblema ?? '',
                  span: 12,
                ),
                _DetailItem(
                  icon: Icons.notes_rounded,
                  label: 'Descripción',
                  value: r.descripcion,
                  fullWidth: true,
                  multiline: true,
                ),
              ]),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              c,
              title: 'DATOS DEL RECLAMANTE',
              subtitle: 'Información de contacto del usuario',
              icon: Icons.person_outline_rounded,
              child: _buildInfoGrid(c, [
                _DetailItem(
                  icon: Icons.badge_outlined,
                  label: 'Nombres y apellidos',
                  value: r.nombreSolicitante,
                  fullWidth: true,
                ),
                _DetailItem(
                  icon: Icons.location_on_outlined,
                  label: 'Dirección',
                  value: r.direccion,
                  fullWidth: true,
                ),
                _DetailItem(
                  icon: Icons.speed_rounded,
                  label: 'N.° de suministro',
                  value: r.numeroSuministro,
                  span: 6,
                ),
                _DetailItem(
                  icon: Icons.phone_outlined,
                  label: 'Celular',
                  value: r.telefono,
                  span: 6,
                ),
                _DetailItem(
                  icon: Icons.mail_outline_rounded,
                  label: 'Correo electrónico',
                  value: r.email,
                  fullWidth: true,
                ),
              ]),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar:
          (r.estado ?? 'PENDIENTE').toUpperCase() == 'PENDIENTE'
              ? _buildStickyActionBar(c, r, vm)
              : null,
    );
  }

  Widget _buildSectionCard(
    AppColors c, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
    Widget? trailing,
  }) {
    return Card(
      color: c.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: c.border.withValues(alpha: 0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: c.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: c.primary,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: c.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing,
                ],
              ],
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: c.border.withValues(alpha: 0.7)),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGrid(AppColors c, List<_DetailItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final useCompactGrid = constraints.maxWidth >= 230;
        final availableGridWidth = constraints.maxWidth - spacing;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items.map((item) {
            final width = item.fullWidth || !useCompactGrid
                ? constraints.maxWidth
                : availableGridWidth * (item.span / 12);
            return SizedBox(
              width: width,
              child: _buildInfoTile(c, item),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildInfoTile(AppColors c, _DetailItem item) {
    final rawValue = item.value?.toString().trim() ?? '';
    final displayValue = rawValue.isEmpty ? 'No disponible' : rawValue;

    return Container(
      constraints: BoxConstraints(minHeight: item.multiline ? 0 : 82),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: item.multiline
            ? c.primary.withValues(alpha: 0.10)
            : c.primary.withValues(alpha: 0.065),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.multiline
              ? c.primary.withValues(alpha: 0.30)
              : c.primary.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 28,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Icon(item.icon, size: 15, color: c.primary),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    item.label.toUpperCase(),
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9.5,
                      height: 1.25,
                      fontWeight: FontWeight.bold,
                      color: c.onSurfaceVariant,
                      letterSpacing: 0.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          if (item.dateTime)
            _buildDateTimeValue(c, item.value)
          else
            Text(
              displayValue,
              maxLines: item.multiline ? 10 : 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: c.onSurface,
                fontSize: item.multiline ? 13.5 : 13,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateTimeValue(AppColors c, dynamic value) {
    final date = value is DateTime
        ? value
        : DateTime.tryParse(value?.toString().trim() ?? '');
    if (date == null) {
      return Text(
        'No disponible',
        style: TextStyle(
          color: c.onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    const weekdays = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minutes = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'a. m.' : 'p. m.';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            '${weekdays[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]} de ${date.year}',
            style: TextStyle(
              color: c.onSurface,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.primary.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule_rounded, color: c.primary, size: 16),
              const SizedBox(width: 6),
              Text(
                '$hour:$minutes $period',
                style: TextStyle(
                  color: c.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
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
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: c.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon:
                  Icon(Icons.assignment_turned_in_rounded, color: c.onPrimary),
              label: Text(
                'ASIGNAR A UNA CUADRILLA',
                style: TextStyle(
                  color: c.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'Outfit',
                  letterSpacing: 0.3,
                ),
              ),
              onPressed:
                  vm.creandoOs ? null : () => _mostrarModalAsignarCuadrilla(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEstadoChip(AppColors c, String estado) {
    Color chipColor;
    switch (estado) {
      case 'PENDIENTE':
        chipColor = c.primary;
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _AsignarReclamoBody(
        cuadrillas: vm.filtrarCuadrillasCompatibles(widget.cuadrillas),
        especialidadRequerida: vm.especialidadRequerida,
        c: c,
        onConfirmar: vm.crearOsFromReclamo,
        ultimoError: vm.ultimoError,
      ),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final dynamic value;
  final bool fullWidth;
  final bool multiline;
  final int span;
  final bool dateTime;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    this.fullWidth = false,
    this.multiline = false,
    this.span = 12,
    this.dateTime = false,
  }) : assert(span >= 1 && span <= 12);
}

class _AsignarReclamoBody extends StatefulWidget {
  final List<Cuadrilla> cuadrillas;
  final String? especialidadRequerida;
  final AppColors c;
  final Future<bool> Function(int cuadrillaId) onConfirmar;
  final String? ultimoError;
  const _AsignarReclamoBody({
    required this.cuadrillas,
    required this.especialidadRequerida,
    required this.c,
    required this.onConfirmar,
    this.ultimoError,
  });

  @override
  State<_AsignarReclamoBody> createState() => _AsignarReclamoBodyState();
}

class _AsignarReclamoBodyState extends State<_AsignarReclamoBody> {
  int? _cuadrillaSeleccionada;
  bool _procesando = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    final cuadrillasDisponibles = widget.cuadrillas
        .where((cuadrilla) => cuadrilla.tieneIntegrantesMinimos)
        .toList();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
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
                        color: c.onSurfaceVariant.withValues(alpha: 0.3),
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
                      style:
                          TextStyle(color: c.onSurfaceVariant, fontSize: 12)),
                  const SizedBox(height: 16),
                  if (cuadrillasDisponibles.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          widget.especialidadRequerida == null
                              ? 'El formato del reclamo no tiene una especialidad configurada'
                              : 'No hay cuadrillas de ${widget.especialidadRequerida} disponibles con al menos 2 integrantes',
                          style: TextStyle(
                              color: c.onSurfaceVariant, fontSize: 14),
                        ),
                      ),
                    )
                  else
                    ...cuadrillasDisponibles.map((cu) => _buildCuadrillaOption(
                        cu, _cuadrillaSeleccionada == cu.id)),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: c.surface,
              border: Border(
                top: BorderSide(
                  color: c.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: c.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _procesando || _cuadrillaSeleccionada == null
                      ? null
                      : () async {
                          setState(() => _procesando = true);
                          final ok = await widget.onConfirmar(
                            _cuadrillaSeleccionada!,
                          );
                          if (!context.mounted) return;
                          if (ok) {
                            Navigator.pop(context, true);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('OS creada exitosamente'),
                              backgroundColor: Color(0xFF22C55E),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  widget.ultimoError ?? 'Error al crear O.S.'),
                              backgroundColor: const Color(0xFFDC2626),
                            ));
                          }
                          if (mounted) {
                            setState(() => _procesando = false);
                          }
                        },
                  child: _procesando
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: c.onPrimary,
                          ),
                        )
                      : Text('CONFIRMAR Y CREAR O.S.',
                          style: TextStyle(
                              color: c.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuadrillaOption(Cuadrilla cu, bool isSelected) {
    final c = widget.c;
    final totalPersonas = cu.cantidadIntegrantes;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => setState(() => _cuadrillaSeleccionada = cu.id),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? c.primary.withValues(alpha: 0.08) : c.surface,
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
                backgroundColor: c.primary.withValues(alpha: 0.15),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            cu.codigoGrupo ?? 'Sin código',
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: c.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              cu.especialidad!,
                              style: TextStyle(
                                color: c.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
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
                            size: 13, color: c.onSurfaceVariant),
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
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? c.primary : c.border,
                    width: 2,
                  ),
                  color: isSelected ? c.primary : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 14, color: c.onPrimary)
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
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return partes[0][0].toUpperCase();
  }
}
