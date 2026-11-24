import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../data/services/app_environment.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/status_chip.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/catalog_repository.dart';
import '../../../../domain/models/os.dart';
import '../view_models/os_detail_view_model.dart';
import '../widgets/os_detail_section.dart';
import '../../../../data/services/api_endpoints.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/utils/os_pdf_generator.dart';
import 'package:printing/printing.dart';

class OsDetailView extends StatelessWidget {
  final Os os;
  final bool showReadOnlyBanner;
  final bool isGasfiteroView;
  final Future<void> Function()? onRegistrarSolucion;

  const OsDetailView({
    super.key,
    required this.os,
    this.showReadOnlyBanner = false,
    this.isGasfiteroView = false,
    this.onRegistrarSolucion,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OsDetailViewModel(
        os: os,
        catalogRepository: _readCatalog(context),
      ),
      child: _OsDetailBody(
        showReadOnlyBanner: showReadOnlyBanner,
        isGasfiteroView: isGasfiteroView,
        onRegistrarSolucion: onRegistrarSolucion,
      ),
    );
  }
}

CatalogRepository? _readCatalog(BuildContext context) {
  try {
    return context.read<CatalogRepository>();
  } catch (_) {
    return null;
  }
}

class _OsDetailBody extends StatelessWidget {
  final bool showReadOnlyBanner;
  final bool isGasfiteroView;
  final Future<void> Function()? onRegistrarSolucion;

