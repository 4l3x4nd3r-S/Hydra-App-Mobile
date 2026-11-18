import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/use_cases/save_os_report_use_case.dart';
import 'package:hydra/data/services/sync_queue_storage_service.dart';
import 'package:hydra/ui/features/os_execution/view_models/os_execution_view_model.dart';

class _FakeSaveOsReportUseCase implements SaveOsReportUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSyncQueueStorageService implements SyncQueueStorageService {
  Map<String, dynamic>? draft;
  String? savedPasosConfirmados;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Map<String, dynamic>?> getDraft(int osId) async => draft;

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
    savedPasosConfirmados = pasosConfirmados;
  }
}

/// Crea el ViewModel y espera a que termine la carga del borrador.
Future<OsExecutionViewModel> _crear({
  Os? os,
  Map<String, dynamic>? draft,
}) async {
  final storage = _FakeSyncQueueStorageService()..draft = draft;
  final vm = OsExecutionViewModel(
    os: os ?? const Os(id: 1),
    saveOsReportUseCase: _FakeSaveOsReportUseCase(),
    syncQueueStorageService: storage,
  );
  await vm.listo;
  return vm;
}

/// O.S. tal como llega del servidor cuando ya tiene ubicación registrada.
const _osConUbicacion = Os(
  id: 1,
  latitud: -12.5964638,
  longitud: -69.1841279,
);

