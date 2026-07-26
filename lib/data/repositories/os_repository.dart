import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../models/os_dto.dart';
import '../models/cuadrilla_dto.dart';
import '../models/gasfitero_dto.dart';
import '../models/responsable_dto.dart';
import '../services/os_api_service.dart';
import '../services/sync_queue_storage_service.dart';
import '../../domain/models/os.dart';
import '../../domain/models/cuadrilla.dart';
import '../../domain/models/gasfitero.dart';
import '../../domain/models/reclamo.dart';
import '../../domain/models/pending_sync_report.dart';
import '../../domain/models/os_start_result.dart';

import '../models/reclamo_dto.dart';

class OsRepository {
  final OsApiService _osApiService;
  final SyncQueueStorageService _syncQueueStorage;

  final StreamController<void> _syncController =
      StreamController<void>.broadcast();

  Stream<void> get syncStream => _syncController.stream;

  Completer<void>? _activeSync;
  String? _lastSyncErrorMessage;

  String? get lastSyncErrorMessage => _lastSyncErrorMessage;

  OsRepository({
    required OsApiService osApiService,
    required SyncQueueStorageService syncQueueStorage,
  })  : _osApiService = osApiService,
        _syncQueueStorage = syncQueueStorage;

  Future<List<Os>> getAssignedOrders() async {
    try {
      final response = await _osApiService.getOrdenes();
      if (response.statusCode == 200 && response.data is List) {
        final rawOrders = (response.data as List)
            .map((json) => Map<String, dynamic>.from(json as Map))
            .toList();
        final pendingStarts = await _syncQueueStorage.getPendingOrderStarts();
        final startsByOrder = {
          for (final start in pendingStarts)
            start['os_id'] as int: start['started_at'] as String,
        };
        for (final order in rawOrders) {
          final startedAt = startsByOrder[order['id']];
          final serverStatus = order['estado_orden']?.toString().toUpperCase();
          if (startedAt != null && serverStatus == 'ASIGNADO') {
            order['estado_orden'] = 'EN_PROCESO';
            order['fecha_ejecucion_inicio'] = startedAt;
          }
        }
        await _syncQueueStorage.replaceAssignedOrdersCache(rawOrders);
        return rawOrders.map(OsDto.fromJson).map(_toDomain).toList();
      }
    } catch (_) {
      // Sin conexión: se utiliza la última bandeja guardada localmente.
    }

    final cachedOrders = await _syncQueueStorage.getAssignedOrdersCache();
    return cachedOrders.map(OsDto.fromJson).map(_toDomain).toList();
  }

  Future<OsStartResult> startOrder(int ordenId) async {
    final startedAt = DateTime.now().toUtc().toIso8601String();
    try {
      final response = await _osApiService.iniciarOrden(ordenId);
      if (response.data is Map) {
        await _syncQueueStorage.upsertAssignedOrderCache(
          Map<String, dynamic>.from(response.data as Map),
        );
      }
      await _syncQueueStorage.markOrderStartSynced(ordenId);
      return OsStartResult(startedAt: startedAt, queuedOffline: false);
    } on DioException catch (error) {
      if (error.response != null) rethrow;

      await _syncQueueStorage.savePendingOrderStart(
        osId: ordenId,
        startedAt: startedAt,
      );
      await _syncQueueStorage.markCachedOrderStarted(
        osId: ordenId,
        startedAt: startedAt,
      );
      _syncController.add(null);
      return OsStartResult(startedAt: startedAt, queuedOffline: true);
    }
  }

  Future<String?> uploadImage(String filePath) async {
    final response = await _osApiService.uploadImage(filePath);
    final statusCode = response.statusCode;
    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      return response.data['url'] as String;
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
    final results = await _syncQueueStorage.getPending();
    return results.map((r) => _pendingFromMap(r)).toList();
  }

