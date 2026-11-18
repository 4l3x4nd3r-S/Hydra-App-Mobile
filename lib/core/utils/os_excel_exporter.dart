import 'dart:math' as math;
import 'dart:typed_data';

import 'package:excel_community/excel_community.dart';

import '../../domain/models/gasfitero.dart';
import '../../domain/models/os.dart';

class OsExcelExport {
  const OsExcelExport(
      {required this.bytes, required this.fileName, required this.orderCount});

  final Uint8List bytes;
  final String fileName;
  final int orderCount;
}

class OsExcelExportRequest {
  const OsExcelExportRequest({
    required this.orders,
    required this.generatedAt,
    this.problemDescriptions = const {},
  });

  final List<Os> orders;
  final DateTime generatedAt;
  final Map<String, String> problemDescriptions;
}

/// Builds a native XLSX in an isolate. User-entered values are always text,
/// never formulas; business identifiers retain their leading zeroes.
class OsExcelExporter {
  static const sheetName = 'Órdenes realizadas';
  static const mimeType =
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
  static const headers = [
    'Ítem',
    'N.º de orden',
    'Fecha',
    'Motivo',
    'Acción',
    'Dirección',
    'Reporta',
    'Ejecuta',
    'Cuadrilla',
    'Suministro',
    'Código de solicitud',
    'Descripción del reclamo',
    'Inicio',
    'Finalización',
    'Insumos utilizados',
    'Problemas',
    'Soluciones',
    'Comentarios',
    'Observaciones',
    'Chofer',
    'Estado',
    'ID HYDRA',
  ];
  static const _widths = <double>[
    8,
    18,
    15,
    38,
    58,
    42,
    34,
    46,
    20,
    18,
    22,
    55,
    24,
    24,
    48,
    48,
    48,
    48,
    48,
    32,
    20,
    14,
  ];

  static List<Os> completedOrders(Iterable<Os> orders,
      {Set<int> excludedIds = const {}}) {
    final unique = <int, Os>{};
    for (final os in orders) {
      if (excludedIds.contains(os.id)) continue;
      final state = os.estadoOrden?.trim().toUpperCase();
      // Archiving alone is not proof that an order was executed.
      if (state == 'COMPLETADO' ||
          (state == 'ARCHIVADO' && _date(os.fechaEjecucionFin) != null)) {
        unique.putIfAbsent(os.id, () => os);
      }
    }
    return unique.values.toList()
      ..sort((a, b) {
        final first = _date(a.fechaEjecucionFin);
        final second = _date(b.fechaEjecucionFin);
        if (first == null && second != null) return 1;
        if (first != null && second == null) return -1;
        final byDate = first == null ? 0 : first.compareTo(second!);
        return byDate != 0 ? byDate : a.id.compareTo(b.id);
      });
  }

