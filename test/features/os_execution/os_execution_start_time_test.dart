import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/data/services/sync_queue_storage_service.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/use_cases/save_os_report_use_case.dart';
import 'package:hydra/ui/features/os_execution/view_models/os_execution_view_model.dart';

class _SaveReport implements SaveOsReportUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DraftStorage implements SyncQueueStorageService {
  Map<String, dynamic>? draft;
  Completer<Map<String, dynamic>?>? pendingRead;
  int saves = 0;

  @override
  Future<Map<String, dynamic>?> getDraft(int osId) async {
    if (pendingRead != null) return pendingRead!.future;
    return draft;
  }

  @override
  Future<void> saveDraft({
    required int osId,
    String? insumosUtilizados,
    String? observacionesGasfitero,
    String? rutaCarpetaEvidencias,
    String? trabajoEjecutado,
    String? problemas,
    String? soluciones,
    String? comentariosInstrucciones,
    double? latitud,
    double? longitud,
    String? fotosProblemaUrls,
    String? fotosSolucionUrls,
    String? fechaEjecucionInicio,
    String? fechaEjecucionFin,
    String? pasosConfirmados,
  }) async {
    saves++;
    draft = {
      'trabajo_ejecutado': trabajoEjecutado,
      'insumos_utilizados': insumosUtilizados,
      'observaciones_gasfitero': observacionesGasfitero,
      'ruta_carpeta_evidencias': rutaCarpetaEvidencias,
      'problemas': problemas,
      'comentarios_instrucciones': comentariosInstrucciones,
      'latitud': latitud,
      'longitud': longitud,
      'fotos_problema_urls': fotosProblemaUrls,
      'fotos_solucion_urls': fotosSolucionUrls,
      'fecha_ejecucion_inicio': fechaEjecucionInicio,
      'fecha_ejecucion_fin': fechaEjecucionFin,
      'pasos_confirmados': pasosConfirmados,
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late DateTime now;
  late _DraftStorage storage;
  setUp(() {
    now = DateTime(2026, 11, 17, 11, 17);
    storage = _DraftStorage();
  });

  OsExecutionViewModel create({String? serverStart}) => OsExecutionViewModel(
        os: Os(id: 1, fechaEjecucionInicio: serverStart),
        saveOsReportUseCase: _SaveReport(),
        syncQueueStorageService: storage,
        clock: () => now,
      );

  test('una orden nueva registra la hora al abrir y la guarda antes de editar',
      () async {
    final vm = create();
    await vm.listo;
    expect(vm.fechaInicio, now);
    expect(storage.saves, 1);
    expect(storage.draft?['fecha_ejecucion_inicio'],
        now.toUtc().toIso8601String());
    expect(vm.fechaInicio?.isUtc, isFalse);
    vm.dispose();
  });

  test(
      'la carga lenta del borrador no cambia el instante en que se abrió el formulario',
      () async {
    final openedAt = now;
    storage.pendingRead = Completer<Map<String, dynamic>?>();
    final vm = create();
    now = now.add(const Duration(minutes: 3));
    storage.pendingRead!.complete(null);
    await vm.listo;
    expect(vm.fechaInicio, openedAt);
    expect(storage.draft?['fecha_ejecucion_inicio'],
        openedAt.toUtc().toIso8601String());
    vm.dispose();
  });

  test('una hora del servidor sin zona no adelanta el inicio a las 15:46',
      () async {
    final vm = create(serverStart: '2026-11-17T15:46:00');
    await vm.listo;
    expect(vm.fechaInicio, now);
    expect(vm.fechaInicio!.isAfter(now), isFalse);
    vm.dispose();
  });

  for (final offset in ['Z', '+00:00']) {
    test(
        'restaura un inicio previo con zona $offset convirtiéndolo a la hora local',
        () async {
      final startedAt = now.subtract(const Duration(minutes: 31));
      final server =
          startedAt.toUtc().toIso8601String().replaceFirst('Z', offset);
      final vm = create(serverStart: server);
      await vm.listo;
      expect(vm.fechaInicio, startedAt);
      expect(vm.fechaInicio?.isUtc, isFalse);
      vm.dispose();
    });
  }

  test(
      'reabrir conserva el inicio original aunque no se haya completado ningún campo',
      () async {
    final first = create();
    await first.listo;
    final originalStart = first.fechaInicio;
    first.dispose();
    now = now.add(const Duration(hours: 1));
    final reopened = create(serverStart: '2026-11-17T18:17:00');
    await reopened.listo;
    expect(reopened.fechaInicio, originalStart);
    expect(storage.saves, 1);
    reopened.dispose();
  });

  test(
      'corrige un borrador con inicio futuro conservando fotos, trabajo y confirmaciones',
      () async {
    storage.draft = {
      'fecha_ejecucion_inicio':
          now.add(const Duration(hours: 5)).toUtc().toIso8601String(),
      'trabajo_ejecutado': 'Trabajo previamente registrado',
      'fotos_problema_urls': '/problem.jpg',
      'fotos_solucion_urls': '/solution.jpg',
      'latitud': -12.59,
      'longitud': -69.18,
      'pasos_confirmados': '0,1',
    };
    final vm = create();
    await vm.listo;
    expect(vm.fechaInicio, now);
    expect(
        vm.trabajoEjecutadoController.text, 'Trabajo previamente registrado');
    expect(vm.fotosProblema, ['/problem.jpg']);
    expect(vm.fotosSolucion, ['/solution.jpg']);
    expect(vm.pasoConfirmado(0), isTrue);
    expect(vm.pasoConfirmado(1), isTrue);
    expect(storage.draft?['fecha_ejecucion_inicio'],
        now.toUtc().toIso8601String());
    expect(
        storage.draft?['trabajo_ejecutado'], 'Trabajo previamente registrado');
    vm.dispose();
  });

  test(
      'un inicio futuro con zona explícita también se reemplaza por la hora real',
      () async {
    final vm = create(
        serverStart:
            now.add(const Duration(hours: 5)).toUtc().toIso8601String());
    await vm.listo;
    expect(vm.fechaInicio, now);
    vm.dispose();
  });

  test('la edición no permite guardar una hora de inicio futura', () async {
    final vm = create();
    await vm.listo;
    expect(vm.updateFechaInicio(now.add(const Duration(minutes: 1))), isFalse);
    expect(vm.fechaInicio, now);
    expect(vm.errorMsg, contains('hora actual'));
    expect(storage.saves, 1);
    final corrected = now.subtract(const Duration(minutes: 10));
    expect(vm.updateFechaInicio(corrected), isTrue);
    expect(vm.fechaInicio, corrected);
    expect(vm.errorMsg, isNull);
    expect(storage.draft?['fecha_ejecucion_inicio'],
        corrected.toUtc().toIso8601String());
    vm.dispose();
  });
}