  Future<void> triggerSync() async {
    final currentSync = _activeSync;
    if (currentSync != null) {
      await currentSync.future;
      return;
    }

    final syncCompleter = Completer<void>();
    _activeSync = syncCompleter;
    _lastSyncErrorMessage = null;

    try {
      await _reconcileServerState();
      await _syncPendingOrderStarts();
      final pending = await _syncQueueStorage.getPending();
      for (final report in pending) {
        try {
          final osId = report['os_id'] as int;
          final fotosProblema = await _uploadPendingPhotos(
            osId: osId,
            rawPaths: report['fotos_problema_urls'] as String?,
            areProblemPhotos: true,
          );
          final fotosSolucion = await _uploadPendingPhotos(
            osId: osId,
            rawPaths: report['fotos_solucion_urls'] as String?,
            areProblemPhotos: false,
          );

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
              'fotos_problema_urls': fotosProblema ?? [],
              'fotos_solucion_urls': fotosSolucion ?? [],
              'fecha_ejecucion_inicio': report['fecha_ejecucion_inicio'],
              'fecha_ejecucion_fin': report['fecha_ejecucion_fin'],
            },
          );

          final statusCode = response.statusCode;
          if (statusCode != null && statusCode >= 200 && statusCode < 300) {
            if (response.data is Map) {
              await _syncQueueStorage.upsertAssignedOrderCache(
                Map<String, dynamic>.from(response.data as Map),
              );
            }
            await _syncQueueStorage.markSynced(osId);
            await _syncQueueStorage.markOrderStartSynced(osId);
          }
        } catch (error) {
          _lastSyncErrorMessage = _describeSyncError(error);
          // La fila permanece PENDING_SYNC para el siguiente intento.
        }
      }
    } finally {
      _syncController.add(null);
      syncCompleter.complete();
      _activeSync = null;
    }
  }

  Future<void> _reconcileServerState() async {
    try {
      final pendingReports = await _syncQueueStorage.getPending();
      final pendingStarts = await _syncQueueStorage.getPendingOrderStarts();
      final localOrderIds = <int>{
        ...pendingReports.map((row) => row['os_id'] as int),
        ...pendingStarts.map((row) => row['os_id'] as int),
      };
      if (localOrderIds.isEmpty) return;

      for (final osId in localOrderIds) {
        final response = await _osApiService.getOrden(osId);
        if (response.statusCode != 200 || response.data is! Map) continue;
        final order = Map<String, dynamic>.from(response.data as Map);

        final serverStatus = order['estado_orden']?.toString().toUpperCase();
        if (serverStatus == 'EN_PROCESO' || serverStatus == 'COMPLETADO') {
          await _syncQueueStorage.markOrderStartSynced(osId);
        }
        if (serverStatus == 'COMPLETADO') {
          await _syncQueueStorage.markSynced(osId);
        }
        await _syncQueueStorage.upsertAssignedOrderCache(order);
      }
    } catch (_) {
      // Sin conexión o sin sesión renovable: la cola permanece intacta.
    }
  }

  Future<void> _syncPendingOrderStarts() async {
    final pendingStarts = await _syncQueueStorage.getPendingOrderStarts();
    for (final start in pendingStarts) {
      final osId = start['os_id'] as int;
      try {
        final response = await _osApiService.iniciarOrden(osId);
        final statusCode = response.statusCode;
        if (statusCode != null && statusCode >= 200 && statusCode < 300) {
          if (response.data is Map) {
            await _syncQueueStorage.upsertAssignedOrderCache(
              Map<String, dynamic>.from(response.data as Map),
            );
          }
          await _syncQueueStorage.markOrderStartSynced(osId);
        }
      } catch (_) {
        // El inicio permanece pendiente y se reintentará antes del reporte.
      }
    }
  }

  Future<List<String>?> _uploadPendingPhotos({
    required int osId,
    required String? rawPaths,
    required bool areProblemPhotos,
  }) async {
    if (rawPaths == null || rawPaths.trim().isEmpty) return null;

    final photos = rawPaths.split(',');
    
    final uploadTasks = photos.map((path) async {
      if (path.startsWith('/uploads') || path.startsWith('http')) {
        return path;
      }
      final uploadedUrl = await uploadImage(path);
      if (uploadedUrl == null) {
        throw StateError('No se pudo subir una fotografía pendiente.');
      }
      return uploadedUrl;
    }).toList();

    final uploadedPhotos = await Future.wait(uploadTasks);
    final updatedPaths = uploadedPhotos.join(',');

    if (areProblemPhotos) {
      await _syncQueueStorage.updatePendingProblemPhotos(osId, updatedPaths);
    } else {
      await _syncQueueStorage.updatePendingSolutionPhotos(osId, updatedPaths);
    }
    
    return uploadedPhotos;
  }

  String _describeSyncError(Object error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionTimeout) {
        return 'El servidor tardó demasiado al recibir las evidencias. Vuelva a intentarlo; el progreso guardado no se perderá.';
      }
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        if (statusCode == 422) {
          final data = error.response?.data;
          return 'Error de validación (422): $data';
        }
        return 'El servidor rechazó la sincronización (código $statusCode). Inténtelo nuevamente.';
      }
      return 'No se pudo conectar con el servidor. Verifique que HYDRA tenga acceso a internet.';
    }
    if (error is StateError) {
      return error.message;
    }
    return 'No se pudo sincronizar la O.S. El reporte permanece seguro en el dispositivo.';
  }

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  void startAutoSync() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
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
      cuadrilla:
          dto.cuadrilla != null ? _cuadrillaToDomain(dto.cuadrilla!) : null,
      responsable: dto.responsable != null
          ? _responsableToDomain(dto.responsable!)
          : null,
    );
  }

  Gasfitero _responsableToDomain(ResponsableDto dto) {
    return Gasfitero(
      id: dto.id,
      nombre: dto.nombre,
      codigoEmpleado: dto.codigoEmpleado,
      cargo: dto.cargo,
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
      numeroSuministro: dto.numeroSuministro,
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
