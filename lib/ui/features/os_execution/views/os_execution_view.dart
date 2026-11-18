import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/models/os.dart';
import '../../../../domain/use_cases/save_os_report_use_case.dart';
import '../../../../data/services/sync_queue_storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../view_models/os_execution_view_model.dart';
import '../../os_detail/widgets/os_detail_section.dart';
import '../widgets/execution_step_card.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../widgets/execution_location_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/widgets/voice_text_field.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';

class OsExecutionView extends StatelessWidget {
  final Os os;

  const OsExecutionView({super.key, required this.os});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OsExecutionViewModel(
        os: os,
        saveOsReportUseCase: context.read<SaveOsReportUseCase>(),
        syncQueueStorageService: context.read<SyncQueueStorageService>(),
      ),
      child: const _OsExecutionBody(),
    );
  }
}

class _OsExecutionBody extends StatefulWidget {
  const _OsExecutionBody();

  @override
  State<_OsExecutionBody> createState() => _OsExecutionBodyState();
}

class _OsExecutionBodyState extends State<_OsExecutionBody> {
  final ScrollController _scrollController = ScrollController();

  /// Ancla de cada paso para poder desplazarse al que acaba de aparecer.
  final Map<int, GlobalKey> _stepKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
    4: GlobalKey(),
  };

  int? _ultimoPaso;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Desplaza la vista hasta un paso concreto.
  void _desplazarAPaso(int paso) {
    final ctx = _stepKeys[paso]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      alignment: 0.08,
    );
  }

  /// Cuando se desbloquea un paso nuevo se desplaza la vista hasta él para que
  /// el técnico vea de inmediato el siguiente bloque a completar.
  void _sincronizarPaso(int paso) {
    if (_ultimoPaso == null) {
      _ultimoPaso = paso;
      return;
    }
    if (paso <= _ultimoPaso!) return;
    _ultimoPaso = paso;
    // Do not move the work description out of view while it is being typed.
    if (paso == 4 && FocusManager.instance.primaryFocus?.hasFocus == true) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _stepKeys[paso]?.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        alignment: 0.08,
      );
    });
  }

  static const _stepTitles = [
    'Ubicación del trabajo',
    'Fotos del problema',
    'Fotos de la solución',
    'Trabajo realizado',
    'Cierre y conformidad',
  ];

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.watch<OsExecutionViewModel>();
    final os = vm.os;
    final pending = vm.pasoPendiente;
    if (vm.isDraftLoaded) _sincronizarPaso(vm.pasoDesbloqueado);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Volver',
          icon: Icon(Icons.arrow_back_ios_rounded, color: c.primary),
          onPressed: vm.isSubmitting ? null : () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Solución de la orden de servicio',
                maxLines: 2,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: c.onSurface)),
            Text('O.S. N.° ${os.numeroOrden ?? os.id}',
                style: TextStyle(fontSize: 13, color: c.onSurfaceVariant)),
          ],
        ),
        toolbarHeight: (MediaQuery.textScalerOf(context).scale(17) * 2.5 +
                MediaQuery.textScalerOf(context).scale(13) * 1.5 +
                16)
            .clamp(76, 160)
            .toDouble(),
      ),
      body: SafeArea(
        top: false,
        child: vm.isDraftLoaded
            ? AbsorbPointer(
                absorbing: vm.isSubmitting,
                child: Column(
                  children: [
                    _buildProgress(c, vm),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 760),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    title: Text(
                                      'Detalles de la orden',
                                      style: TextStyle(
                                          color: c.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    iconColor: c.primary,
                                    collapsedIconColor: c.primary,
                                    tilePadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 0),
                                    childrenPadding:
                                        const EdgeInsets.only(bottom: 16),
                                    collapsedBackgroundColor: c.surface,
                                    backgroundColor: c.surface,
                                    collapsedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: c.border),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: c.primary),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Column(
                                          children: [
                                            _buildReclamoSection(c, os),
                                            const SizedBox(height: 12),
                                            _buildCuadrillaSection(c, os),
                                            const SizedBox(height: 12),
                                            _buildResponsablesSection(c, os),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (vm.fechaInicio == null)
                                  _buildBigActionButton(
                                    c: c,
                                    icon: Icons.play_arrow_rounded,
                                    label: 'Iniciar tarea',
                                    onPressed: vm.iniciarAhora,
                                    isPrimary: true,
                                  )
                                else
                                  _buildEditableTimePicker(
                                    context,
                                    c,
                                    'Hora de inicio',
                                    vm.fechaInicio,
                                    (date) {
                                      final updated =
                                          vm.updateFechaInicio(date);
                                      if (!updated && vm.errorMsg != null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(vm.errorMsg!)));
                                      }
                                      return updated;
                                    },
                                    baseDate: vm.fechaInicio ?? DateTime.now(),
                                  ),
                                const SizedBox(height: 16),
                                ExecutionStepCard(
                                  key: _stepKeys[0],
                                  number: 1,
                                  title: _stepTitles[0],
                                  completed: vm.ubicacionRegistrada,
                                  confirmed: vm.pasoConfirmado(0),
                                  active: pending == 0,
                                  available: true,
                                  hasError:
                                      vm.showValidationErrors && pending == 0,
                                  errorMessage: vm.mensajePendiente,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _buildLocation(c, vm),
                                      _buildConfirmStep(
                                        c: c,
                                        vm: vm,
                                        paso: 0,
                                        label: 'Confirmar ubicación',
                                      ),
                                    ],
                                  ),
                                ),
                                for (final step in [1, 2])
                                  ExecutionStepCard(
                                    key: _stepKeys[step],
                                    number: step + 1,
                                    title: _stepTitles[step],
                                    completed: (step == 1
                                            ? vm.fotosProblema
                                            : vm.fotosSolucion)
                                        .isNotEmpty,
                                    confirmed: vm.pasoConfirmado(step),
                                    active: pending == step,
                                    available: vm.pasoDesbloqueado >= step,
                                    hasError: vm.showValidationErrors &&
                                        pending == step,
                                    errorMessage: vm.mensajePendiente,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        _buildPhotoEvidenceSection(
                                          c: c,
                                          title: _stepTitles[step],
                                          photos: step == 1
                                              ? vm.fotosProblema
                                              : vm.fotosSolucion,
                                          onAdd: () => _showImageSourceSheet(
                                              context,
                                              step == 1
                                                  ? vm.takeFotoProblema
                                                  : vm.takeFotoSolucion),
                                          onRemove: step == 1
                                              ? vm.removeFotoProblema
                                              : vm.removeFotoSolucion,
                                          firstPhotoLabel: 'Añadir foto',
                                          hasError: vm.showValidationErrors &&
                                              pending == step,
                                        ),
                                        _buildConfirmStep(
                                          c: c,
                                          vm: vm,
                                          paso: step,
                                          label: step == 1
                                              ? 'Confirmar fotos del problema'
                                              : 'Confirmar fotos de la solución',
                                        ),
                                      ],
                                    ),
                                  ),
                                ExecutionStepCard(
                                  key: _stepKeys[3],
                                  number: 4,
                                  title: _stepTitles[3],
                                  completed: vm.trabajoEjecutadoController.text
                                      .trim()
                                      .isNotEmpty,
                                  confirmed: vm.pasoConfirmado(3),
                                  active: pending == 3,
                                  available: vm.mostrarTrabajo,
                                  hasError:
                                      vm.showValidationErrors && pending == 3,
                                  errorMessage: vm.mensajePendiente,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _buildTextField(
                                        c: c,
                                        controller:
                                            vm.trabajoEjecutadoController,
                                        label:
                                            'Trabajo ejecutado (obligatorio)',
                                        hint: 'Describa el trabajo ejecutado',
                                        maxLines: 3,
                                        hasError: vm.showValidationErrors &&
                                            pending == 3,
                                      ),
                                      const SizedBox(height: 12),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent),
                                        child: ExpansionTile(
                                          title: Text(
                                              'Información Adicional (Opcional)',
                                              style: TextStyle(
                                                  color: c.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                          iconColor: c.primary,
                                          collapsedIconColor: c.primary,
                                          tilePadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 0),
                                          childrenPadding:
                                              const EdgeInsets.only(
                                                  top: 12, bottom: 12),
                                          collapsedShape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(color: c.border),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(color: c.primary),
                                          ),
                                          backgroundColor: c.surface,
                                          collapsedBackgroundColor: c.surface,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: Column(
                                                children: [
                                                  _buildTextField(
                                                    c: c,
                                                    controller: vm
                                                        .problemasSolucionesController,
                                                    label:
                                                        'Problemas / Soluciones',
                                                    hint:
                                                        'Describa los problemas y soluciones...',
                                                    maxLines: 3,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  _buildTextField(
                                                    c: c,
                                                    controller:
                                                        vm.insumosController,
                                                    label: 'Insumos utilizados',
                                                    hint:
                                                        'Describa los insumos...',
                                                    maxLines: 2,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  _buildTextField(
                                                    c: c,
                                                    controller: vm
                                                        .comentariosInstruccionesController,
                                                    label:
                                                        'Comentarios Especiales',
                                                    hint:
                                                        'Agregue comentarios...',
                                                    maxLines: 2,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  _buildTextField(
                                                    c: c,
                                                    controller: vm
                                                        .observacionesController,
                                                    label: 'Observaciones',
                                                    hint:
                                                        'Observaciones generales...',
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      _buildConfirmStep(
                                        c: c,
                                        vm: vm,
                                        paso: 3,
                                        label: 'Confirmar trabajo ejecutado',
                                      ),
                                    ],
                                  ),
                                ),
                                ExecutionStepCard(
                                  key: _stepKeys[4],
                                  number: 5,
                                  title: _stepTitles[4],
                                  completed: vm.fechaFin != null,
                                  confirmed: vm.pasoConfirmado(4),
                                  active: pending == 4,
                                  available: vm.mostrarCierre,
                                  collapseOnConfirm: false,
                                  hasError:
                                      vm.showValidationErrors && pending == 4,
                                  errorMessage: vm.mensajePendiente,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _buildEditableTimePicker(
                                        context,
                                        c,
                                        'Hora de finalización',
                                        vm.fechaFin,
                                        (date) {
                                          vm.updateFechaFin(date);
                                          return true;
                                        },
                                        baseDate: vm.fechaFin ?? DateTime.now(),
                                        minimumDate: vm.fechaInicio,
                                        hasError: vm.showValidationErrors &&
                                            pending == 4,
                                      ),
                                      const SizedBox(height: 12),
                                      Text('Firma de conformidad (opcional)',
                                          style: TextStyle(
                                              color: c.onSurfaceVariant,
                                              fontSize: 14)),
                                      const SizedBox(height: 12),
                                      if (vm.userSignature != null) ...[
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: c.surface,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(color: c.border),
                                          ),
                                          child: Column(
                                            children: [
                                              Text('Firma del Usuario',
                                                  style: TextStyle(
                                                      color: c.onSurfaceVariant,
                                                      fontSize: 13)),
                                              const SizedBox(height: 8),
                                              Container(
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Image.memory(
                                                    vm.userSignature!,
                                                    fit: BoxFit.contain),
                                              ),
                                              const SizedBox(height: 8),
                                              TextButton.icon(
                                                onPressed: () {
                                                  vm.setSignature(null);
                                                  // Limpiar el archivo temporal
                                                  getTemporaryDirectory()
                                                      .then((tempDir) {
                                                    final file = File(
                                                        '${tempDir.path}/signature_${vm.os.id}.png');
                                                    if (file.existsSync()) {
                                                      file.deleteSync();
                                                    }
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.delete_outline,
                                                    size: 18),
                                                label: const Text(
                                                    'Eliminar firma'),
                                                style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        const Color(
                                                            0xFFDC2626)),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: c.primary,
                                            minimumSize: const Size(0, 54),
                                            padding: const EdgeInsets.all(14),
                                            side: BorderSide(color: c.primary),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          icon: const Icon(Icons.draw),
                                          label: Text(
                                              vm.userSignature == null
                                                  ? 'Registrar firma de conformidad'
                                                  : 'Modificar firma',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Outfit')),
                                          onPressed: () async {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            await Future.delayed(const Duration(
                                                milliseconds: 150));
                                            if (context.mounted) {
                                              await _showSignaturePad(
                                                  context, vm);
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (vm.errorMsg != null &&
                                    vm.lastLocationError == null) ...[
                                  const SizedBox(height: 4),
                                  Text(vm.errorMsg!,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          fontSize: 14)),
                                ],
                                const SizedBox(height: 16),
                                _buildActions(c, vm),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator(color: c.primary)),
      ),
    );
  }

  Widget _buildProgress(AppColors c, OsExecutionViewModel vm) {
    final pending = vm.pasoPendiente;
    final completed = (vm.progress * OsExecutionViewModel.totalPasos).round();
    return Container(
      color: c.surface,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 728),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  pending == null
                      ? 'Registro completo · Listo para finalizar'
                      : 'Paso ${pending + 1} de 5 · ${_stepTitles[pending]}',
                  style: TextStyle(
                      color: c.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: vm.progress,
                minHeight: 6,
                borderRadius: BorderRadius.circular(4),
                backgroundColor: c.primary.withValues(alpha: 0.12),
                color: c.primary,
                semanticsLabel:
                    'Avance del registro: $completed de 5 pasos completados',
              ),
              const SizedBox(height: 8),
              Text('$completed de 5 pasos completados',
                  style: TextStyle(color: c.onSurfaceVariant, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  /// Botón de confirmación de un paso. El avance del formulario depende de
  /// esta acción explícita del técnico, no de que el campo tenga datos.
  Widget _buildConfirmStep({
    required AppColors c,
    required OsExecutionViewModel vm,
    required int paso,
    required String label,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final confirmado = vm.pasoConfirmado(paso);
    final listo = vm.pasoConDatos(paso);

    if (confirmado) {
      final ok = dark ? const Color(0xFF86EFAC) : const Color(0xFF166534);
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            Icon(Icons.verified_rounded, size: 18, color: ok),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Paso confirmado',
                style: TextStyle(
                  color: ok,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor:
                listo ? c.primary : c.onSurfaceVariant.withValues(alpha: 0.18),
            foregroundColor: listo ? c.onPrimary : c.onSurfaceVariant,
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: vm.isSubmitting ? null : () => _confirmarPaso(vm, paso),
          icon: Icon(
            listo
                ? Icons.check_circle_outline_rounded
                : Icons.lock_outline_rounded,
            size: 20,
          ),
          label: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  void _confirmarPaso(OsExecutionViewModel vm, int paso) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!vm.confirmarPaso(paso)) {
      final mensaje = vm.mensajePendiente;
      if (mensaje == null) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              mensaje,
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: const Color(0xFFF59E0B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    // Lleva la vista al bloque que se acaba de habilitar.
    final siguiente = vm.pasoPendiente;
    if (siguiente != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _desplazarAPaso(siguiente);
      });
    }
  }

  Widget _buildLocation(AppColors c, OsExecutionViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: c.primary,
            minimumSize: const Size(0, 52),
            padding: const EdgeInsets.all(14),
            side: BorderSide(color: c.primary),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: vm.isLocating
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: c.primary))
              : const Icon(Icons.location_on_outlined),
          label: Text(
              vm.isLocating
                  ? 'Obteniendo ubicación'
                  : vm.ubicacionRegistrada
                      ? 'Actualizar ubicación'
                      : 'Registrar ubicación',
              textAlign: TextAlign.center),
          onPressed: vm.isLocating ? null : vm.recordLocation,
        ),
        if (vm.lastLocationError != null) ...[
          const SizedBox(height: 12),
          Text(vm.errorMsg ?? 'No se pudo obtener la ubicación.',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 14)),
          if (vm.lastLocationError == LocationError.serviceDisabled)
            TextButton(
                onPressed: vm.openLocationSettings,
                child: const Text('Activar GPS')),
          if (vm.lastLocationError == LocationError.permissionDeniedForever)
            TextButton(
                onPressed: vm.openAppSettings,
                child: const Text('Abrir ajustes de permisos')),
        ],
        if (vm.ubicacionRegistrada) ...[
          const SizedBox(height: 12),
          Text(
              'Latitud: ${vm.latitud!.toStringAsFixed(6)} · Longitud: ${vm.longitud!.toStringAsFixed(6)}',
              style: TextStyle(color: c.onSurfaceVariant, fontSize: 13)),
          const SizedBox(height: 12),
          ExecutionLocationMap(
            location: LatLng(vm.latitud!, vm.longitud!),
          ),
        ],
      ],
    );
  }

  Widget _buildActions(AppColors c, OsExecutionViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: c.primary,
            foregroundColor: c.onPrimary,
            minimumSize: const Size(0, 54),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: vm.isSubmitting
              ? null
              : () {
                  if (vm.puedeFinalizar) {
                    _submit(vm);
                  } else {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final pending = vm.pasoPendiente;
                    if (pending != null) _desplazarAPaso(pending);
                  }
                },
          icon: vm.isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: c.onPrimary, strokeWidth: 2))
              : Icon(vm.puedeFinalizar
                  ? Icons.task_alt_rounded
                  : Icons.arrow_upward_rounded),
          label: Text(
              vm.isSubmitting
                  ? 'Enviando registro'
                  : vm.puedeFinalizar
                      ? 'Finalizar tarea'
                      : 'Ir al paso ${(vm.pasoPendiente ?? 0) + 1}',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(
              foregroundColor: c.onSurfaceVariant,
              minimumSize: const Size(0, 48)),
          onPressed: vm.isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Volver a la bandeja'),
        ),
      ],
    );
  }

  Future<void> _submit(OsExecutionViewModel vm) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final ok = await vm.submit();
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          vm.errorMsg ?? 'O.S. finalizada y enviada al sistema correctamente.',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: vm.errorMsg == null
            ? const Color(0xFF166534)
            : const Color(0xFF92400E),
      ));
      Navigator.pop(context);
    } else {
      final pending = vm.pasoPendiente;
      if (pending != null) _desplazarAPaso(pending);
      if (vm.errorMsg != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(vm.errorMsg!, style: const TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFFB91C1C)));
      }
    }
  }

  void _showImageSourceSheet(
      BuildContext context, Future<void> Function(ImageSource) onSelected) {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Tomar foto con la cámara'),
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.pop(context);
                onSelected(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de la galería'),
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.pop(context);
                onSelected(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getTipoProblemaLabel(String? code) {
    if (code == null || code.isEmpty) return '';
    final map = {
      'B6': 'Alcantarillado · Atoro',
      'OP-1': 'Obras inconclusas',
    };
    return map.containsKey(code) ? '$code - ${map[code]}' : code;
  }

  Widget _buildReclamoSection(AppColors c, Os os) {
    final r = os.reclamo;
    return OsDetailSection(
      title: 'Inf. de Reclamo',
      c: c,
      fields: [
        MapEntry('Cód. Solicitud', r?.codigoSolicitud ?? ''),
        MapEntry('Formato', r?.formato ?? ''),
        MapEntry(
          'Tipo',
          _getTipoProblemaLabel(r?.tipoProblema),
        ),
        MapEntry('Suministro', r?.numeroSuministro ?? ''),
        MapEntry('Telefono', r?.telefono ?? ''),
        MapEntry('Solicitante', r?.nombreSolicitante ?? ''),
        MapEntry('Email', r?.email ?? ''),
        MapEntry('Direccion', r?.direccion ?? ''),
        MapEntry('Descripcion', r?.descripcion ?? ''),
        MapEntry('Fecha registro', r?.fechaRegistro ?? ''),
      ],
    );
  }

  Widget _buildCuadrillaSection(AppColors c, Os os) {
    final cuadrilla = os.cuadrilla;
    final codigo = (cuadrilla?.codigoGrupo ?? cuadrilla?.id.toString() ?? '')
        .replaceFirst(RegExp(r'^Cuadrilla\s+', caseSensitive: false), '');
    final cuadrillaTexto = cuadrilla == null
        ? ''
        : '$codigo · ${cuadrilla.especialidad ?? "Sin especialidad"}';
    return OsDetailSection(
      title: 'Cuadrilla',
      c: c,
      fields: [
        MapEntry('Identificación', cuadrillaTexto),
      ],
    );
  }

  Widget _buildResponsablesSection(AppColors c, Os os) {
    final cuadrilla = os.cuadrilla;
    final fields = <MapEntry<String, String>>[];
    if (cuadrilla != null) {
      if (cuadrilla.lider != null) {
        fields.add(MapEntry('Líder', cuadrilla.lider!.nombre ?? '-'));
      }
      for (final a in cuadrilla.apoyos) {
        fields.add(MapEntry('Apoyo', a.nombre ?? '-'));
      }
      if (cuadrilla.chofer != null) {
        fields.add(MapEntry('Chofer', cuadrilla.chofer!.nombre ?? '-'));
      }
    }
    if (fields.isEmpty) {
      fields.add(const MapEntry('Responsables', ''));
    }
    return OsDetailSection(
      title: 'Responsables',
      c: c,
      fields: fields,
    );
  }

  Widget _buildBigActionButton({
    required AppColors c,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? c.primary : c.surface,
          foregroundColor: isPrimary ? c.onPrimary : c.primary,
          elevation: 0,
          minimumSize: const Size(0, 54),
          padding: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary ? BorderSide.none : BorderSide(color: c.primary),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildEditableTimePicker(
    BuildContext context,
    AppColors c,
    String label,
    DateTime? date,
    bool Function(DateTime) onChanged, {
    required DateTime baseDate,
    DateTime? minimumDate,
    bool hasError = false,
  }) {
    final hasDate = date != null;
    final timeStr = hasDate
        ? DateFormat('hh:mm a').format(date)
        : 'Tocar para seleccionar hora';
    return InkWell(
      onTap: () async {
        final t = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(date ?? DateTime.now()),
        );
        if (t != null && context.mounted) {
          final combined = DateTime(
              baseDate.year, baseDate.month, baseDate.day, t.hour, t.minute);

          if (minimumDate != null) {
            if (!combined.isAfter(minimumDate)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('La finalización debe ser posterior al inicio.')),
              );
              return;
            }
          }
          onChanged(combined);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasError
              ? Theme.of(context).colorScheme.error.withValues(alpha: 0.08)
              : c.surface,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: hasError ? const Color(0xFFDC2626) : c.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  Icon(Icons.access_time_rounded, color: c.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: c.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (hasDate)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          timeStr,
                          style: TextStyle(
                            color: c.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        Text(
                          '${date.day} de ${[
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
                            'diciembre'
                          ][date.month - 1]}',
                          style: TextStyle(
                            color: c.onSurfaceVariant.withValues(alpha: 0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: c.onSurfaceVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.edit_outlined, color: c.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoEvidenceSection({
    required AppColors c,
    required String title,
    required List<String> photos,
    required VoidCallback onAdd,
    required ValueChanged<int> onRemove,
    required String firstPhotoLabel,
    bool hasError = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photos.isEmpty)
          Semantics(
            button: true,
            label: 'Tomar la primera foto para $title',
            child: InkWell(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: hasError
                      ? Theme.of(context)
                          .colorScheme
                          .error
                          .withValues(alpha: 0.08)
                      : c.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasError
                        ? const Color(0xFFDC2626)
                        : c.primary.withValues(alpha: 0.45),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      color: c.primary,
                      size: 28,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      firstPhotoLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: c.primary,
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 10.0;
              final columns = constraints.maxWidth >= 600
                  ? 4
                  : constraints.maxWidth >= 360
                      ? 3
                      : 2;
              final tileWidth =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (var index = 0; index < photos.length; index++)
                    _buildPhotoThumbnail(
                      c: c,
                      path: photos[index],
                      index: index,
                      size: tileWidth,
                      onPreview: () => _showPhotoPreview(
                        context,
                        path: photos[index],
                        index: index,
                      ),
                      onRemove: () => onRemove(index),
                    ),
                  _buildAddPhotoTile(
                    c: c,
                    size: tileWidth,
                    onAdd: onAdd,
                  ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _buildPhotoThumbnail({
    required AppColors c,
    required String path,
    required int index,
    required double size,
    required VoidCallback onPreview,
    required VoidCallback onRemove,
  }) {
    return Semantics(
      label: 'Foto ${index + 1}',
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onPreview,
                  child: Image.file(
                    File(path),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: c.surface,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: c.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.border),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -6,
              right: -6,
              child: Semantics(
                button: true,
                label: 'Quitar foto ${index + 1}',
                child: Tooltip(
                  message: 'Quitar foto',
                  child: Material(
                    color: const Color(0xFFDC2626),
                    shape: const CircleBorder(),
                    elevation: 3,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onRemove,
                      child: const SizedBox(
                        width: 28,
                        height: 28,
                        child: Icon(
                          Icons.remove_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPhotoPreview(
    BuildContext context, {
    required String path,
    required int index,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (dialogContext) {
        final screenHeight = MediaQuery.sizeOf(dialogContext).height;

        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 28),
          backgroundColor: const Color(0xFF0B0B0B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: double.infinity,
            height: screenHeight * 0.82,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 8, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Foto ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Semantics(
                        button: true,
                        label: 'Cerrar previsualización',
                        child: TextButton.icon(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 7,
                            ),
                          ),
                          icon: const Icon(Icons.close_rounded, size: 20),
                          label: const Text(
                            'Cerrar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFF2B2B2B)),
                Expanded(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Center(
                      child: Image.file(
                        File(path),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white54,
                              size: 48,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No se pudo mostrar la imagen',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pinch_outlined,
                        color: Colors.white60,
                        size: 17,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Pellizca para ampliar la imagen',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddPhotoTile({
    required AppColors c,
    required double size,
    required VoidCallback onAdd,
  }) {
    return Semantics(
      button: true,
      label: 'Agregar otra foto',
      child: InkWell(
        onTap: onAdd,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: c.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: c.primary.withValues(alpha: 0.55),
              width: 1.4,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: c.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: c.onPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Añadir foto',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.primary,
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required AppColors c,
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    bool hasError = false,
  }) {
    return VoiceTextField(
      controller: controller,
      label: label,
      hint: hint ?? '',
      maxLines: maxLines,
      hasError: hasError,
      primaryColor: c.primary,
      surfaceColor: c.surface,
      onSurfaceColor: c.onSurface,
      onSurfaceVariantColor: c.onSurfaceVariant,
      borderColor: c.border,
    );
  }

  Future<void> _showSignaturePad(
      BuildContext context, OsExecutionViewModel vm) {
    final SignatureController controller = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
    );
    final c = Theme.of(context).extension<AppColors>()!;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.7,
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          // La tablet dibuja la app de borde a borde: sin esto los botones
          // quedan debajo de la barra de navegación / taskbar del sistema.
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: c.border,
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                Text('Firma del Usuario',
                    style: TextStyle(
                        color: c.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit')),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: c.border),
                          color: Colors.grey[100],
                        ),
                        child: Signature(
                          controller: controller,
                          backgroundColor: Colors.grey[100]!,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: TextButton(
                            onPressed: () => controller.clear(),
                            child: const Text('Limpiar',
                                style: TextStyle(
                                    color: Color(0xFFDC2626),
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: c.primary,
                              foregroundColor: c.onPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              if (controller.isNotEmpty) {
                                final bytes = await controller.toPngBytes();
                                if (bytes != null) {
                                  // Save in memory for UI preview
                                  vm.setSignature(bytes);

                                  // Save temporary for PDF
                                  final tempDir = await getTemporaryDirectory();
                                  final file = File(
                                      '${tempDir.path}/signature_${vm.os.id}.png');
                                  await file.writeAsBytes(bytes);
                                }
                              }
                              if (context.mounted) Navigator.pop(context);
                            },
                            child: const Text('Guardar Firma',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