  const _OsDetailBody({
    this.showReadOnlyBanner = false,
    this.isGasfiteroView = false,
    this.onRegistrarSolucion,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.watch<OsDetailViewModel>();
    final os = vm.os;
    bool isSignature(String url) =>
        url.contains('/firma') || url.contains('signature');
    final solutionPhotos =
        os.fotosSolucionUrls.where((url) => !isSignature(url)).toList();
    final signaturePhotos = os.fotosSolucionUrls.where(isSignature).toList();

    debugPrint('OsDetailView build - os.id: ${os.id}');
    debugPrint('OsDetailView build - os.reclamo: ${os.reclamo}');
    debugPrint(
        'OsDetailView build - os.reclamo?.nombreSolicitante: ${os.reclamo?.nombreSolicitante}');
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
        toolbarHeight: (MediaQuery.textScalerOf(context).scale(17) * 2.4 +
                MediaQuery.textScalerOf(context).scale(13) * 1.4 +
                16)
            .clamp(76, 160)
            .toDouble(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalle de la orden',
                maxLines: 2,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: c.onSurface)),
            if (os.numeroOrden?.trim().isNotEmpty ?? false)
              Text('N.º ${os.numeroOrden}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: c.onSurfaceVariant)),
          ],
        ),
        actions: [
          if (os.estadoOrden != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Hero(
                  tag: 'os_status_${os.id}',
                  child: StatusChip(status: os.estadoOrden!),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showReadOnlyBanner) ...[
                    _buildReadOnlyNotice(c),
                    const SizedBox(height: 12),
                  ],
                  _buildContextSection(
                    context,
                    c,
                    title: 'Información del reclamo',
                    icon: Icons.assignment_outlined,
                    storageKey: 'os_claim_${os.id}',
                    children: [
                      _buildReclamoSection(c, os, vm.tipoProblemaLabel,
                          embedded: true)
                    ],
                  ),
                  if (!(isGasfiteroView && os.responsable != null) &&
                      (os.cuadrilla != null || os.responsable != null)) ...[
                    const SizedBox(height: 12),
                    _buildContextSection(
                      context,
                      c,
                      title: 'Cuadrilla y responsables',
                      icon: Icons.groups_outlined,
                      storageKey: 'os_team_${os.id}',
                      children: [
                        if (os.cuadrilla != null)
                          _buildCuadrillaSection(c, os, embedded: true),
                        _buildResponsablesSection(c, os, embedded: true),
                      ],
                    ),
                  ],
                  if (os.fotosProblemaUrls.isNotEmpty ||
                      solutionPhotos.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: os.fotosProblemaUrls.isNotEmpty
                              ? _buildFotosSection(c, 'Fotos del problema',
                                  os.fotosProblemaUrls, context)
                              : const SizedBox.shrink(),
                        ),
                        Container(
                          width: 1,
                          height: 160,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: c.border.withValues(alpha: 0.5),
                        ),
                        Expanded(
                          child: solutionPhotos.isNotEmpty
                              ? _buildFotosSection(c, 'Fotos de la solución',
                                  solutionPhotos, context)
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (os.trabajoEjecutado != null &&
                      os.trabajoEjecutado!.isNotEmpty) ...[
                    _buildTrabajoEjecutadoSection(c, os),
                    const SizedBox(height: 12),
                  ],
                  if (os.problemas != null && os.problemas!.isNotEmpty ||
                      os.soluciones != null && os.soluciones!.isNotEmpty) ...[
                    _buildProblemasSolucionesSection(c, os),
                    const SizedBox(height: 12),
                  ],
                  if (os.comentariosInstrucciones != null &&
                      os.comentariosInstrucciones!.isNotEmpty) ...[
                    _buildComentariosSection(c, os),
                    const SizedBox(height: 12),
                  ],
                  if (os.observacionesGasfitero != null &&
                      os.observacionesGasfitero!.isNotEmpty) ...[
                    _buildObservacionesSection(c, os),
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
                  if (signaturePhotos.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: _buildFotosSection(
                          c,
                          'Firma de conformidad del usuario',
                          signaturePhotos,
                          context,
                          isSignature: true),
                    ),
                  ],
                  if (os.trabajoEjecutado != null &&
                      os.trabajoEjecutado!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf,
                            color: Colors.white),
                        label: const Text('Exportar Reporte a PDF',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.primary,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                                child: CircularProgressIndicator()),
                          );
                          try {
                            final bytes = await OsPdfGenerator.generate(os);
                            if (context.mounted) Navigator.pop(context);
                            await Printing.layoutPdf(
                                onLayout: (format) async => bytes);
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Error generando PDF: $e')));
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
          if (onRegistrarSolucion != null)
            _RegistrarSolucionButton(
                onRegistrarSolucion: onRegistrarSolucion, c: c),
        ],
      ),
    );
  }

  Widget _buildContextSection(
    BuildContext context,
    AppColors c, {
    required String title,
    required IconData icon,
    required String storageKey,
    required List<Widget> children,
  }) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: c.border.withValues(alpha: 0.6)),
    );
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: PageStorageKey(storageKey),
        initiallyExpanded: false,
        minTileHeight: 60,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: shape,
        collapsedShape: shape,
        clipBehavior: Clip.antiAlias,
        backgroundColor: c.surface,
        collapsedBackgroundColor: c.surface,
        iconColor: c.primary,
        collapsedIconColor: c.onSurfaceVariant,
        leading: Icon(icon, color: c.primary, size: 22),
        title: Text(title,
            style: TextStyle(
                color: c.onSurface, fontSize: 15, fontWeight: FontWeight.w600)),
        children: children,
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
        border:
            Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFFB45309), size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Esta información es solo de lectura',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Color(0xFFB45309),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReclamoSection(AppColors c, Os os, String tipoLabel,
      {bool embedded = false}) {
    final r = os.reclamo;
    debugPrint('_buildReclamoSection - r: $r');
    debugPrint(
        '_buildReclamoSection - r?.nombreSolicitante: ${r?.nombreSolicitante}');
    debugPrint('_buildReclamoSection - r?.tipoProblema: ${r?.tipoProblema}');
    debugPrint('_buildReclamoSection - r?.formato: ${r?.formato}');
    debugPrint('_buildReclamoSection - r?.descripcion: ${r?.descripcion}');
    debugPrint('_buildReclamoSection - r?.direccion: ${r?.direccion}');
    debugPrint('_buildReclamoSection - r?.telefono: ${r?.telefono}');
    debugPrint('_buildReclamoSection - r?.email: ${r?.email}');
    debugPrint(
      '_buildReclamoSection - r?.numeroSuministro: ${r?.numeroSuministro}',
    );
    debugPrint('_buildReclamoSection - r?.fechaRegistro: ${r?.fechaRegistro}');
    return OsDetailSection(
      title: 'Inf. de Reclamo',
      c: c,
      embedded: embedded,
      fields: [
        MapEntry('Código de solicitud', r?.codigoSolicitud ?? ''),
        MapEntry('Formato', r?.formato ?? ''),
        MapEntry('Tipo', tipoLabel),
        MapEntry('Suministro', r?.numeroSuministro ?? ''),
        MapEntry('Telefono', r?.telefono ?? ''),
        MapEntry('Solicitante', r?.nombreSolicitante ?? ''),
        MapEntry('Direccion', r?.direccion ?? ''),
        MapEntry('Fecha registro', r?.fechaRegistro ?? ''),
      ],
    );
  }

  Widget _buildCuadrillaSection(AppColors c, Os os, {bool embedded = false}) {
    final cuadrilla = os.cuadrilla;
    final codigo = (cuadrilla?.codigoGrupo ?? cuadrilla?.id.toString() ?? '')
        .replaceFirst(RegExp(r'^Cuadrilla\s+', caseSensitive: false), '');
    final cuadrillaTexto = cuadrilla == null
        ? ''
        : '$codigo · ${cuadrilla.especialidad ?? "Sin especialidad"}';
    return OsDetailSection(
      title: 'Cuadrilla',
      c: c,
      embedded: embedded,
      fields: [
        MapEntry('Identificación', cuadrillaTexto),
      ],
    );
  }

  Widget _buildResponsablesSection(AppColors c, Os os,
      {bool embedded = false}) {
    final fields = <MapEntry<String, String>>[];

    if (os.responsable != null) {
      fields
          .add(MapEntry('Responsable', os.responsable!.nombre ?? 'Sin nombre'));
    }

    final cuadrilla = os.cuadrilla;
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
      embedded: embedded,
      fields: fields,
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
        MapEntry(
            'Comentarios / Instr. Esp.', os.comentariosInstrucciones ?? ''),
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
                    urlTemplate: AppEnvironment.mapTileUrl,
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

  Widget _buildFotosSection(
      AppColors c, String title, List<String> urls, BuildContext context,
      {bool isSignature = false}) {
    return Column(
      crossAxisAlignment:
          isSignature ? CrossAxisAlignment.center : CrossAxisAlignment.start,
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
          width: isSignature ? urls.length * 248.0 : double.infinity,
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: isSignature,
            itemCount: urls.length,
            itemBuilder: (context, index) {
              String url = urls[index];
              if (!url.startsWith('http')) {
                final base = ApiEndpoints.baseUrl.replaceAll('/api/v1', '');
                url = '$base$url';
              }
              return Padding(
                padding: isSignature
                    ? const EdgeInsets.symmetric(horizontal: 4)
                    : const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: isSignature ? Colors.white : Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          _showPhotoPreview(context, url: url, index: index),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        width: isSignature ? 240 : 160,
                        height: 160,
                        fit: isSignature ? BoxFit.contain : BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 160,
                          height: 160,
                          color: c.surface,
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 160,
                          height: 160,
                          color: c.surface,
                          child: Icon(Icons.broken_image_rounded,
                              color: c.onSurfaceVariant),
                        ),
                      ),
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

  Future<void> _showPhotoPreview(
    BuildContext context, {
    required String url,
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
                      child: CachedNetworkImage(
                        imageUrl: url,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white54,
                              size: 48,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No se pudo cargar la imagen',
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
}

class _RegistrarSolucionButton extends StatefulWidget {
  final Future<void> Function()? onRegistrarSolucion;
  final AppColors c;

  const _RegistrarSolucionButton(
      {super.key, required this.onRegistrarSolucion, required this.c});

  @override
  _RegistrarSolucionButtonState createState() =>
      _RegistrarSolucionButtonState();
}

class _RegistrarSolucionButtonState extends State<_RegistrarSolucionButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.c.surface,
        border: Border(
          top: BorderSide(
            color: widget.c.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.c.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: widget.onRegistrarSolucion == null || _isLoading
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await widget.onRegistrarSolucion!();
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
            child: _isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: widget.c.onPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'REGISTRAR SOLUCION',
                    style: TextStyle(
                      color: widget.c.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Outfit',
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
