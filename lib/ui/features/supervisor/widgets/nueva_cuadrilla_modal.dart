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
            _buildLabel('Nombre de la Cuadrilla', c),
            const SizedBox(height: 6),
            TextField(
              controller: vm.nombreController,
              style: TextStyle(color: c.onSurface),
              decoration: InputDecoration(
                hintText: 'Ej: Grupo 1, Cuadrilla Alfa',
                hintStyle: TextStyle(
                  color: c.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: c.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: c.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: c.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLabel('Especialidad / Área', c),
            const SizedBox(height: 6),
            Row(
              children: EspecialidadOption.all.map(
                (opcion) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: opcion == EspecialidadOption.distribucion ? 8.0 : 0,
                    ),
                    child: _buildEspecialidadChip(vm, opcion, c),
                  ),
                ),
              ).toList(),
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
                color: const Color(0xFF0A2472),
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
                onToggle: (t) => vm.toggleApoyo(t),
              ),
              if (vm.especialidad.value == 'Agua' && vm.operadoresDisponibles.isNotEmpty) ...[
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
              if (vm.especialidad.value == 'Desagüe' && vm.choferesDisponibles.isNotEmpty) ...[
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
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.4,
                        ),
                      )
                    : const Text(
                        'CREAR CUADRILLA',
                        style: TextStyle(
                          color: Colors.white,
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
          onTap: () => _showSelector(ctx, vm, c, label, (t) {
            onSelect(t);
            Navigator.pop(ctx);
          }, list),
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
                        radius: 16,
                        child: Icon(Icons.person, color: color, size: 16),
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
                            if (persona.codigoEmpleado != null)
                              Text(
                                persona.codigoEmpleado!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: c.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: c.onSurfaceVariant, size: 20),
                    ],
                  )
                : Row(
                    children: [
                      Icon(Icons.person_add_rounded, color: c.onSurfaceVariant, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Seleccionar...',
                        style: TextStyle(color: c.onSurfaceVariant, fontSize: 13),
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right_rounded, color: c.onSurfaceVariant, size: 20),
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
    required void Function(Gasfitero) onToggle,
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
        if (selected.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: selected
                  .map((t) => Chip(
                        backgroundColor: color.withValues(alpha: 0.1),
                        side: BorderSide(color: color.withValues(alpha: 0.3)),
                        label: Text(
                          t.nombre ?? '',
                          style: TextStyle(fontSize: 11, color: color),
                        ),
                        deleteIcon: Icon(Icons.close_rounded, size: 16, color: color),
                        onDeleted: () => onToggle(t),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
          ),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _showMultiSelector(ctx, vm, c, onToggle),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: c.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: c.border),
            ),
            child: Row(
              children: [
                Icon(Icons.person_add_rounded, color: c.onSurfaceVariant, size: 18),
                const SizedBox(width: 8),
                Text(
                  selected.isEmpty ? 'Agregar apoyos (+)' : 'Gestionar apoyos',
                  style: TextStyle(color: c.onSurfaceVariant, fontSize: 13),
                ),
                const Spacer(),
                if (selected.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${selected.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, color: c.onSurfaceVariant, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSelector(
    BuildContext ctx,
    NuevaCuadrillaViewModel vm,
    AppColors c,
    String title,
    void Function(Gasfitero) onSelect,
    List<Gasfitero> gasfiteros,
  ) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(ctx).size.height * 0.75,
      ),
      builder: (subCtx) => ChangeNotifierProvider.value(
        value: vm,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Seleccionar $title',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: c.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Área: ${vm.especialidad.label}',
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
                    children: [
                      if (gasfiteros.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No hay gasfiteros disponibles',
                            style: TextStyle(color: c.onSurfaceVariant),
                          ),
                        ),
                      ...gasfiteros.map((t) => ListTile(
                            leading: CircleAvatar(
                              backgroundColor: c.primary.withValues(alpha: 0.15),
                              child: Icon(Icons.person, color: c.primary),
                            ),
                            title: Text(
                              t.nombre ?? '-',
                              style: TextStyle(color: c.onSurface, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              t.codigoEmpleado ?? '',
                              style: TextStyle(color: c.onSurfaceVariant, fontSize: 12),
                            ),
                            onTap: () => onSelect(t),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showMultiSelector(
    BuildContext ctx,
    NuevaCuadrillaViewModel vm,
    AppColors c,
    void Function(Gasfitero) onToggle,
  ) {
    final gasfiteros = vm.gasfiterosDisponiblesParaApoyos;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(ctx).size.height * 0.75,
      ),
      builder: (subCtx) => ChangeNotifierProvider.value(
        value: vm,
        child: Consumer<NuevaCuadrillaViewModel>(
          builder: (consumerCtx, consumerVm, _) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seleccionar Apoyos',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: c.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Área: ${vm.especialidad.label}',
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
                        if (gasfiteros.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'No hay mas gasfiteros disponibles',
                              style: TextStyle(color: c.onSurfaceVariant),
                            ),
                          ),
                        ...gasfiteros.map((t) {
                          final estaSeleccionado =
                              consumerVm.apoyos.any((e) => e.id == t.id);
                          return CheckboxListTile(
                            activeColor: c.primary,
                            value: estaSeleccionado,
                            onChanged: (_) => onToggle(t),
                            title: Text(
                              t.nombre ?? '-',
                              style: TextStyle(
                                  color: c.onSurface, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              t.codigoEmpleado ?? '',
                              style:
                                  TextStyle(color: c.onSurfaceVariant, fontSize: 12),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