void main() {
  group('Flujo progresivo del formulario', () {
    test('sin ubicación registrada el paso de fotos del problema sigue oculto',
        () async {
      final vm = await _crear();

      expect(vm.ubicacionRegistrada, isFalse);
      expect(vm.mostrarFotosProblema, isFalse);
      expect(vm.mostrarFotosSolucion, isFalse);
      expect(vm.mostrarTrabajo, isFalse);
      expect(vm.mostrarCierre, isFalse);

      vm.dispose();
    });

    test(
        'la ubicación que ya trae la orden se confirma sin volver a tomar el GPS',
        () async {
      // Regresión: la O.S. llega del servidor con la ubicación registrada. El
      // técnico no debe volver a capturar el GPS, pero tampoco se le confirma
      // el paso solo: lo hace con el botón.
      final vm = await _crear(os: _osConUbicacion);

      expect(vm.ubicacionRegistrada, isTrue);
      expect(vm.pasoConfirmado(0), isFalse);
      expect(vm.mostrarFotosProblema, isFalse);
      expect(vm.mensajePendiente, contains('Confirme la ubicación'));

      expect(vm.confirmarPaso(0), isTrue);

      expect(vm.mostrarFotosProblema, isTrue);
      expect(vm.mostrarFotosSolucion, isFalse);
      expect(vm.mostrarTrabajo, isFalse);
      expect(vm.mostrarCierre, isFalse);

      vm.dispose();
    });

    test('un borrador sin confirmaciones no avanza solo', () async {
      final vm = await _crear(
        draft: const {
          'latitud': -12.5964638,
          'longitud': -69.1841279,
        },
      );

      expect(vm.ubicacionRegistrada, isTrue);
      expect(vm.pasoConfirmado(0), isFalse);
      expect(vm.mostrarFotosProblema, isFalse);

      vm.dispose();
    });

    test('un borrador con confirmaciones guardadas restaura el avance',
        () async {
      final vm = await _crear(
        draft: const {
          'latitud': -12.5964638,
          'longitud': -69.1841279,
          'pasos_confirmados': '0',
        },
      );

      expect(vm.pasoConfirmado(0), isTrue);
      expect(vm.mostrarFotosProblema, isTrue);

      vm.dispose();
    });

    test('con una foto del problema confirmada se desbloquea la solución',
        () async {
      final vm = await _crear(
        draft: const {
          'latitud': -12.5964638,
          'longitud': -69.1841279,
          'fotos_problema_urls': '/tmp/problema1.jpg',
          'pasos_confirmados': '0,1',
        },
      );

      expect(vm.mostrarFotosSolucion, isTrue);
      expect(vm.mostrarTrabajo, isFalse);
      expect(vm.mostrarCierre, isFalse);

      vm.dispose();
    });

    test('con una foto de la solución confirmada se desbloquea el trabajo',
        () async {
      final vm = await _crear(
        draft: const {
          'latitud': -12.5964638,
          'longitud': -69.1841279,
          'fotos_problema_urls': '/tmp/problema1.jpg',
          'fotos_solucion_urls': '/tmp/solucion1.jpg',
          'pasos_confirmados': '0,1,2',
        },
      );

      expect(vm.mostrarTrabajo, isTrue);
      expect(vm.mostrarCierre, isFalse);

      vm.dispose();
    });

    test('escribir el trabajo ejecutado no revela el cierre hasta confirmarlo',
        () async {
      final vm = await _crear(
        draft: const {
          'latitud': -12.5964638,
          'longitud': -69.1841279,
          'fotos_problema_urls': '/tmp/problema1.jpg',
          'fotos_solucion_urls': '/tmp/solucion1.jpg',
          'pasos_confirmados': '0,1,2',
        },
      );

      expect(vm.mostrarTrabajo, isTrue);
      expect(vm.mostrarCierre, isFalse);

      vm.trabajoEjecutadoController.text = 'Se reemplazo la valvula de cierre';

      // Escribir no avanza: falta la confirmación explícita del técnico.
      expect(vm.mostrarCierre, isFalse);
      expect(vm.pasoPendiente, 3);

      expect(vm.confirmarPaso(3), isTrue);
      expect(vm.mostrarCierre, isTrue);

      vm.dispose();
    });

    test('un borrador con tipos inesperados no rompe la carga del formulario',
        () async {
      // SQLite puede devolver un int para una columna REAL. La carga no debe
      // abortar y dejar el formulario vacío.
      final vm = await _crear(
        draft: const {
          'latitud': -12,
          'longitud': -69,
          'trabajo_ejecutado': 'trabajo previo',
          'pasos_confirmados': '0',
        },
      );

      expect(vm.ubicacionRegistrada, isTrue);
      expect(vm.mostrarFotosProblema, isTrue);
      expect(vm.trabajoEjecutadoController.text, 'trabajo previo');

      vm.dispose();
    });

    test('un borrador corrupto no deja el formulario inservible', () async {
      final vm = await _crear(
        draft: const {
          'latitud': 'no-es-un-numero',
          'longitud': null,
        },
      );

      // La ubicación inválida se descarta, pero el formulario sigue vivo.
      expect(vm.ubicacionRegistrada, isFalse);
      expect(vm.isDraftLoaded, isTrue);
      expect(vm.mostrarFotosProblema, isFalse);

      vm.dispose();
    });

    test('al fallar el envío se revela solo el paso pendiente', () async {
      final vm = await _crear();

      expect(vm.mostrarFotosProblema, isFalse);

      await vm.submit();

      // El paso 0 (ubicación) ya estaba visible: no se revela de golpe todo
      // lo demás, solo se informa lo que falta.
      expect(vm.mostrarFotosProblema, isFalse);
      expect(vm.mostrarFotosSolucion, isFalse);
      expect(vm.mostrarTrabajo, isFalse);
      expect(vm.mostrarCierre, isFalse);
      expect(vm.errorMsg, isNotNull);

      vm.dispose();
    });
  });

  group('Confirmación explícita de cada paso', () {
    test('confirmar la ubicación es lo que revela las fotos del problema',
        () async {
      // O.S. sin ubicación: el técnico la registra en esta visita.
      final vm = await _crear();

      // Sin datos el paso no se puede confirmar.
      expect(vm.confirmarPaso(0), isFalse);
      expect(vm.showValidationErrors, isTrue);
      expect(vm.mostrarFotosProblema, isFalse);
      expect(vm.mensajePendiente, contains('ubicación'));

      vm.latitud = -12.5964638;
      vm.longitud = -69.1841279;

      // Tener la ubicación no avanza: hay que confirmarla.
      expect(vm.mostrarFotosProblema, isFalse);
      expect(vm.mensajePendiente, contains('Confirme la ubicación'));

      expect(vm.confirmarPaso(0), isTrue);
      expect(vm.pasoConfirmado(0), isTrue);
      expect(vm.mostrarFotosProblema, isTrue);
      expect(vm.mostrarFotosSolucion, isFalse);

      vm.dispose();
    });

    test('agregar una foto no confirma el paso: queda por confirmar', () async {
      // Regresión: al volver de la cámara el formulario se rehidrata desde el
      // borrador. Tener la foto NO debe marcar el paso como confirmado.
      final vm = await _crear(os: _osConUbicacion);

      expect(vm.confirmarPaso(0), isTrue);

      await vm.agregarFotoProblema('/tmp/problema1.jpg');

      expect(vm.pasoConfirmado(1), isFalse);
      expect(vm.mostrarFotosSolucion, isFalse);
      expect(vm.pasoPendiente, 1);
      expect(vm.mensajePendiente, contains('Confirme las fotos del problema'));

      // Recién con el botón avanza.
      expect(vm.confirmarPaso(1), isTrue);
      expect(vm.mostrarFotosSolucion, isTrue);
      expect(vm.mostrarTrabajo, isFalse);

      vm.dispose();
    });

    test('una foto de la solución no revela el trabajo hasta confirmar',
        () async {
      final vm = await _crear(
        draft: const {
          'latitud': -12.5964638,
          'longitud': -69.1841279,
          'fotos_problema_urls': '/tmp/problema1.jpg',
          'pasos_confirmados': '0,1',
        },
      );

      expect(vm.mostrarFotosSolucion, isTrue);
      expect(vm.pasoPendiente, 2);

      await vm.agregarFotoSolucion('/tmp/solucion1.jpg');

      expect(vm.pasoConfirmado(2), isFalse);
      expect(vm.mostrarTrabajo, isFalse);

      expect(vm.confirmarPaso(2), isTrue);
      expect(vm.mostrarTrabajo, isTrue);
      expect(vm.mostrarCierre, isFalse);

      vm.dispose();
    });

    test('si se borra la última foto el paso deja de estar confirmado',
        () async {
      final vm = await _crear(
        draft: const {
          'latitud': -12.5964638,
          'longitud': -69.1841279,
          'fotos_problema_urls': '/tmp/problema1.jpg',
          'pasos_confirmados': '0,1',
        },
      );

      expect(vm.pasoConfirmado(1), isTrue);
      expect(vm.mostrarFotosSolucion, isTrue);

      vm.removeFotoProblema(0);

      expect(vm.pasoConfirmado(1), isFalse);
      expect(vm.pasoPendiente, 1);
      expect(vm.puedeFinalizar, isFalse);

      vm.dispose();
    });

    test('confirmar un paso sin datos muestra qué falta y no avanza', () async {
      final vm = await _crear(os: _osConUbicacion);

      expect(vm.confirmarPaso(1), isFalse);
      expect(vm.showValidationErrors, isTrue);
      expect(vm.mostrarFotosSolucion, isFalse);
      expect(vm.errorMsg, contains('foto del problema'));

      vm.dispose();
    });

    test('las confirmaciones no se deducen de los datos', () async {
      // Un borrador con todos los datos pero sin confirmaciones guardadas:
      // el técnico tiene que revisar y confirmar desde el primer paso.
      final vm = await _crear(
        draft: {
          'latitud': -12.5964638,
          'longitud': -69.1841279,
          'fotos_problema_urls': '/tmp/problema1.jpg',
          'fotos_solucion_urls': '/tmp/solucion1.jpg',
          'trabajo_ejecutado': 'Se reemplazo la valvula de cierre',
          'fecha_ejecucion_fin':
              DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
        },
      );

      expect(vm.pasoConfirmado(0), isFalse);
      expect(vm.pasoPendiente, 0);
      expect(vm.puedeFinalizar, isFalse);

      vm.dispose();
    });

    test('una confirmación guardada no vale si el dato desapareció', () async {
      final vm = await _crear(
        draft: const {
          'latitud': -12.5964638,
          'longitud': -69.1841279,
          'pasos_confirmados': '0,1',
        },
      );

      expect(vm.pasoConfirmado(0), isTrue);
      // El paso 1 decía confirmado, pero ya no hay fotos.
      expect(vm.pasoConfirmado(1), isFalse);
      expect(vm.pasoPendiente, 1);

      vm.dispose();
    });

    test('una confirmación se persiste en el borrador', () async {
      final storage = _FakeSyncQueueStorageService();
      final vm = OsExecutionViewModel(
        os: _osConUbicacion,
        saveOsReportUseCase: _FakeSaveOsReportUseCase(),
        syncQueueStorageService: storage,
      );
      await vm.listo;

      expect(vm.confirmarPaso(0), isTrue);
      expect(vm.pasoConfirmado(0), isTrue);

      await vm.saveDraft();
      expect(storage.savedPasosConfirmados, '0');

      vm.dispose();
    });
  });

  group('Disponibilidad del botón FINALIZAR TAREA', () {
    test('no se puede finalizar mientras falten pasos', () async {
      final vm = await _crear();

      expect(vm.puedeFinalizar, isFalse);
      expect(vm.pasoPendiente, 0);
      expect(vm.mensajePendiente, isNotNull);

      vm.dispose();
    });

    test('el paso pendiente avanza con el progreso del técnico', () async {
      final vm = await _crear(os: _osConUbicacion);

      expect(vm.confirmarPaso(0), isTrue);

      expect(vm.pasoPendiente, 1);
      expect(vm.mensajePendiente, contains('foto del problema'));

      vm.dispose();
    });

    test('se puede finalizar cuando todo lo obligatorio está confirmado',
        () async {
      final vm = await _crear(
        draft: {
          'latitud': -12.5964638,
          'longitud': -69.1841279,
          'fotos_problema_urls': '/tmp/problema1.jpg',
          'fotos_solucion_urls': '/tmp/solucion1.jpg',
          'trabajo_ejecutado': 'Se reemplazo la valvula de cierre',
          'fecha_ejecucion_fin':
              DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
          'pasos_confirmados': '0,1,2,3',
        },
      );

      expect(vm.puedeFinalizar, isTrue);
      expect(vm.pasoPendiente, isNull);
      expect(vm.mensajePendiente, isNull);

      vm.dispose();
    });

    test(
        'revelarPasoPendiente marca el campo pendiente sin abrir de golpe '
        'los pasos posteriores', () async {
      final vm = await _crear(os: _osConUbicacion);
      expect(vm.confirmarPaso(0), isTrue);

      // La ubicación ya está confirmada: el paso pendiente es el de fotos del
      // problema, que ya está visible. No debe abrirse el resto.
      expect(vm.pasoPendiente, 1);
      expect(vm.mostrarFotosProblema, isTrue);
      expect(vm.mostrarFotosSolucion, isFalse);
      expect(vm.showValidationErrors, isFalse);

      vm.revelarPasoPendiente();

      expect(vm.showValidationErrors, isTrue);
      expect(vm.mostrarFotosProblema, isTrue);
      expect(vm.mostrarFotosSolucion, isFalse);
      expect(vm.mostrarTrabajo, isFalse);
      expect(vm.mostrarCierre, isFalse);

      vm.dispose();
    });
  });
}
