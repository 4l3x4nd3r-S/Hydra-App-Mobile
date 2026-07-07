import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/models/os.dart';
import '../../../../domain/use_cases/save_os_report_use_case.dart';
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
            _buildReclamoSection(c, os),
            const SizedBox(height: 12),
            _buildCuadrillaSection(c, os),
            const SizedBox(height: 12),
            _buildResponsablesSection(c, os),
            const SizedBox(height: 12),
            OsDetailActionButton(
              icon: Icons.location_on_outlined,
              label: vm.isLocating ? 'Obteniendo...' : 'Grabar ubicacion',
              onPressed: vm.isLocating ? null : () => vm.recordLocation(),
              c: c,
            ),
            if (vm.latitud != null && vm.longitud != null) ...[
              const SizedBox(height: 8),
              Text(
                'Lat: ${vm.latitud}, Lon: ${vm.longitud}',
                style: TextStyle(color: c.primary, fontWeight: FontWeight.bold, fontSize: 13),
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
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
            _buildEditableFechaPicker(context, c, 'Fecha Hora Inicio', vm.fechaInicio, vm.updateFechaInicio),
            const SizedBox(height: 12),
            OsDetailActionButton(
              icon: Icons.camera_alt_outlined,
              label: 'Fotos del problema',
              onPressed: () => vm.takeFotoProblema(),
              c: c,
            ),
            if (vm.fotosProblema.isNotEmpty) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.fotosProblema.length,
                  itemBuilder: (ctx, i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(vm.fotosProblema[i]),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            _buildTextField(
              c: c,
              controller: vm.trabajoEjecutadoController,
              label: 'Trabajo ejecutado',
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
            const SizedBox(height: 12),
            _buildTextField(
              c: c,
              controller: vm.comentariosInstruccionesController,
              label: 'Comentarios / Instrucciones Especiales',
              hint: 'Agregue comentarios adicionales...',
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              c: c,
              controller: vm.observacionesController,
              label: 'Observaciones',
              hint: 'Observaciones generales del gasfitero...',
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            OsDetailActionButton(
              icon: Icons.camera_alt_outlined,
              label: 'Fotos de la solucion',
              onPressed: () => vm.takeFotoSolucion(),
              c: c,
            ),
            if (vm.fotosSolucion.isNotEmpty) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.fotosSolucion.length,
                  itemBuilder: (ctx, i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(vm.fotosSolucion[i]),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 12),
            _buildEditableFechaPicker(context, c, 'Fecha Hora Fin', vm.fechaFin, vm.updateFechaFin),
            
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
                                'Guardado correctamente. Sincronizando en segundo plano...',
                              ),
                              backgroundColor: Color(0xFF22C55E),
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
                      child: const Text(
                        'GUARDAR',
                        style: TextStyle(
                          color: Colors.white,
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
        MapEntry('Numero', os.numeroOrden ?? ''),
        MapEntry('Solicitante', r?.nombreSolicitante ?? ''),
        MapEntry('Tipo', r?.tipoProblema ?? ''),
        MapEntry('Formato', r?.formato ?? ''),
        MapEntry('Descripcion', r?.descripcion ?? ''),
        MapEntry('Direccion', r?.direccion ?? ''),
        MapEntry('Telefono', r?.telefono ?? ''),
        MapEntry('Email', r?.email ?? ''),
        MapEntry('Medidor', r?.numeroMedidor ?? ''),
        MapEntry('Fecha registro', r?.fechaRegistro ?? ''),
      ],
    );
  }

  Widget _buildCuadrillaSection(AppColors c, Os os) {
    final cuadrilla = os.cuadrilla;
    final cuadrillaTexto = cuadrilla != null
        ? '${cuadrilla.codigoGrupo ?? "Cuadrilla ${cuadrilla.id}"} - ${cuadrilla.especialidad ?? ""}'
        : '';
    return OsDetailSection(
      title: 'Cuadrilla',
      c: c,
      fields: [
        MapEntry('Cuadrilla', cuadrillaTexto),
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
      if (cuadrilla.operador != null) {
        fields.add(MapEntry('Operador', cuadrilla.operador!.nombre ?? '-'));
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

  Widget _buildEditableFechaPicker(
    BuildContext context,
    AppColors c,
    String label,
    DateTime? date,
    ValueChanged<DateTime> onChanged,
  ) {
    final dateStr = date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date) : '-';
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: c.primary,
                  onPrimary: Colors.white,
                  surface: c.surface,
                  onSurface: c.onSurface,
                ),
              ),
              child: child!,
            );
          },
        );
        if (d != null && context.mounted) {
          final t = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(date ?? DateTime.now()),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: c.primary,
                    onPrimary: Colors.white,
                    surface: c.surface,
                    onSurface: c.onSurface,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (t != null) {
            final combined = DateTime(d.year, d.month, d.day, t.hour, t.minute);
            onChanged(combined);
          }
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: c.primary, fontWeight: FontWeight.bold, fontSize: 13),
          filled: true,
          fillColor: c.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.border),
          ),
          suffixIcon: Icon(Icons.edit_calendar_rounded, color: c.primary, size: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        child: Text(
          dateStr,
          style: TextStyle(color: c.onSurface, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '-';
    try {
      final d = DateTime.parse(isoString).toLocal();
      return DateFormat('yyyy-MM-dd HH:mm').format(d);
    } catch (_) {
      return isoString;
    }
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
        labelStyle: TextStyle(color: c.primary, fontWeight: FontWeight.bold, fontSize: 13),
        hintStyle: TextStyle(color: c.onSurfaceVariant.withValues(alpha: 0.5)),
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