  static OsExcelExport generate(OsExcelExportRequest request) {
    final orders = completedOrders(request.orders);
    if (orders.isEmpty) {
      throw StateError('No hay órdenes realizadas para exportar.');
    }
    final workbook = Excel.createExcel();
    workbook.rename(workbook.getDefaultSheet()!, sheetName);
    final sheet = workbook[sheetName];
    workbook.setDefaultSheet(sheetName);
    sheet.frozenRows = 1;
    sheet.frozenColumns = 2;
    sheet.appendRow(headers.map(TextCellValue.new).toList());
    sheet.setRowHeight(0, 32);

    final headerStyle = CellStyle(
      fontFamily: 'Arial',
      fontSize: 11,
      bold: true,
      fontColorHex: ExcelColor.white,
      backgroundColorHex: ExcelColor.fromHexString('#0A2472'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      textWrapping: TextWrapping.WrapText,
    );
    for (var col = 0; col < headers.length; col++) {
      sheet.setColumnWidth(col, _widths[col]);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .cellStyle = headerStyle;
    }

    for (var index = 0; index < orders.length; index++) {
      final os = orders[index];
      final claim = os.reclamo;
      final code = claim?.tipoProblema?.trim() ?? '';
      final end = _date(os.fechaEjecucionFin);
      final start = _date(os.fechaEjecucionInicio);
      final row = <CellValue?>[
        IntCellValue(index + 1),
        _text(os.numeroOrden),
        end == null ? null : DateCellValue.fromDateTime(end),
        _text(request.problemDescriptions[code] ?? code),
        _text(os.trabajoEjecutado),
        _text(claim?.direccion),
        _text(claim?.nombreSolicitante),
        _text(_executors(os)),
        _text(os.cuadrilla?.codigoGrupo),
        _text(claim?.numeroSuministro),
        _text(claim?.codigoSolicitud),
        _text(claim?.descripcion),
        start == null ? null : DateTimeCellValue.fromDateTime(start),
        end == null ? null : DateTimeCellValue.fromDateTime(end),
        _text(os.insumosUtilizados),
        _text(os.problemas),
        _text(os.soluciones),
        _text(os.comentariosInstrucciones),
        _text(os.observacionesGasfitero),
        _text(os.cuadrilla?.chofer?.nombre),
        _text(os.estadoOrden),
        IntCellValue(os.id),
      ];
      sheet.appendRow(row);
      var maxLines = 1;
      for (var col = 0; col < row.length; col++) {
        final value = row[col];
        if (value is TextCellValue) {
          final lines = (value.value.text ?? '').split('\n').fold<int>(
              0,
              (total, line) =>
                  total +
                  math.max(1, (line.length / (_widths[col] - 3)).ceil()));
          maxLines = math.max(maxLines, lines);
        }
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: col, rowIndex: index + 1))
            .cellStyle = CellStyle(
          fontFamily: 'Arial',
          fontSize: 11,
          fontColorHex: ExcelColor.fromHexString('#0F172A'),
          backgroundColorHex:
              ExcelColor.fromHexString(index.isEven ? '#FFFFFF' : '#F1F5F9'),
          horizontalAlign: value is IntCellValue
              ? HorizontalAlign.Right
              : HorizontalAlign.Left,
          verticalAlign: VerticalAlign.Top,
          textWrapping: TextWrapping.WrapText,
          numberFormat: col == 2
              ? NumFormat.custom(formatCode: 'dd/mm/yyyy')
              : col == 12 || col == 13
                  ? NumFormat.custom(formatCode: 'dd/mm/yyyy hh:mm')
                  : value is TextCellValue
                      ? NumFormat.custom(formatCode: '@')
                      : NumFormat.standard_0,
        );
      }
      sheet.setRowHeight(index + 1,
          math.min(409, math.max(32, maxLines * 16 + 10)).toDouble());
    }
    sheet.setAutoFilterByString('A1:V${orders.length + 1}');
    final bytes = workbook.encode();
    if (bytes == null || bytes.isEmpty) {
      throw StateError('No se pudo generar el archivo Excel.');
    }
    final date = request.generatedAt;
    String two(int value) => value.toString().padLeft(2, '0');
    final stamp =
        '${date.year}${two(date.month)}${two(date.day)}_${two(date.hour)}${two(date.minute)}${two(date.second)}';
    return OsExcelExport(
      bytes: Uint8List.fromList(bytes),
      fileName: 'HYDRA_ordenes_realizadas_$stamp.xlsx',
      orderCount: orders.length,
    );
  }

  static TextCellValue _text(String? value) =>
      TextCellValue(value?.trim() ?? '');

  static String _executors(Os os) {
    final people = <Gasfitero>[
      if (os.responsable != null)
        os.responsable!
      else if (os.cuadrilla?.lider != null)
        os.cuadrilla!.lider!,
      ...?os.cuadrilla?.apoyos,
    ];
    final ids = <int>{};
    return people
        .where((person) => ids.add(person.id))
        .map((person) => person.nombre?.trim() ?? '')
        .where((name) => name.isNotEmpty)
        .join(' / ');
  }

  /// Server instants are represented in the company's Peru time (UTC-5).
  /// Naive historical timestamps already describe local working time.
  static DateTime? _date(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return null;
    if (!parsed.isUtc) return parsed;
    final peru = parsed.subtract(const Duration(hours: 5));
    return DateTime(
        peru.year, peru.month, peru.day, peru.hour, peru.minute, peru.second);
  }
}
