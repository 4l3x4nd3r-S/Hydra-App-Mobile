import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/models/os.dart';
import '../../../../domain/models/cuadrilla.dart';
import '../../../core/theme/app_colors.dart';
import '../view_models/os_detail_view_model.dart';
import '../widgets/os_detail_section.dart';
import '../widgets/os_detail_action_button.dart';
import '../../../../data/services/api_endpoints.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OsDetailView extends StatelessWidget {
  final Os os;
  final bool showReadOnlyBanner;
  final VoidCallback? onRegistrarSolucion;

  const OsDetailView({
    super.key,
    required this.os,
    this.showReadOnlyBanner = false,
    this.onRegistrarSolucion,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OsDetailViewModel(os: os),
      child: _OsDetailBody(
        showReadOnlyBanner: showReadOnlyBanner,
        onRegistrarSolucion: onRegistrarSolucion,
      ),
    );
  }
}

class _OsDetailBody extends StatelessWidget {
  final bool showReadOnlyBanner;
  final VoidCallback? onRegistrarSolucion;

  const _OsDetailBody({
    this.showReadOnlyBanner = false,
    this.onRegistrarSolucion,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.watch<OsDetailViewModel>();
    final os = vm.os;

    debugPrint('OsDetailView build - os.id: ${os.id}');
    debugPrint('OsDetailView build - os.reclamo: ${os.reclamo}');
    debugPrint('OsDetailView build - os.reclamo?.nombreSolicitante: ${os.reclamo?.nombreSolicitante}');
    debugPrint('OsDetailView build - os.cuadrilla: ${os.cuadrilla}');

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
          'INFORMACION DE LA ORDEN DE SERVICIO',
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
            const SizedBox(height: 16),
            _buildReclamoSection(c, os),
            const SizedBox(height: 12),
            _buildCuadrillaSection(c, os),
            const SizedBox(height: 12),
            _buildResponsablesSection(c, os),
            if (os.fechaEjecucionInicio != null) ...[
              _buildFechaInicioSection(c, os, vm),
              const SizedBox(height: 12),
            ],
            if (os.fotosProblemaUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildFotosSection(c, 'Fotos del problema', os.fotosProblemaUrls),
              const SizedBox(height: 12),
            ],
            if (os.trabajoEjecutado != null && os.trabajoEjecutado!.isNotEmpty) ...[
              _buildTrabajoEjecutadoSection(c, os),
              const SizedBox(height: 12),
            ],
            if (os.problemas != null && os.problemas!.isNotEmpty || os.soluciones != null && os.soluciones!.isNotEmpty) ...[
              _buildProblemasSolucionesSection(c, os),
              const SizedBox(height: 12),
            ],
            if (os.comentariosInstrucciones != null && os.comentariosInstrucciones!.isNotEmpty) ...[
              _buildComentariosSection(c, os),
              const SizedBox(height: 12),
            ],
            if (os.observacionesGasfitero != null && os.observacionesGasfitero!.isNotEmpty) ...[
              _buildObservacionesSection(c, os),
              const SizedBox(height: 12),
            ],
            if (os.fotosSolucionUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildFotosSection(c, 'Fotos de la solucion', os.fotosSolucionUrls),
              const SizedBox(height: 12),
            ],
            if (os.fechaEjecucionFin != null) ...[
              _buildFechaFinSection(c, os, vm),
              const SizedBox(height: 12),
            ],
            if (os.latitud != null && os.longitud != null) ...[
              _buildMapSection(c, os),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 24),
            if (onRegistrarSolucion != null) ...[
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9), // Cyan para resaltar la acción primaria
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onRegistrarSolucion,
                  child: const Text(
                    'REGISTRAR SOLUCION',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyNotice(AppColors c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: const Color(0xFFB45309), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Nada de esta informacion es editable',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: const Color(0xFFB45309),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReclamoSection(AppColors c, Os os) {
    final r = os.reclamo;
    debugPrint('_buildReclamoSection - r: $r');
    debugPrint('_buildReclamoSection - r?.nombreSolicitante: ${r?.nombreSolicitante}');
    debugPrint('_buildReclamoSection - r?.tipoProblema: ${r?.tipoProblema}');
    debugPrint('_buildReclamoSection - r?.formato: ${r?.formato}');
    debugPrint('_buildReclamoSection - r?.descripcion: ${r?.descripcion}');
    debugPrint('_buildReclamoSection - r?.direccion: ${r?.direccion}');
    debugPrint('_buildReclamoSection - r?.telefono: ${r?.telefono}');
    debugPrint('_buildReclamoSection - r?.email: ${r?.email}');
    debugPrint('_buildReclamoSection - r?.numeroMedidor: ${r?.numeroMedidor}');
    debugPrint('_buildReclamoSection - r?.fechaRegistro: ${r?.fechaRegistro}');
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

  Widget _buildFechaInicioSection(AppColors c, Os os, OsDetailViewModel vm) {
    return OsDetailSection(
      title: 'Fecha Hora Inicio',
      c: c,
      fields: [
        MapEntry('Fecha Hora Inicio', vm.formatDate(os.fechaEjecucionInicio)),
      ],
    );
  }

  Widget _buildTrabajoEjecutadoSection(AppColors c, Os os) {
    return OsDetailSection(
      title: 'Trabajo Ejecutado',
      c: c,
      fields: [
        MapEntry('Trabajo ejecutado', os.trabajoEjecutado ?? ''),
      ],
    );
  }

  Widget _buildProblemasSolucionesSection(AppColors c, Os os) {
    return OsDetailSection(
      title: 'Problemas / Soluciones',
      c: c,
      fields: [
        MapEntry('Problemas', os.problemas ?? ''),
        MapEntry('Soluciones', os.soluciones ?? ''),
      ],
    );
  }

  Widget _buildComentariosSection(AppColors c, Os os) {
    return OsDetailSection(
      title: 'Comentarios / Instrucciones Especiales',
      c: c,
      fields: [
        MapEntry('Comentarios / Instr. Esp.', os.comentariosInstrucciones ?? ''),
      ],
    );
  }

  Widget _buildObservacionesSection(AppColors c, Os os) {
    return OsDetailSection(
      title: 'Observaciones',
      c: c,
      fields: [
        MapEntry('Observaciones', os.observacionesGasfitero ?? ''),
      ],
    );
  }

  Widget _buildFechaFinSection(AppColors c, Os os, OsDetailViewModel vm) {
    final fields = [
      MapEntry('Fecha Hora Fin', vm.formatDate(os.fechaEjecucionFin)),
    ];
    
    return OsDetailSection(
      title: 'Fecha Hora Fin',
      c: c,
      fields: fields,
    );
  }

  Widget _buildMapSection(AppColors c, Os os) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UBICACIÓN REGISTRADA',
          style: TextStyle(
            color: c.primary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'Outfit',
            letterSpacing: 0.5,
          ),
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
                options: MapOptions(
                  initialCenter: LatLng(os.latitud!, os.longitud!),
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
                        point: LatLng(os.latitud!, os.longitud!),
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
    );
  }

  Widget _buildFotosSection(AppColors c, String title, List<String> urls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: c.primary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'Outfit',
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: urls.length,
            itemBuilder: (context, index) {
              String url = urls[index];
              if (!url.startsWith('http')) {
                final base = ApiEndpoints.baseUrl.replaceAll('/api/v1', '');
                url = '$base$url';
              }
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    url,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      width: 120,
                      height: 120,
                      color: c.surface,
                      child: Icon(Icons.broken_image_rounded, color: c.onSurfaceVariant),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }


}
