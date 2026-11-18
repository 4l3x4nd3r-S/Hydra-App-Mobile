import 'dart:io';

import 'package:excel_community/excel_community.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/core/utils/os_excel_exporter.dart';
import 'package:hydra/domain/models/os.dart';

import '../../helpers/os_export_fixtures.dart';

OsExcelExport _generate(List<Os> orders) =>
    OsExcelExporter.generate(OsExcelExportRequest(
      orders: orders,
      generatedAt: DateTime(2026, 11, 16, 12, 30),
      problemDescriptions: const {'B6': 'Alcantarillado: atoro'},
    ));

void main() {
  test(
      'exporta una fila por orden realizada, sin duplicados ni órdenes activas',
      () {
    final archive =
        completedExportOrder.copyWith(id: 8, estadoOrden: 'ARCHIVADO');
    final orders = [
      completedExportOrder,
      completedExportOrder,
      archive,
      completedExportOrder.copyWith(id: 9, estadoOrden: 'ASIGNADO'),
      completedExportOrder.copyWith(id: 10, estadoOrden: 'EN_PROCESO'),
      completedExportOrder.copyWith(
          id: 11, estadoOrden: 'PENDIENTE DE SINCRONIZAR'),
      completedExportOrder.copyWith(
          id: 12, estadoOrden: 'ARCHIVADO', fechaEjecucionFin: null),
    ];
    final report = _generate(orders);
    final workbook = Excel.decodeBytes(report.bytes);
    final sheet = workbook[OsExcelExporter.sheetName];
    expect(report.orderCount, 2);
    expect(sheet.maxRows, 3);
    expect(sheet.rows.first.take(8).map((cell) => cell?.value.toString()), [
      'Ítem',
      'N.º de orden',
      'Fecha',
      'Motivo',
      'Acción',
      'Dirección',
      'Reporta',
      'Ejecuta',
    ]);
    expect(sheet.rows[1][21]?.value, const IntCellValue(7));
    expect(sheet.rows[2][21]?.value, const IntCellValue(8));
    expect(workbook.tables.keys, [OsExcelExporter.sheetName]);
    expect(sheet.frozenRows, 1);
    expect(sheet.frozenColumns, 2);
    expect(sheet.hasAutoFilter, isTrue);
  });

  test('conserva identificadores, tildes, responsables y datos del trabajo',
      () {
    final report = _generate([completedExportOrder]);
    final sheet = Excel.decodeBytes(report.bytes)[OsExcelExporter.sheetName];
    final row = sheet.rows[1];
    expect(row[1]?.value, TextCellValue('0000007'));
    expect(row[3]?.value, TextCellValue('Alcantarillado: atoro'));
    expect(
        row[4]?.value, TextCellValue(completedExportOrder.trabajoEjecutado!));
    expect(row[6]?.value, TextCellValue('María Pérez'));
    expect(row[7]?.value, TextCellValue('Luis Ramos / José Díaz'));
    expect(row[9]?.value, TextCellValue('0012345'));
    expect(row[10]?.value, TextCellValue('00123'));
    expect(row[19]?.value, TextCellValue('Ana Torres'));
    expect(report.fileName, 'HYDRA_ordenes_realizadas_20261116_123000.xlsx');
    if (const bool.fromEnvironment('WRITE_OS_EXPORT_SAMPLE')) {
      Directory('build/export_previews').createSync(recursive: true);
      final extra = completedExportOrder.copyWith(
        id: 8,
        numeroOrden: '0000008',
        trabajoEjecutado:
            'Limpieza de la conexión y comprobación del servicio.',
        fechaEjecucionFin: '2026-11-17T14:00:00Z',
      );
      File('build/export_previews/ordenes_realizadas.xlsx')
          .writeAsBytesSync(_generate([completedExportOrder, extra]).bytes);
    }
  });

  test(
      'las fechas son valores Excel en horario de Perú, ordenados por finalización',
      () {
    final earlier = completedExportOrder.copyWith(
        id: 8, fechaEjecucionFin: '2026-11-16T02:30:00Z');
    final sheet =
        Excel.decodeBytes(_generate([completedExportOrder, earlier]).bytes)[
            OsExcelExporter.sheetName];
    expect(sheet.rows[1][2]?.value,
        const DateCellValue(year: 2026, month: 11, day: 15));
    expect(
        sheet.rows[1][13]?.value,
        const DateTimeCellValue(
            year: 2026, month: 11, day: 15, hour: 21, minute: 30));
    expect(sheet.rows[1][21]?.value, const IntCellValue(8));
    expect(
        sheet.rows[2][12]?.value,
        const DateTimeCellValue(
            year: 2026, month: 11, day: 16, hour: 8, minute: 0));
  });

  test('los textos que empiezan con igual permanecen como texto literal', () {
    final order = completedExportOrder.copyWith(trabajoEjecutado: '=1+1');
    final sheet =
        Excel.decodeBytes(_generate([order]).bytes)[OsExcelExporter.sheetName];
    expect(sheet.rows[1][4]?.value, TextCellValue('=1+1'));
    expect(
        sheet.rows
            .expand((row) => row)
            .any((cell) => cell?.value is FormulaCellValue),
        isFalse);
  });

  test('no inventa números de orden ni fechas cuando faltan datos', () {
    const order = Os(
        id: 99, estadoOrden: 'COMPLETADO', fechaEjecucionFin: 'fecha inválida');
    final sheet =
        Excel.decodeBytes(_generate([order]).bytes)[OsExcelExporter.sheetName];
    expect(sheet.rows[1][1]?.value?.toString() ?? '', isEmpty);
    expect(sheet.rows[1][2]?.value, isNull);
    expect(sheet.rows[1][21]?.value, const IntCellValue(99));
  });

  test('exporta todos los registros recibidos sin recortar a una página', () {
    final orders = List.generate(
        175, (index) => completedExportOrder.copyWith(id: index + 1));
    final report = _generate(orders);
    expect(report.orderCount, 175);
    expect(Excel.decodeBytes(report.bytes)[OsExcelExporter.sheetName].maxRows,
        176);
  });

  test(
      'rechaza exportaciones vacías y permite excluir reportes sin sincronizar',
      () {
    expect(() => _generate([]), throwsStateError);
    expect(
        OsExcelExporter.completedOrders([completedExportOrder],
            excludedIds: {7}),
        isEmpty);
  });
}
