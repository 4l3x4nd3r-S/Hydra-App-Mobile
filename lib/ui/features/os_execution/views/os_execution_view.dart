import 'package:flutter/material.dart';
import '../../../../data/services/app_environment.dart';
import 'package:provider/provider.dart';
import '../../../../domain/models/os.dart';
import '../../../../domain/use_cases/save_os_report_use_case.dart';
import '../../../../data/services/sync_queue_storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../view_models/os_execution_view_model.dart';
import '../../os_detail/widgets/os_detail_section.dart';
import '../../os_detail/widgets/os_detail_action_button.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

class _OsExecutionBody extends StatelessWidget {
  const _OsExecutionBody();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.watch<OsExecutionViewModel>();
    final os = vm.os;

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
          'SOLUCIÓN DE LA ORDEN DE SERVICIO',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: c.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (vm.isDraftLoaded) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: vm.progress,
                  backgroundColor: c.primary.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(c.primary),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  'Ver Detalles de la Orden',
                  style: TextStyle(
                      color: c.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                iconColor: c.primary,
                collapsedIconColor: c.primary,
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                childrenPadding: const EdgeInsets.only(bottom: 16),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
            OsDetailActionButton(
              icon: Icons.location_on_outlined,
              label: vm.isLocating ? 'Obteniendo...' : 'Grabar ubicacion',
              onPressed: vm.isLocating ? null : () => vm.recordLocation(),
              c: c,
            ),
            if (vm.lastLocationError != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFDC2626).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Color(0xFFDC2626), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        vm.errorMsg ?? '',
                        style: const TextStyle(
                            color: Color(0xFFDC2626), fontSize: 13),
                      ),
                    ),
                    if (vm.lastLocationError == LocationError.serviceDisabled)
                      TextButton(
                        onPressed: vm.openLocationSettings,
                        child: const Text('Activar GPS',
                            style: TextStyle(
                                color: Color(0xFF0EA5E9),
                                fontWeight: FontWeight.bold)),
                      ),
                    if (vm.lastLocationError ==
                        LocationError.permissionDeniedForever)
                      TextButton(
                        onPressed: vm.openAppSettings,
                        child: const Text('Ajustes',
                            style: TextStyle(
                                color: Color(0xFF0EA5E9),
                                fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
            ],
            if (vm.latitud != null && vm.longitud != null) ...[
              const SizedBox(height: 8),
              Text(
                'Lat: ${vm.latitud}, Lon: ${vm.longitud}',
                style: TextStyle(
                    color: c.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: c.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: FlutterMap(
                      key: ValueKey('${vm.latitud}_${vm.longitud}'),
                      options: MapOptions(
                        initialCenter: LatLng(vm.latitud!, vm.longitud!),
                        initialZoom: 16.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: AppEnvironment.mapTileUrl,
                          userAgentPackageName: 'com.emapat.hydra',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(vm.latitud!, vm.longitud!),
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (vm.fechaInicio == null) ...[
              _buildBigActionButton(
                c: c,
                icon: Icons.play_arrow_rounded,
                label: 'INICIAR TAREA AHORA',
                onPressed: vm.iniciarAhora,
                isPrimary: true,
              ),
              const SizedBox(height: 16),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: c.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.play_circle_outline, color: c.primary, size: 20),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hora de Inicio', style: TextStyle(color: c.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                        Text(DateFormat('dd/MM/yyyy HH:mm').format(vm.fechaInicio!), style: TextStyle(color: c.onSurface, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            _buildTextField(
              c: c,
              controller: vm.trabajoEjecutadoController,
              label: 'Trabajo ejecutado (Obligatorio)',
              hint: 'Describa el trabajo ejecutado...',
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              c: c,
              controller: vm.problemasSolucionesController,
              label: 'Problemas / Soluciones',
              hint: 'Describa los problemas y soluciones...',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text('Campos Adicionales (Opcional)', style: TextStyle(color: c.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                iconColor: c.primary,
                collapsedIconColor: c.primary,
                tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                childrenPadding: const EdgeInsets.only(bottom: 12),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: c.border),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: c.primary),
                ),
                backgroundColor: c.surface,
                collapsedBackgroundColor: c.surface,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        _buildTextField(
                          c: c,
                          controller: vm.insumosController,
                          label: 'Insumos utilizados',
                          hint: 'Describa los insumos...',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          c: c,
                          controller: vm.comentariosInstruccionesController,
                          label: 'Comentarios Especiales',
                          hint: 'Agregue comentarios...',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          c: c,
                          controller: vm.observacionesController,
                          label: 'Observaciones',
                          hint: 'Observaciones generales...',
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildPhotoEvidenceSection(
              c: c,
              title: 'Fotos del problema',
              photos: vm.fotosProblema,
              onAdd: vm.takeFotoProblema,
              onRemove: vm.removeFotoProblema,
            ),
            const SizedBox(height: 16),
            _buildPhotoEvidenceSection(
              c: c,
              title: 'Fotos de la solución',
              photos: vm.fotosSolucion,
              onAdd: vm.takeFotoSolucion,
              onRemove: vm.removeFotoSolucion,
            ),
            const SizedBox(height: 16),
            if (vm.fechaFin == null) ...[
              _buildBigActionButton(
                c: c,
                icon: Icons.stop_circle_outlined,
                label: 'FINALIZAR TAREA AHORA',
                onPressed: vm.finalizarAhora,
                isPrimary: false,
              ),
              const SizedBox(height: 16),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: c.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.stop_circle, color: c.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hora de Finalización', style: TextStyle(color: c.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                          Text(DateFormat('dd/MM/yyyy HH:mm').format(vm.fechaFin!), style: TextStyle(color: c.onSurface, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: c.primary),
                      onPressed: vm.finalizarAhora,
                      tooltip: 'Actualizar hora fin',
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (vm.errorMsg != null) ...[
              const SizedBox(height: 12),
              Text(
                vm.errorMsg!,
                style: const TextStyle(
                  color: Color(0xFFDC2626),
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: c.onSurface,
                        side: BorderSide(color: c.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'CANCELAR',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.primary,
                        alignment: Alignment.center,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final ok = await vm.submit();
                        if (ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'O.S. guardada en el dispositivo. Se enviará cuando haya conexión.',
                              ),
                              backgroundColor: Color(0xFFF59E0B),
                            ),
                          );
                          Navigator.pop(context);
                        } else if (context.mounted && vm.errorMsg != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(vm.errorMsg!),
                              backgroundColor: const Color(0xFFDC2626),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'GUARDAR Y FINALIZAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: c.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildReclamoSection(AppColors c, Os os) {
    final r = os.reclamo;
    return OsDetailSection(
      title: 'Inf. de Reclamo',
      c: c,
      fields: [
        MapEntry('N° de O.S.', os.numeroOrden ?? ''),
        MapEntry('Formato', r?.formato ?? ''),
        MapEntry(
          'Tipo',
          r?.tipoProblema ?? '',
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
      height: 54,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? c.primary : c.surface,
          foregroundColor: isPrimary ? c.onPrimary : c.primary,
          elevation: isPrimary ? 2 : 0,
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

  Widget _buildEditableFechaPicker(
    BuildContext context,
    AppColors c,
    String label,
    DateTime? date,
    bool Function(DateTime) onChanged, {
    required DateTime minimumDateTime,
    bool mustBeAfterMinimum = false,
  }) {
    final dateStr =
        date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date) : '-';
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final minimumDay = DateTime(
          minimumDateTime.year,
          minimumDateTime.month,
          minimumDateTime.day,
        );
        final firstDate = minimumDay.isAfter(today) ? minimumDay : today;
        final selectedInitialDate =
            date == null || date.isBefore(firstDate) ? firstDate : date;
        final d = await showDatePicker(
          context: context,
          initialDate: selectedInitialDate,
          firstDate: firstDate,
          lastDate: DateTime(2030),
        );
        if (d != null && context.mounted) {
          final t = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(date ?? DateTime.now()),
          );
          if (t != null) {
            if (!context.mounted) return;
            final combined = DateTime(d.year, d.month, d.day, t.hour, t.minute);
            final minimumMinute = DateTime(
              minimumDateTime.year,
              minimumDateTime.month,
              minimumDateTime.day,
              minimumDateTime.hour,
              minimumDateTime.minute,
            );
            final isInvalid = mustBeAfterMinimum
                ? !combined.isAfter(minimumMinute)
                : combined.isBefore(minimumMinute);
            if (isInvalid) {
              final message = mustBeAfterMinimum
                  ? 'La finalización debe ser posterior al inicio.'
                  : 'No puede seleccionar una fecha u hora pasada.';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
              return;
            }
            onChanged(combined);
          }
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: c.primary, fontWeight: FontWeight.bold, fontSize: 13),
          filled: true,
          fillColor: c.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.border),
          ),
          suffixIcon:
              Icon(Icons.edit_calendar_rounded, color: c.primary, size: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        child: Text(
          dateStr,
          style: TextStyle(
              color: c.onSurface, fontSize: 14, fontWeight: FontWeight.w500),
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
  }) {
    final photoLabel = photos.length == 1 ? '1 foto' : '${photos.length} fotos';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.photo_camera_outlined,
                color: c.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: c.onSurface,
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    photos.isEmpty
                        ? 'Agrega una o varias evidencias fotográficas'
                        : '$photoLabel agregadas · Toca una para ampliarla',
                    style: TextStyle(
                      color: c.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
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
                  color: c.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: c.primary.withValues(alpha: 0.45),
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
                      'TOMAR PRIMERA FOTO',
                      style: TextStyle(
                        color: c.primary,
                        fontFamily: 'Outfit',
                        fontSize: 12,
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
              final tileWidth = (constraints.maxWidth - spacing * 2) / 3;

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
                'AGREGAR',
                style: TextStyle(
                  color: c.primary,
                  fontFamily: 'Outfit',
                  fontSize: 10,
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
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: c.onSurface, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
            color: c.primary, fontWeight: FontWeight.bold, fontSize: 13),
        hintStyle: TextStyle(color: c.onSurfaceVariant.withValues(alpha: 0.5)),
        filled: true,
        fillColor: c.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
