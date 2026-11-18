import 'dart:async';

import 'package:hydra/data/repositories/os_repository.dart';
import 'package:hydra/data/repositories/supervisor_repository.dart';
import 'package:hydra/domain/models/cuadrilla.dart';
import 'package:hydra/domain/models/gasfitero.dart';
import 'package:hydra/domain/models/os.dart';
import 'package:hydra/domain/models/pending_sync_report.dart';
import 'package:hydra/domain/models/reclamo.dart';

const completedExportOrder = Os(
  id: 7,
  numeroOrden: '0000007',
  estadoOrden: 'COMPLETADO',
  fechaEjecucionInicio: '2026-11-16T13:00:00Z',
  fechaEjecucionFin: '2026-11-16T14:30:00Z',
  trabajoEjecutado:
      'Reemplazo de válvula de paso y verificación de funcionamiento.',
  insumosUtilizados: 'Una válvula de 1/2 pulgada.',
  problemas: 'Válvula deteriorada.',
  soluciones: 'Se reemplazó la válvula.',
  comentariosInstrucciones: 'Verificar el cierre.',
  observacionesGasfitero: 'Servicio restablecido.',
  reclamo: Reclamo(
    id: 2,
    codigoSolicitud: '00123',
    numeroSuministro: '0012345',
    tipoProblema: 'B6',
    nombreSolicitante: 'María Pérez',
    descripcion: 'Fuga en la conexión.',
    direccion: 'Jr. Los Cedros 123',
  ),
  responsable: Gasfitero(id: 1, nombre: 'Luis Ramos'),
  cuadrilla: Cuadrilla(
    id: 3,
    codigoGrupo: 'AG-003',
    lider: Gasfitero(id: 1, nombre: 'Luis Ramos'),
    apoyos: [
      Gasfitero(id: 1, nombre: 'Luis Ramos'),
      Gasfitero(id: 2, nombre: 'José Díaz')
    ],
    chofer: Gasfitero(id: 4, nombre: 'Ana Torres'),
  ),
);

class ExportOsRepository implements OsRepository {
  List<PendingSyncReport> reports = [];
  final changes = StreamController<void>.broadcast();

  @override
  Stream<void> get syncStream => changes.stream;
  @override
  Future<List<PendingSyncReport>> getPendingReports() async => reports;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ExportSupervisorRepository implements SupervisorRepository {
  List<Os> orders = [completedExportOrder];
  Exception? failure;
  Completer<List<Os>>? nextResponse;
  int calls = 0;

  @override
  Future<List<Os>> getOrdenesServicio() async {
    calls++;
    if (failure != null) throw failure!;
    final pending = nextResponse;
    if (pending != null) {
      nextResponse = null;
      return pending.future;
    }
    return orders;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

PendingSyncReport pendingExportReport(int id) => PendingSyncReport(
      osId: id,
      status: 'PENDING_SYNC',
      createdAt: '2026-11-16T14:30:00Z',
      insumosUtilizados: null,
      observacionesGasfitero: null,
      rutaCarpetaEvidencias: null,
      trabajoEjecutado: null,
      problemas: null,
      soluciones: null,
      comentariosInstrucciones: null,
      latitud: null,
      longitud: null,
      fotosProblemaUrls: null,
      fotosSolucionUrls: null,
      fechaEjecucionInicio: null,
      fechaEjecucionFin: null,
    );
