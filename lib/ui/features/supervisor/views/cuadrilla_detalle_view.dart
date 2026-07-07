import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/supervisor_repository.dart';
import '../../../../domain/models/cuadrilla.dart';
import '../../../../domain/models/gasfitero.dart';
import '../../../core/theme/app_colors.dart';
import '../view_models/cuadrilla_detalle_view_model.dart';

class CuadrillaDetalleView extends StatelessWidget {
  final Cuadrilla cuadrilla;
  final List<Gasfitero> gasfiteros;

  const CuadrillaDetalleView({
    super.key,
    required this.cuadrilla,
    required this.gasfiteros,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CuadrillaDetalleViewModel(
        supervisorRepository: context.read<SupervisorRepository>(),
        cuadrilla: cuadrilla,
        gasfiteros: gasfiteros,
      ),
      child: const _CuadrillaDetalleBody(),
    );
  }
}

class _CuadrillaDetalleBody extends StatefulWidget {
  const _CuadrillaDetalleBody();

  @override
  State<_CuadrillaDetalleBody> createState() => _CuadrillaDetalleBodyState();
}

class _CuadrillaDetalleBodyState extends State<_CuadrillaDetalleBody> {
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.watch<CuadrillaDetalleViewModel>();
    final cu = vm.current;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: c.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          cu.codigoGrupo ?? 'Cuadrilla',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: c.onSurface,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: vm.isActionLoading
              ? LinearProgressIndicator(
                  color: c.primary,
                  backgroundColor: c.background,
                  minHeight: 2,
                )
              : const SizedBox(height: 2),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: const Color(0xFFDC2626)),
            onPressed: () => _confirmDelete(context, vm, c),
            tooltip: 'Eliminar Cuadrilla',
          ),
        ],
      ),
      body: vm.isLoading
          ? Center(child: CircularProgressIndicator(color: c.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(c, cu),
                  const SizedBox(height: 16),
                  _buildRoleSection(
                    context,
                    icon: Icons.star_rounded,
                    label: 'Gasfitero Principal',
                    color: const Color(0xFF0A2472),
                    persona: cu.lider,
                    c: c,
                    vm: vm,
                  ),
                  const SizedBox(height: 12),
                  _buildRoleListSection(
                    context,
                    icon: Icons.engineering_rounded,
                    label: 'Gasfiteros de Apoyo',
                    color: const Color(0xFF64748B),
                    personas: cu.apoyos,
                    c: c,
                    vm: vm,
                  ),
                  
                  // Operador (Solo Agua)
                  if (cu.especialidad == 'Agua' && (cu.operador != null || vm.operadoresDisponibles.isNotEmpty)) ...[
                    const SizedBox(height: 12),
                    _buildRoleSection(
                      context,
                      icon: Icons.directions_car_rounded,
                      label: 'Operador',
                      color: const Color(0xFF0F766E),
                      persona: cu.operador,
                      c: c,
                      vm: vm,
                    ),
                  ],

                  // Chofer (Solo Alcantarillado / Mantenimiento)
                  if (cu.especialidad != 'Agua' && (cu.chofer != null || vm.choferesDisponibles.isNotEmpty)) ...[
                    const SizedBox(height: 12),
                    _buildRoleSection(
                      context,
                      icon: Icons.local_shipping_rounded,
                      label: 'Chofer',
                      color: const Color(0xFFB45309),
                      persona: cu.chofer,
                      c: c,
                      vm: vm,
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(AppColors c, Cuadrilla cu) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfo(c, 'Codigo de Grupo', cu.codigoGrupo),
          const SizedBox(height: 8),
          _buildInfo(c, 'Especialidad', cu.especialidad),
        ],
      ),
    );
  }

  Widget _buildInfo(AppColors c, String label, dynamic value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: TextStyle(color: c.onSurfaceVariant, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value?.toString() ?? '-',
            style: TextStyle(color: c.onSurface, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleListSection(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required List<Gasfitero> personas,
    required AppColors c,
    required CuadrillaDetalleViewModel vm,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(maxWidth: 80, maxHeight: 36),
                icon: Icon(Icons.person_add_rounded, color: c.primary, size: 18),
                onPressed: () => _mostrarModalAgregar(context, vm, 'APOYO'),
                tooltip: 'Agregar',
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (personas.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Sin apoyos asignados',
                style: TextStyle(color: c.onSurfaceVariant, fontSize: 12),
              ),
            ),
          ...personas.map((p) => _buildPersonTile(c, vm, p)),
        ],
      ),
    );
  }

  Widget _buildRoleSection(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    Gasfitero? persona,
    required AppColors c,
    required CuadrillaDetalleViewModel vm,
    bool isOptionalLabel = false,
  }) {
    final rolRuta = label.contains('Principal') ? 'LIDER' : label.contains('Chofer') ? 'CHOFER' : 'OPERADOR';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              if (isOptionalLabel) ...[
                const SizedBox(width: 6),
                Text(
                  '(Opcional)',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: c.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(maxWidth: 80, maxHeight: 36),
                icon: Icon(
                  persona != null ? Icons.swap_horiz_rounded : Icons.person_add_rounded,
                  color: c.primary,
                  size: 18,
                ),
                onPressed: () => _mostrarModalAgregar(context, vm, rolRuta),
                tooltip: persona != null ? 'Cambiar' : 'Agregar',
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (persona != null)
            _buildPersonTile(c, vm, persona, canRemove: label != 'Gasfitero Principal'),
          if (persona == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Sin asignar',
                style: TextStyle(color: c.onSurfaceVariant, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonTile(AppColors c, CuadrillaDetalleViewModel vm, Gasfitero p, {bool canRemove = true}) {
    return Card(
      color: c.background,
      margin: const EdgeInsets.only(bottom: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: c.border),
      ),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          backgroundColor: c.primary.withValues(alpha: 0.15),
          radius: 18,
          child: Icon(Icons.person_rounded, color: c.primary, size: 18),
        ),
        title: Text(
          p.nombre ?? '-',
          style: TextStyle(color: c.onSurface, fontFamily: 'Outfit', fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Codigo: ${p.codigoEmpleado ?? '-'}',
          style: TextStyle(color: c.onSurfaceVariant, fontSize: 12),
        ),
        trailing: canRemove
            ? IconButton(
                icon: Icon(Icons.person_remove_rounded, color: const Color(0xFFDC2626), size: 20),
                onPressed: () async {
                  await vm.removePersonal(p.id);
                },
              )
            : null,
      ),
    );
  }

  void _mostrarModalAgregar(
    BuildContext context,
    CuadrillaDetalleViewModel vm,
    String rol,
  ) {
    final c = Theme.of(context).extension<AppColors>()!;
    final idsEnCuadrilla = <int>{};
    if (vm.current.lider != null) idsEnCuadrilla.add(vm.current.lider!.id);
    idsEnCuadrilla.addAll(vm.current.apoyos.map((t) => t.id));
    if (vm.current.chofer != null) idsEnCuadrilla.add(vm.current.chofer!.id);
    if (vm.current.operador != null) idsEnCuadrilla.add(vm.current.operador!.id);
    final disponiblesFiltrados = vm.disponibles
        .where((t) => !idsEnCuadrilla.contains(t.id))
        .where((t) {
          final cargo = (t.cargo ?? '').toUpperCase();
          if (rol == 'LIDER' || rol == 'APOYO') {
            return !cargo.contains('CHOFER') && !cargo.contains('OPERADOR');
          } else if (rol == 'CHOFER') {
            return cargo.contains('CHOFER');
          } else if (rol == 'OPERADOR') {
            return cargo.contains('OPERADOR');
          }
          return true;
        })
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seleccionar Personal',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: c.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Área: ${vm.current.especialidad == 'Agua' ? 'Área de Distribución' : 'Área de Mantenimiento'}',
              style: TextStyle(
                fontSize: 12,
                color: c.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (disponiblesFiltrados.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No hay gasfiteros disponibles',
                          style: TextStyle(color: c.onSurfaceVariant),
                        ),
                      ),
                    ...disponiblesFiltrados.map((t) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: c.primary.withValues(alpha: 0.15),
                            child: Icon(Icons.person_rounded, color: c.primary),
                          ),
                          title: Text(
                            t.nombre ?? '-',
                            style: TextStyle(color: c.onSurface, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Codigo: ${t.codigoEmpleado ?? '-'}',
                            style: TextStyle(color: c.onSurfaceVariant, fontSize: 12),
                          ),
                          onTap: () async {
                            Navigator.pop(ctx);
                            await vm.addPersonal(t.id, rol);
                          },
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, CuadrillaDetalleViewModel vm, AppColors c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.surface,
        title: Text('Eliminar Cuadrilla', style: TextStyle(color: c.onSurface, fontWeight: FontWeight.bold)),
        content: Text(
          '¿Estás seguro de que deseas eliminar esta cuadrilla de forma permanente? Esta acción no se puede deshacer.',
          style: TextStyle(color: c.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar', style: TextStyle(color: c.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final ok = await vm.deleteCuadrilla();
              if (ok && context.mounted) {
                Navigator.pop(context, true); // Retornar true para indicar que se eliminó
              } else if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al eliminar la cuadrilla'), backgroundColor: Color(0xFFDC2626)),
                );
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
