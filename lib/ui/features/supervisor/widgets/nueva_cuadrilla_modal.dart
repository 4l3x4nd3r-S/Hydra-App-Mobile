import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/supervisor_repository.dart';
import '../../../../domain/models/gasfitero.dart';
import '../../../core/theme/app_colors.dart';
import '../view_models/nueva_cuadrilla_view_model.dart';

Future<bool?> showNuevaCuadrillaModal(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).extension<AppColors>()!.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ChangeNotifierProvider(
      create: (_) => NuevaCuadrillaViewModel(
        supervisorRepository: context.read<SupervisorRepository>(),
      ),
      child: const _NuevaCuadrillaModal(),
    ),
  );
}

class _NuevaCuadrillaModal extends StatelessWidget {
  const _NuevaCuadrillaModal();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.watch<NuevaCuadrillaViewModel>();
    final insets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(bottom: insets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'FORMULARIO DE NUEVA CUADRILLA',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: c.onSurface,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('Especialidad', c),
            const SizedBox(height: 6),
            Row(
              children: EspecialidadOption.all
                  .map(
                    (opcion) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: opcion == EspecialidadOption.agua ? 8.0 : 0,
                        ),
                        child: _buildEspecialidadChip(vm, opcion, c),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            if (vm.loadingGasfiteros)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: CircularProgressIndicator(color: c.primary),
                ),
              )
            else ...[
              _buildPersonSelector(
                context,
                vm: vm,
                c: c,
                icon: Icons.star_rounded,
                label: 'Gasfitero Principal',
                color: c.primary,
                persona: vm.lider,
                onSelect: (t) => vm.setLider(t),
                required: true,
                list: vm.gasfiterosDisponiblesParaRol,
              ),
              const SizedBox(height: 14),
              _buildMultiPersonSelector(
                context,
                vm: vm,
                c: c,
                icon: Icons.engineering_rounded,
                label: 'Gasfiteros de Apoyo',
                color: const Color(0xFF64748B),
                selected: vm.apoyos,
              ),
              if (vm.especialidad.value == 'Agua' &&
                  vm.operadoresDisponibles.isNotEmpty) ...[
                const SizedBox(height: 14),
                _buildPersonSelector(
                  context,
                  vm: vm,
                  c: c,
                  icon: Icons.settings_applications_rounded,
                  label: 'Operador',
                  color: const Color(0xFF0F766E),
                  persona: vm.operador,
                  onSelect: (t) => vm.setOperador(t),
                  required: false,
                  optional: true,
                  list: vm.operadoresDisponibles,
                ),
              ],
              if (vm.especialidad.value == 'Desagüe' &&
                  vm.choferesDisponibles.isNotEmpty) ...[
                const SizedBox(height: 14),
                _buildPersonSelector(
                  context,
                  vm: vm,
                  c: c,
                  icon: Icons.local_shipping_rounded,
                  label: 'Chofer',
                  color: const Color(0xFFB45309),
                  persona: vm.chofer,
                  onSelect: (t) => vm.setChofer(t),
                  required: false,
                  optional: true,
                  list: vm.choferesDisponibles,
                ),
              ],
            ],
            if (vm.errorMsg != null) ...[
              const SizedBox(height: 12),
              Text(
                vm.errorMsg!,
                style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.primary,
                  disabledBackgroundColor: c.primary.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: vm.canSubmit && !vm.submitting
                    ? () async {
                        final ok = await vm.submit();
                        if (!context.mounted) return;
                        if (ok) Navigator.of(context).pop(true);
                      }
                    : null,
                child: vm.submitting
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: c.onPrimary,
                          strokeWidth: 2.4,
                        ),
                      )
                    : Text(
                        'CREAR CUADRILLA',
                        style: TextStyle(
                          color: c.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Outfit',
                          letterSpacing: 0.6,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, AppColors c) {
    return Text(
      text,
      style: TextStyle(
        color: c.onSurfaceVariant,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
        letterSpacing: 0.4,
      ),
    );
  }

  Widget _buildEspecialidadChip(
    NuevaCuadrillaViewModel vm,
    EspecialidadOption opcion,
    AppColors c,
  ) {
    final selected = vm.especialidad.value == opcion.value;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => vm.setEspecialidad(opcion),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? c.primary.withValues(alpha: 0.10) : c.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? c.primary : c.border,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Center(
          child: Text(
            opcion.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Outfit',
              color: selected ? c.primary : c.onSurfaceVariant,
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonSelector(
    BuildContext ctx, {
    required NuevaCuadrillaViewModel vm,
    required AppColors c,
    required IconData icon,
    required String label,
    required Color color,
    Gasfitero? persona,
    required void Function(Gasfitero?) onSelect,
    bool required = false,
    bool optional = false,
    required List<Gasfitero> list,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
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
                  letterSpacing: 0.4,
                ),
              ),
            ),
            if (optional) ...[
              const SizedBox(width: 4),
              Text(
                '(Opcional)',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: c.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _showSelector(
            ctx,
            vm,
            c,
            label,
            persona,
            onSelect,
            list,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: c.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: required && persona == null
                    ? const Color(0xFFDC2626).withValues(alpha: 0.5)
                    : c.border,
              ),
            ),
            child: persona != null
                ? Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.15),
                        radius: 18,
                        child: Text(
                          _initials(persona.nombre),
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              persona.nombre ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: c.onSurface,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Toca para cambiar',
                              style: TextStyle(
                                color: c.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.edit_rounded, color: color, size: 18),
                    ],
                  )
                : Row(
                    children: [
                      Icon(Icons.person_add_rounded,
                          color: c.onSurfaceVariant, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Seleccionar...',
                        style:
                            TextStyle(color: c.onSurfaceVariant, fontSize: 13),
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right_rounded,
                          color: c.onSurfaceVariant, size: 20),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiPersonSelector(
    BuildContext ctx, {
    required NuevaCuadrillaViewModel vm,
    required AppColors c,
    required IconData icon,
    required String label,
    required Color color,
    required List<Gasfitero> selected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
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
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: c.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.border),
          ),
          child: Column(
            children: [
              if (selected.isNotEmpty)
                ...selected.map(
                  (persona) => Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: color.withValues(alpha: 0.14),
                          child: Text(
                            _initials(persona.nombre),
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            persona.nombre ?? 'Sin nombre',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: c.onSurface,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Quitar apoyo',
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            Icons.close_rounded,
                            color: c.onSurfaceVariant,
                            size: 18,
                          ),
                          onPressed: () => vm.toggleApoyo(persona),
                        ),
                      ],
                    ),
                  ),
                ),
              if (selected.isNotEmpty) Divider(height: 1, color: c.border),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _showMultiSelector(ctx, vm, c),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  child: Row(
                    children: [
                      Icon(
                        selected.isEmpty
                            ? Icons.group_add_rounded
                            : Icons.edit_rounded,
                        color: c.primary,
                        size: 19,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selected.isEmpty
                                  ? 'Seleccionar gasfiteros'
                                  : 'Editar selección',
                              style: TextStyle(
                                color: c.onSurface,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (selected.isEmpty)
                              Text(
                                'Elige uno o más integrantes de apoyo',
                                style: TextStyle(
                                  color: c.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (selected.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: c.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${selected.length}',
                            style: TextStyle(
                              color: c.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: c.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _initials(String? name) {
    final parts = (name ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2);
    final initials = parts.map((part) => part[0]).join().toUpperCase();
    return initials.isEmpty ? '—' : initials;
  }

  Future<void> _showSelector(
    BuildContext ctx,
    NuevaCuadrillaViewModel vm,
    AppColors c,
    String title,
    Gasfitero? current,
    void Function(Gasfitero?) onSelect,
    List<Gasfitero> gasfiteros,
  ) async {
    final searchController = TextEditingController();
    final candidates = <Gasfitero>[
      if (current != null) current,
      ...gasfiteros.where((persona) => persona.id != current?.id),
    ]..sort((a, b) => (a.nombre ?? '')
        .toLowerCase()
        .compareTo((b.nombre ?? '').toLowerCase()));
    int? selectedId = current?.id;

    await showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: c.surface,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(ctx).size.height * 0.82,
      ),
      builder: (subCtx) => StatefulBuilder(
        builder: (modalContext, setModalState) {
          final query = searchController.text.trim().toLowerCase();
          final filtered = query.isEmpty
              ? candidates
              : candidates
                  .where(
                    (persona) =>
                        (persona.nombre ?? '').toLowerCase().contains(query),
                  )
                  .toList();

          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              10,
              20,
              16 + MediaQuery.of(modalContext).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seleccionar $title',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: c.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Solo puedes seleccionar una persona · ${vm.especialidad.label}',
                            style: TextStyle(
                              fontSize: 12,
                              color: c.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cerrar',
                      onPressed: () => Navigator.pop(modalContext),
                      icon: Icon(
                        Icons.close_rounded,
                        color: c.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: searchController,
                  onChanged: (_) => setModalState(() {}),
                  style: TextStyle(color: c.onSurface, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre',
                    hintStyle: TextStyle(color: c.onSurfaceVariant),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: c.onSurfaceVariant,
                    ),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpiar búsqueda',
                            onPressed: () {
                              searchController.clear();
                              setModalState(() {});
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: c.onSurfaceVariant,
                            ),
                          ),
                    filled: true,
                    fillColor: c.background,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: c.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: c.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: c.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                query.isEmpty
                                    ? Icons.person_off_outlined
                                    : Icons.search_off_rounded,
                                color: c.onSurfaceVariant,
                                size: 36,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                query.isEmpty
                                    ? 'No hay gasfiteros disponibles'
                                    : 'No se encontraron resultados',
                                style: TextStyle(color: c.onSurfaceVariant),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: c.border),
                          itemBuilder: (context, index) {
                            final persona = filtered[index];
                            final isSelected = selectedId == persona.id;
                            return InkWell(
                              onTap: () => setModalState(() {
                                selectedId = persona.id;
                              }),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          c.primary.withValues(alpha: 0.12),
                                      child: Text(
                                        _initials(persona.nombre),
                                        style: TextStyle(
                                          color: c.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        persona.nombre ?? 'Sin nombre',
                                        style: TextStyle(
                                          color: c.onSurface,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 160),
                                      width: 22,
                                      height: 22,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? c.primary
                                              : c.onSurfaceVariant,
                                          width: isSelected ? 2 : 1.5,
                                        ),
                                      ),
                                      child: isSelected
                                          ? DecoratedBox(
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
                          },
                        ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(modalContext),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: c.onSurface,
                          side: BorderSide(color: c.border),
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: selectedId == null
                            ? null
                            : () {
                                final selected = candidates.firstWhere(
                                  (persona) => persona.id == selectedId,
                                );
                                onSelect(selected);
                                Navigator.pop(modalContext);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.primary,
                          foregroundColor: c.onPrimary,
                          disabledBackgroundColor:
                              c.primary.withValues(alpha: 0.35),
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirmar selección',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    searchController.dispose();
  }

  Future<void> _showMultiSelector(
    BuildContext ctx,
    NuevaCuadrillaViewModel vm,
    AppColors c,
  ) async {
    final searchController = TextEditingController();
    final gasfiteros = [...vm.gasfiterosDisponiblesParaApoyos]..sort((a, b) =>
        (a.nombre ?? '')
            .toLowerCase()
            .compareTo((b.nombre ?? '').toLowerCase()));
    final selectedIds = vm.apoyos.map((persona) => persona.id).toSet();

    await showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: c.surface,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(ctx).size.height * 0.82,
      ),
      builder: (subCtx) => StatefulBuilder(
        builder: (modalContext, setModalState) {
          final query = searchController.text.trim().toLowerCase();
          final filtered = query.isEmpty
              ? gasfiteros
              : gasfiteros
                  .where(
                    (persona) =>
                        (persona.nombre ?? '').toLowerCase().contains(query),
                  )
                  .toList();

          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              10,
              20,
              16 + MediaQuery.of(modalContext).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gasfiteros de apoyo',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: c.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            selectedIds.isEmpty
                                ? 'Selecciona uno o más integrantes'
                                : '${selectedIds.length} seleccionado${selectedIds.length == 1 ? '' : 's'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: c.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cerrar',
                      onPressed: () => Navigator.pop(modalContext),
                      icon: Icon(
                        Icons.close_rounded,
                        color: c.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: searchController,
                  onChanged: (_) => setModalState(() {}),
                  style: TextStyle(color: c.onSurface, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre',
                    hintStyle: TextStyle(color: c.onSurfaceVariant),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: c.onSurfaceVariant,
                    ),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpiar búsqueda',
                            onPressed: () {
                              searchController.clear();
                              setModalState(() {});
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: c.onSurfaceVariant,
                            ),
                          ),
                    filled: true,
                    fillColor: c.background,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: c.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: c.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: c.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                query.isEmpty
                                    ? Icons.group_off_outlined
                                    : Icons.search_off_rounded,
                                color: c.onSurfaceVariant,
                                size: 36,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                query.isEmpty
                                    ? 'No hay gasfiteros disponibles'
                                    : 'No se encontraron resultados',
                                style: TextStyle(color: c.onSurfaceVariant),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: c.border),
                          itemBuilder: (context, index) {
                            final persona = filtered[index];
                            final isSelected = selectedIds.contains(persona.id);
                            return InkWell(
                              onTap: () => setModalState(() {
                                if (isSelected) {
                                  selectedIds.remove(persona.id);
                                } else {
                                  selectedIds.add(persona.id);
                                }
                              }),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          c.primary.withValues(alpha: 0.12),
                                      child: Text(
                                        _initials(persona.nombre),
                                        style: TextStyle(
                                          color: c.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        persona.nombre ?? 'Sin nombre',
                                        style: TextStyle(
                                          color: c.onSurface,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Checkbox(
                                      value: isSelected,
                                      activeColor: c.primary,
                                      onChanged: (_) => setModalState(() {
                                        if (isSelected) {
                                          selectedIds.remove(persona.id);
                                        } else {
                                          selectedIds.add(persona.id);
                                        }
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(modalContext),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: c.onSurface,
                          side: BorderSide(color: c.border),
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          vm.setApoyos(
                            gasfiteros.where(
                              (persona) => selectedIds.contains(persona.id),
                            ),
                          );
                          Navigator.pop(modalContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.primary,
                          foregroundColor: c.onPrimary,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          selectedIds.isEmpty
                              ? 'Confirmar'
                              : 'Confirmar (${selectedIds.length})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    searchController.dispose();
  }
}
