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
            icon: const Icon(Icons.delete_outline_rounded,
                color: Color(0xFFDC2626)),
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
                    color: c.primary,
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
                  if (cu.chofer != null ||
                      vm.choferesDisponibles.isNotEmpty) ...[
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
          _buildInfo(c, 'Identificador', cu.codigoGrupo),
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
            style: TextStyle(
                color: c.onSurface, fontSize: 13, fontWeight: FontWeight.w600),
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
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: c.onSurface,
                      ),
                    ),
                    Text(
                      personas.length == 1
                          ? '1 gasfitero asignado'
                          : '${personas.length} gasfiteros asignados',
                      style: TextStyle(
                        color: c.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: vm.isActionLoading
                    ? null
                    : () => _showSupportManager(context, vm),
                style: OutlinedButton.styleFrom(
                  foregroundColor: c.primary,
                  side: BorderSide(color: c.primary.withValues(alpha: 0.45)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.group_add_outlined, size: 17),
                label: const Text(
                  'GESTIONAR',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: c.border.withValues(alpha: 0.7)),
          const SizedBox(height: 10),
          if (personas.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: c.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.group_off_outlined,
                      color: c.onSurfaceVariant, size: 19),
                  const SizedBox(width: 9),
                  Text(
                    'Aún no hay gasfiteros de apoyo',
                    style: TextStyle(color: c.onSurfaceVariant, fontSize: 12),
                  ),
                ],
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
    final rolRuta = label.contains('Principal') ? 'LIDER' : 'CHOFER';

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
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: c.onSurface,
                      ),
                    ),
                    Text(
                      persona == null ? 'Sin asignar' : 'Responsable principal',
                      style: TextStyle(
                        color: c.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
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
              OutlinedButton.icon(
                onPressed: vm.isActionLoading
                    ? null
                    : () => rolRuta == 'LIDER'
                        ? _showLeaderManager(context, vm)
                        : _mostrarModalAgregar(context, vm, rolRuta),
                style: OutlinedButton.styleFrom(
                  foregroundColor: c.primary,
                  side: BorderSide(color: c.primary.withValues(alpha: 0.45)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(
                  persona != null
                      ? Icons.swap_horiz_rounded
                      : Icons.person_add_alt_1_outlined,
                  size: 17,
                ),
                label: Text(
                  persona != null ? 'CAMBIAR' : 'ASIGNAR',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: c.border.withValues(alpha: 0.7)),
          const SizedBox(height: 10),
          if (persona != null)
            _buildPersonTile(c, vm, persona,
                canRemove: label != 'Gasfitero Principal'),
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

  Widget _buildPersonTile(
      AppColors c, CuadrillaDetalleViewModel vm, Gasfitero p,
      {bool canRemove = true}) {
    final name = p.nombre?.trim().isNotEmpty == true ? p.nombre!.trim() : '-';
    final initials = name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: c.primary.withValues(alpha: 0.13),
            radius: 19,
            child: Text(
              initials,
              style: TextStyle(
                color: c.primary,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: c.onSurface,
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (canRemove)
            IconButton(
              tooltip: 'Retirar de la cuadrilla',
              icon: const Icon(
                Icons.remove_circle_outline_rounded,
                color: Color(0xFFDC2626),
                size: 20,
              ),
              onPressed: vm.isActionLoading
                  ? null
                  : () async {
                      await vm.removePersonal(p.id);
                    },
            ),
        ],
      ),
    );
  }

  void _showSupportManager(
    BuildContext context,
    CuadrillaDetalleViewModel vm,
  ) {
    final c = Theme.of(context).extension<AppColors>()!;
    final initialSelection = vm.current.apoyos.map((p) => p.id).toSet();
    final selectedIds = {...initialSelection};
    var isSaving = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          final hasChanges = !_sameIds(initialSelection, selectedIds);
          return FractionallySizedBox(
            heightFactor: 0.82,
            child: Column(
              children: [
                _buildSheetHandle(c),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSheetIcon(c, Icons.groups_2_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gestionar gasfiteros de apoyo',
                              style: TextStyle(
                                color: c.onSurface,
                                fontFamily: 'Outfit',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Selecciona o retira varios trabajadores y guarda todo en una sola acción.',
                              style: TextStyle(
                                color: c.onSurfaceVariant,
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Cerrar',
                        onPressed:
                            isSaving ? null : () => Navigator.pop(sheetContext),
                        icon: Icon(Icons.close_rounded,
                            color: c.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: c.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.checklist_rounded, color: c.primary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${selectedIds.length} seleccionados',
                          style: TextStyle(
                            color: c.onSurface,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: isSaving || selectedIds.isEmpty
                            ? null
                            : () => setSheetState(selectedIds.clear),
                        child: const Text('QUITAR TODOS'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: vm.candidatosApoyo.isEmpty
                      ? _buildEmptyPersonnel(c)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                          itemCount: vm.candidatosApoyo.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, index) {
                            final person = vm.candidatosApoyo[index];
                            final selected = selectedIds.contains(person.id);
                            return _buildSelectablePerson(
                              c: c,
                              person: person,
                              selected: selected,
                              multiple: true,
                              onTap: isSaving
                                  ? null
                                  : () => setSheetState(() {
                                        if (selected) {
                                          selectedIds.remove(person.id);
                                        } else {
                                          selectedIds.add(person.id);
                                        }
                                      }),
                            );
                          },
                        ),
                ),
                _buildSheetActionArea(
                  c: c,
                  label: 'GUARDAR CAMBIOS (${selectedIds.length})',
                  isSaving: isSaving,
                  enabled: hasChanges,
                  onPressed: () async {
                    setSheetState(() => isSaving = true);
                    final ok = await vm.updateSupports(selectedIds);
                    if (!sheetContext.mounted) return;
                    if (ok) {
                      Navigator.pop(sheetContext);
                    } else {
                      setSheetState(() => isSaving = false);
                      _showActionError(sheetContext, vm.actionError);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLeaderManager(
    BuildContext context,
    CuadrillaDetalleViewModel vm,
  ) {
    final c = Theme.of(context).extension<AppColors>()!;
    final initialLeaderId = vm.current.lider?.id;
    var selectedId = initialLeaderId;
    var isSaving = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          return FractionallySizedBox(
            heightFactor: 0.78,
            child: Column(
              children: [
                _buildSheetHandle(c),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSheetIcon(c, Icons.star_outline_rounded),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cambiar gasfitero principal',
                              style: TextStyle(
                                color: c.onSurface,
                                fontFamily: 'Outfit',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Solo puede existir un líder. El principal actual pasará a apoyo automáticamente.',
                              style: TextStyle(
                                color: c.onSurfaceVariant,
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Cerrar',
                        onPressed:
                            isSaving ? null : () => Navigator.pop(sheetContext),
                        icon: Icon(Icons.close_rounded,
                            color: c.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: c.border),
                Expanded(
                  child: vm.candidatosLider.isEmpty
                      ? _buildEmptyPersonnel(c)
                      : ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: vm.candidatosLider.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, index) {
                            final person = vm.candidatosLider[index];
                            final selected = selectedId == person.id;
                            return _buildSelectablePerson(
                              c: c,
                              person: person,
                              selected: selected,
                              multiple: false,
                              badge: person.id == initialLeaderId
                                  ? 'ACTUAL'
                                  : vm.current.apoyos.any(
                                      (support) => support.id == person.id,
                                    )
                                      ? 'APOYO ACTUAL'
                                      : null,
                              onTap: isSaving
                                  ? null
                                  : () => setSheetState(
                                        () => selectedId = person.id,
                                      ),
                            );
                          },
                        ),
                ),
                _buildSheetActionArea(
                  c: c,
                  label: 'CONFIRMAR NUEVO PRINCIPAL',
                  isSaving: isSaving,
                  enabled: selectedId != null && selectedId != initialLeaderId,
                  onPressed: () async {
                    final leaderId = selectedId;
                    if (leaderId == null) return;
                    setSheetState(() => isSaving = true);
                    final ok = await vm.changeLeader(leaderId);
                    if (!sheetContext.mounted) return;
                    if (ok) {
                      Navigator.pop(sheetContext);
                    } else {
                      setSheetState(() => isSaving = false);
                      _showActionError(sheetContext, vm.actionError);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSheetHandle(AppColors c) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: c.onSurfaceVariant.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildSheetIcon(AppColors c, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: c.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, color: c.primary, size: 22),
    );
  }

  Widget _buildSelectablePerson({
    required AppColors c,
    required Gasfitero person,
    required bool selected,
    required bool multiple,
    required VoidCallback? onTap,
    String? badge,
  }) {
    final name = person.nombre?.trim().isNotEmpty == true
        ? person.nombre!.trim()
        : 'Sin nombre';
    final initials = name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? c.primary.withValues(alpha: 0.09) : c.background,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected ? c.primary : c.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 21,
              backgroundColor: selected
                  ? c.primary.withValues(alpha: 0.18)
                  : c.onSurface.withValues(alpha: 0.08),
              child: Text(
                initials,
                style: TextStyle(
                  color: selected ? c.primary : c.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: c.onSurface,
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      badge,
                      style: TextStyle(
                        color: c.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (multiple)
              Checkbox(
                value: selected,
                onChanged: onTap == null ? null : (_) => onTap(),
                activeColor: c.primary,
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? c.primary : c.onSurfaceVariant,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: selected
                    ? Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: c.primary,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPersonnel(AppColors c) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_off_outlined, color: c.onSurfaceVariant, size: 38),
            const SizedBox(height: 10),
            Text(
              'No hay personal disponible',
              style: TextStyle(
                color: c.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetActionArea({
    required AppColors c,
    required String label,
    required bool isSaving,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: FilledButton(
          onPressed: enabled && !isSaving ? onPressed : null,
          style: FilledButton.styleFrom(
            backgroundColor: c.primary,
            foregroundColor: c.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isSaving
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: c.onPrimary,
                  ),
                )
              : Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  bool _sameIds(Set<int> a, Set<int> b) {
    return a.length == b.length && a.containsAll(b);
  }

  void _showActionError(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'No se pudo actualizar la cuadrilla.'),
        backgroundColor: const Color(0xFFDC2626),
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
    final disponiblesFiltrados =
        vm.disponibles.where((t) => !idsEnCuadrilla.contains(t.id)).where((t) {
      if (rol == 'LIDER' || rol == 'APOYO') {
        return t.puedeSerGasfitero;
      } else if (rol == 'CHOFER') {
        return t.puedeSerChofer;
      }
      return true;
    }).toList();

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
              'Cuadrilla de ${vm.current.especialidad ?? 'tipo no definido'}',
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
                            style: TextStyle(
                                color: c.onSurface,
                                fontWeight: FontWeight.bold),
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

  void _confirmDelete(
      BuildContext context, CuadrillaDetalleViewModel vm, AppColors c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.surface,
        title: Text('Eliminar Cuadrilla',
            style: TextStyle(color: c.onSurface, fontWeight: FontWeight.bold)),
        content: Text(
          '¿Estás seguro de que deseas eliminar esta cuadrilla de forma permanente? Esta acción no se puede deshacer.',
          style: TextStyle(color: c.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Cancelar', style: TextStyle(color: c.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final ok = await vm.deleteCuadrilla();
              if (ok && context.mounted) {
                Navigator.pop(
                    context, true); // Retornar true para indicar que se eliminó
              } else if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Error al eliminar la cuadrilla'),
                      backgroundColor: Color(0xFFDC2626)),
                );
              }
            },
            child: const Text('Eliminar',
                style: TextStyle(
                    color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
