import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/os_dto.dart';
import '../models/cuadrilla_dto.dart';
import '../models/gasfitero_dto.dart';
import '../services/os_api_service.dart';
import '../services/sync_queue_storage_service.dart';
import '../../domain/models/os.dart';
import '../../domain/models/cuadrilla.dart';
import '../../domain/models/gasfitero.dart';
import '../../domain/models/reclamo.dart';
import '../../domain/models/pending_sync_report.dart';

import '../models/reclamo_dto.dart';

class OsRepository {
  final OsApiService _osApiService;
  final SyncQueueStorageService _syncQueueStorage;

  final StreamController<void> _syncController =
      StreamController<void>.broadcast();

  Stream<void> get syncStream => _syncController.stream;

  OsRepository({
    required OsApiService osApiService,
    required SyncQueueStorageService syncQueueStorage,
  })  : _osApiService = osApiService,
        _syncQueueStorage = syncQueueStorage;

  Future<List<Os>> getAssignedOrders() async {
    final response = await _osApiService.getOrdenes();
    if (response.statusCode == 200 && response.data is List) {
      final list = (response.data as List)
          .map((json) => OsDto.fromJson(json as Map<String, dynamic>))
          .map(_toDomain)
          .toList();
      return list;
    }
    return [];
  }

  Future<void> startOrder(int ordenId) async {
    await _osApiService.iniciarOrden(ordenId);
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      final response = await _osApiService.uploadImage(filePath);
      if (response.statusCode == 200) {
        return response.data['url'] as String;
      }
    } catch (e) {
      // Ignore
    }
    return null;
  }

  Future<void> saveReportOffline({
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
  }) async {
    await _syncQueueStorage.insertPending(
      osId: osId,
      insumosUtilizados: insumosUtilizados,
      observacionesGasfitero: observacionesGasfitero,
      rutaCarpetaEvidencias: rutaCarpetaEvidencias,
      trabajoEjecutado: trabajoEjecutado,
      problemas: problemas,
      soluciones: soluciones,
      comentariosInstrucciones: comentariosInstrucciones,
      latitud: latitud,
      longitud: longitud,
      fotosProblemaUrls: fotosProblemaUrls,
      fotosSolucionUrls: fotosSolucionUrls,
      fechaEjecucionInicio: fechaEjecucionInicio,
      fechaEjecucionFin: fechaEjecucionFin,
    );
    _syncController.add(null);
  }

  Future<List<PendingSyncReport>> getPendingReports() async {
    final results = await _syncQueueStorage.getAll();
    return results.map((r) => _pendingFromMap(r)).toList();
  }

  Future<void> triggerSync() async {
    final pending = await _syncQueueStorage.getPending();
    if (pending.isEmpty) return;

    for (final report in pending) {
      try {
        final osId = report['os_id'] as int;
        List<String>? fotosProblema;
        if (report['fotos_problema_urls'] != null && report['fotos_problema_urls'].toString().isNotEmpty) {
          fotosProblema = (report['fotos_problema_urls'] as String).split(',');
          for (int i = 0; i < fotosProblema.length; i++) {
            if (!fotosProblema[i].startsWith('/uploads') && !fotosProblema[i].startsWith('http')) {
              final newUrl = await uploadImage(fotosProblema[i]);
              if (newUrl != null) fotosProblema[i] = newUrl;
            }
          }
        }

        List<String>? fotosSolucion;
        if (report['fotos_solucion_urls'] != null && report['fotos_solucion_urls'].toString().isNotEmpty) {
          fotosSolucion = (report['fotos_solucion_urls'] as String).split(',');
          for (int i = 0; i < fotosSolucion.length; i++) {
            if (!fotosSolucion[i].startsWith('/uploads') && !fotosSolucion[i].startsWith('http')) {
              final newUrl = await uploadImage(fotosSolucion[i]);
              if (newUrl != null) fotosSolucion[i] = newUrl;
            }
          }
        }

        final response = await _osApiService.finalizarOrden(
          osId,
          {
            'insumos_utilizados': report['insumos_utilizados'],
            'observaciones_gasfitero': report['observaciones_gasfitero'],
            'ruta_carpeta_evidencias': report['ruta_carpeta_evidencias'],
            'trabajo_ejecutado': report['trabajo_ejecutado'],
            'problemas': report['problemas'],
            'soluciones': report['soluciones'],
            'comentarios_instrucciones': report['comentarios_instrucciones'],
            'latitud': report['latitud'],
            'longitud': report['longitud'],
            'fotos_problema_urls': fotosProblema,
            'fotos_solucion_urls': fotosSolucion,
            'fecha_ejecucion_inicio': report['fecha_ejecucion_inicio'],
            'fecha_ejecucion_fin': report['fecha_ejecucion_fin'],
          },
        );

        if (response.statusCode == 200) {
          await _syncQueueStorage.markSynced(osId);
          _syncController.add(null);
        }
      } catch (_) {}
    }
  }

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  void startAutoSync() {
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        triggerSync();
      }
    });
  }

  void dispose() {
    _connectivitySub?.cancel();
    _syncController.close();
  }

  Os _toDomain(OsDto dto) {
    return Os(
      id: dto.id,
      numeroOrden: dto.numeroOrden,
      reclamoId: dto.reclamoId,
      supervisorId: dto.supervisorId,
      cuadrillaId: dto.cuadrillaId,
      sectorId: dto.sectorId,
      fechaProgramacion: dto.fechaProgramacion,
      fechaEjecucionInicio: dto.fechaEjecucionInicio,
      fechaEjecucionFin: dto.fechaEjecucionFin,
      estadoOrden: dto.estadoOrden,
      insumosUtilizados: dto.insumosUtilizados,
      observacionesGasfitero: dto.observacionesGasfitero,
      rutaCarpetaEvidencias: dto.rutaCarpetaEvidencias,
      createdAt: dto.createdAt,
      trabajoEjecutado: dto.trabajoEjecutado,
      problemas: dto.problemas,
      soluciones: dto.soluciones,
      comentariosInstrucciones: dto.comentariosInstrucciones,
      latitud: dto.latitud,
      longitud: dto.longitud,
      fotosProblemaUrls: dto.fotosProblemaUrls,
      fotosSolucionUrls: dto.fotosSolucionUrls,
      reclamo: dto.reclamo != null ? _reclamoToDomain(dto.reclamo!) : null,
      cuadrilla: dto.cuadrilla != null ? _cuadrillaToDomain(dto.cuadrilla!) : null,
    );
  }

  Reclamo _reclamoToDomain(ReclamoDto dto) {
    return Reclamo(
      id: dto.id,
      formato: dto.formato,
      codigoSolicitud: dto.codigoSolicitud,
      fechaRegistro: dto.fechaRegistro,
      canalEntrada: dto.canalEntrada,
      tipoProblema: dto.tipoProblema,
      estado: dto.estado,
      descripcion: dto.descripcion,
      nombreSolicitante: dto.nombreSolicitante,
      direccion: dto.direccion,
      numeroMedidor: dto.numeroMedidor,
      telefono: dto.telefono,
      email: dto.email,
    );
  }

  Cuadrilla _cuadrillaToDomain(CuadrillaDto dto) {
    return Cuadrilla(
      id: dto.id,
      codigoGrupo: dto.codigoGrupo,
      especialidad: dto.especialidad,
      lider: dto.lider != null ? _gasfiteroToDomain(dto.lider!) : null,
      apoyos: dto.apoyos.map(_gasfiteroToDomain).toList(),
      chofer: dto.chofer != null ? _gasfiteroToDomain(dto.chofer!) : null,
      operador: dto.operador != null ? _gasfiteroToDomain(dto.operador!) : null,
    );
  }

  Gasfitero _gasfiteroToDomain(GasfiteroDto dto) {
    return Gasfitero(
      id: dto.id,
      nombre: dto.nombre,
      codigoEmpleado: dto.codigoEmpleado,
      cargo: dto.cargo,
      area: dto.area,
    );
  }

  PendingSyncReport _pendingFromMap(Map<String, dynamic> r) {
    return PendingSyncReport(
      osId: r['os_id'] as int,
      insumosUtilizados: r['insumos_utilizados'] as String?,
      observacionesGasfitero: r['observaciones_gasfitero'] as String?,
      rutaCarpetaEvidencias: r['ruta_carpeta_evidencias'] as String?,
      trabajoEjecutado: r['trabajo_ejecutado'] as String?,
      problemas: r['problemas'] as String?,
      soluciones: r['soluciones'] as String?,
      comentariosInstrucciones: r['comentarios_instrucciones'] as String?,
      latitud: r['latitud'] as double?,
      longitud: r['longitud'] as double?,
      fotosProblemaUrls: r['fotos_problema_urls'] as String?,
      fotosSolucionUrls: r['fotos_solucion_urls'] as String?,
      fechaEjecucionInicio: r['fecha_ejecucion_inicio'] as String?,
      fechaEjecucionFin: r['fecha_ejecucion_fin'] as String?,
      status: r['status'] as String,
      createdAt: r['created_at'] as String,
    );
  }
}
