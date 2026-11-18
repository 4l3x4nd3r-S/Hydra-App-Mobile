import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/data/services/app_environment.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math' as math;

import 'dart:typed_data';

class OsPdfGenerator {
  static Future<Uint8List> generate(Os os) async {
    final pdf = pw.Document();

    final logoData = await rootBundle.load('assets/images/emapat-logo.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    // Try to load images concurrently
    final List<pw.ImageProvider> fotosProblema = [];
    final List<pw.ImageProvider> fotosSolucion = [];

    for (var url in os.fotosProblemaUrls) {
      if (!url.startsWith('http')) {
        url = '${AppEnvironment.apiBaseUrl.replaceAll('/api/v1', '')}$url';
      }
      try {
        final img = await networkImage(url);
        fotosProblema.add(img);
      } catch (e) {
        // Ignorar si falla
      }
    }
    
    for (var url in os.fotosSolucionUrls) {
      if (url.contains('/firma') || url.contains('signature')) continue;
      if (!url.startsWith('http')) {
        url = '${AppEnvironment.apiBaseUrl.replaceAll('/api/v1', '')}$url';
      }
      try {
        final img = await networkImage(url);
        fotosSolucion.add(img);
      } catch (e) {
        // Ignorar si falla
      }
    }

    pw.Widget? mapWidget;
    if (os.latitud != null && os.longitud != null) {
      mapWidget = await _buildCustomStaticMap(os.latitud!, os.longitud!);
    }

    pw.Widget? signatureWidget;
    try {
      final tempDir = await getTemporaryDirectory();
      final sigFile = File('${tempDir.path}/signature_${os.id}.png');
      if (await sigFile.exists()) {
        final bytes = await sigFile.readAsBytes();
        signatureWidget = pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.contain);
      }
    } catch (e) {
      // Ignorar si falla la carga de la firma
    }

    final List<pw.Widget> mainContent = [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Información del Reclamo'),
                _buildInfoRow('Solicitante', os.reclamo?.nombreSolicitante ?? 'N/A'),
                _buildInfoRow('Código Solicitud', os.reclamo?.codigoSolicitud ?? 'N/A'),
                _buildInfoRow('Dirección', os.reclamo?.direccion ?? 'N/A'),
                _buildInfoRow('Suministro', os.reclamo?.numeroSuministro ?? 'N/A'),
                _buildInfoRow('Problema', _getTipoProblemaLabel(os.reclamo?.tipoProblema)),
                _buildInfoRow('Descripción', os.reclamo?.descripcion ?? 'N/A'),
              ]
            )
          ),
          pw.SizedBox(width: 16),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Datos de Ejecución'),
                _buildInfoRow('Cuadrilla', os.cuadrilla?.codigoGrupo ?? 'N/A'),
                _buildInfoRow('Responsable', os.cuadrilla?.lider?.nombre?.trim() ?? os.responsable?.nombre?.trim() ?? 'N/A'),
                if (os.cuadrilla?.apoyos.isNotEmpty == true && os.cuadrilla!.apoyos.map((a) => a.nombre?.trim() ?? '').where((n) => n.isNotEmpty).join(', ').isNotEmpty)
                  _buildInfoRow('Apoyo', os.cuadrilla!.apoyos.map((a) => a.nombre?.trim() ?? '').where((n) => n.isNotEmpty).join(', ')),
                _buildInfoRow('Inicio', _formatDate(os.fechaEjecucionInicio)),
                _buildInfoRow('Fin', _formatDate(os.fechaEjecucionFin)),
              ]
            )
          )
        ]
      ),
      pw.SizedBox(height: 12),
      
      _buildSectionTitle('Reporte de Trabajo'),
      pw.TableHelper.fromTextArray(
        context: null, // table inside MultiPage will get context automatically or we can just omit it if not needed, actually fromTextArray requires Context context
        border: pw.TableBorder.all(color: PdfColors.grey300),
        columnWidths: {
          0: const pw.FlexColumnWidth(1),
          1: const pw.FlexColumnWidth(2.5),
        },
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
        cellStyle: const pw.TextStyle(fontSize: 10),
        data: [
          ['Concepto', 'Descripción'],
          ['Trabajo Ejecutado', os.trabajoEjecutado ?? ''],
          ['Problemas Encontrados', os.problemas ?? ''],
          ['Insumos Utilizados', os.insumosUtilizados ?? ''],
          ['Observaciones', os.observacionesGasfitero ?? ''],
        ].where((row) => row[1].toString().trim().isNotEmpty).toList(),
      ),
      pw.SizedBox(height: 12),
    ];

    if (mapWidget != null) {
      mainContent.add(
        pw.Wrap(
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Ubicación'),
                pw.Center(
                  child: mapWidget,
                ),
                pw.SizedBox(height: 12),
              ],
            )
          ]
        )
      );
    }

    final List<pw.Widget> photoContent = [];
    
    if (fotosProblema.isNotEmpty) {
      photoContent.add(
        pw.Wrap(
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Evidencias del Problema'),
                pw.Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: fotosProblema.map((img) => pw.Container(
                    width: 190,
                    height: 190,
                    child: pw.Image(img, fit: pw.BoxFit.contain),
                  )).toList(),
                ),
                pw.SizedBox(height: 12),
              ],
            )
          ]
        )
      );
    }
    
    if (fotosSolucion.isNotEmpty) {
      photoContent.add(
        pw.Wrap(
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Evidencias de la Solución'),
                pw.Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: fotosSolucion.map((img) => pw.Container(
                    width: 190,
                    height: 190,
                    child: pw.Image(img, fit: pw.BoxFit.contain),
                  )).toList(),
                ),
                pw.SizedBox(height: 12),
              ],
            )
          ]
        )
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(os, logoImage),
        footer: (context) => _buildFooter(context),
        build: (context) {
          // Actualizamos el contexto de la tabla inyectándolo de nuevo
          final tableIndex = mainContent.indexWhere((w) => w is pw.Table);
          if (tableIndex != -1) {
            mainContent[tableIndex] = pw.TableHelper.fromTextArray(
              context: context,
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(2.5),
              },
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              cellStyle: const pw.TextStyle(fontSize: 10),
              data: [
                ['Concepto', 'Descripción'],
                ['Trabajo Ejecutado', os.trabajoEjecutado ?? ''],
                ['Problemas Encontrados', os.problemas ?? ''],
                ['Insumos Utilizados', os.insumosUtilizados ?? ''],
                ['Observaciones', os.observacionesGasfitero ?? ''],
              ].where((row) => row[1].toString().trim().isNotEmpty).toList(),
            );
          }
          return [
            ...mainContent,
            ...photoContent,
            pw.SizedBox(height: 40),
            _buildSignatures(signatureWidget),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    try {
      final d = DateTime.parse(date);
      final months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
      final month = months[d.month - 1];
      final ampm = d.hour < 12 ? 'AM' : 'PM';
      final hour12 = d.hour == 0 ? 12 : (d.hour > 12 ? d.hour - 12 : d.hour);
      final minute = d.minute.toString().padLeft(2, '0');
      return '${d.day} de $month, $hour12:$minute $ampm';
    } catch (e) {
      return date;
    }
  }

  static String _getTipoProblemaLabel(String? code) {
    if (code == null || code.isEmpty) return 'N/A';
    final map = {
      'B6': 'Alcantarillado · Atoro',
      'OP-1': 'Obras inconclusas',
      'OP-2': 'Fugas en red de agua potable e inundaciones',
      'B12': 'Alcantarillado · Buzón sin tapa',
    };
    for (final key in map.keys) {
      if (code.toUpperCase().contains(key)) {
        return '$code - ${map[key]}';
      }
    }
    return code;
  }

  static pw.Widget _buildHeader(Os os, pw.MemoryImage logo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(logo, width: 80, height: 80),
            pw.Expanded(
              child: pw.Center(
                child: pw.Text(
                  'REPORTE DE ORDEN DE SERVICIO',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ),
            pw.Text(
              'N° ${os.numeroOrden ?? os.id}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Divider(color: PdfColors.blue900, thickness: 2),
        pw.SizedBox(height: 16),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text('Página ${context.pageNumber} de ${context.pagesCount}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSignatures(pw.Widget? userSignatureWidget) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          _buildSignatureBlock('Responsable Técnico'),
          _buildSignatureBlock('Jefe de Mantenimiento'),
          _buildSignatureBlock('Conformidad del Usuario', signatureWidget: userSignatureWidget),
        ],
      ),
    );
  }

  static pw.Widget _buildSignatureBlock(String title, {pw.Widget? signatureWidget}) {
    return pw.Column(
      children: [
        pw.Container(
          width: 140,
          height: 60,
          alignment: pw.Alignment.bottomCenter,
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(width: 1, color: PdfColors.black),
            ),
          ),
          child: signatureWidget ?? pw.SizedBox(),
        ),
        pw.SizedBox(height: 8),
        pw.Text(title, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
      ],
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8, top: 8),
      child: pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(6),
        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
        child: pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
        ),
      ),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text('$label:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          ),
          pw.Expanded(
            child: pw.Text(value.isEmpty ? 'N/A' : value, style: const pw.TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  static Future<pw.Widget> _buildCustomStaticMap(double lat, double lon) async {
    const int zoom = 16;
    double deg2rad(double deg) => deg * (math.pi / 180.0);
    double exactX = (lon + 180.0) / 360.0 * (1 << zoom);
    final latRad = deg2rad(lat);
    double exactY = (1.0 - (math.log(math.tan(latRad) + (1 / math.cos(latRad))) / math.pi)) / 2.0 * (1 << zoom);

    int centerX = exactX.floor();
    int centerY = exactY.floor();
    double offsetX = (exactX - centerX) * 256.0;
    double offsetY = (exactY - centerY) * 256.0;

    List<Future<pw.Widget>> futures = [];
    for (int y = centerY - 1; y <= centerY + 1; y++) {
      for (int x = centerX - 1; x <= centerX + 1; x++) {
        futures.add(_fetchTile(x, y, zoom));
      }
    }
    List<pw.Widget> tiles = await Future.wait(futures);

    final grid = pw.Column(
      children: [
        pw.Row(children: [tiles[0], tiles[1], tiles[2]]),
        pw.Row(children: [tiles[3], tiles[4], tiles[5]]),
        pw.Row(children: [tiles[6], tiles[7], tiles[8]]),
      ],
    );

    double left = 200.0 - (256.0 + offsetX);
    double top = 80.0 - (256.0 + offsetY);

    const svg = '''
      <svg viewBox="0 0 24 24" width="24" height="24" xmlns="http://www.w3.org/2000/svg">
        <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z" fill="#EA4335"/>
      </svg>
    ''';

    return pw.Container(
      width: 400,
      height: 160,
      color: PdfColors.grey200,
      child: pw.ClipRect(
        child: pw.Stack(
          children: [
            pw.Positioned(
              left: left,
              top: top,
              child: pw.SizedBox(width: 768, height: 768, child: grid),
            ),
            pw.Positioned(
              left: 200 - 12,
              top: 80 - 24,
              child: pw.SvgImage(svg: svg, width: 24, height: 24),
            )
          ],
        ),
      ),
    );
  }

  static Future<pw.Widget> _fetchTile(int x, int y, int z) async {
    final url = AppEnvironment.mapTileUrl
        .replaceAll('{s}', 'a')
        .replaceAll('{z}', '$z')
        .replaceAll('{x}', '$x')
        .replaceAll('{y}', '$y');
    try {
      final img = await networkImage(url);
      return pw.Image(img, width: 256, height: 256, fit: pw.BoxFit.fill);
    } catch (e) {
      return pw.Container(width: 256, height: 256, color: PdfColors.grey300);
    }
  }
}
