import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/os_excel_exporter.dart';
import '../../../../data/repositories/catalog_repository.dart';
import '../../../../data/repositories/os_repository.dart';
import '../../../../data/repositories/supervisor_repository.dart';
import '../../../../domain/models/os.dart';
import '../../../../domain/models/pending_sync_report.dart';

class SupervisorOsViewModel extends ChangeNotifier {
  final OsRepository _osRepository;
  final SupervisorRepository _supervisorRepository;
  final CatalogRepository? _catalogRepository;

  StreamSubscription<void>? _syncSubscription;

  List<Os> _osList = [];
  List<PendingSyncReport> _colaLocal = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isExporting = false;
  bool _disposed = false;
  String? _exportErrorMessage;

  bool get isExporting => _isExporting;
  String? get exportErrorMessage => _exportErrorMessage;

  List<Os> get osActivas {
    final localOsIds = _colaLocal.map((r) => r.osId).toSet();
    return _osList.where((os) {
      if (localOsIds.contains(os.id)) return false;
      final estado = os.estadoOrden?.toUpperCase();
      if (estado == 'COMPLETADO' || estado == 'ARCHIVADO') return false;
      return true;
    }).toList();
  }

  List<Os> get osArchivadas {
    final localSyncedIds = _colaLocal
        .where((r) => r.status == 'SYNCED')
        .map((r) => r.osId)
        .toSet();
    final remotasArchivadas = _osList.where((os) {
      final estado = os.estadoOrden?.toUpperCase();
      return estado == 'ARCHIVADO' || estado == 'COMPLETADO';
    }).toList();
    final localesArchivadas =
        _osList.where((os) => localSyncedIds.contains(os.id)).toList();
    final todas = <Os>[];
    final addedIds = <int>{};
    for (final os in remotasArchivadas) {
      if (addedIds.add(os.id)) todas.add(os);
    }
    for (final os in localesArchivadas) {
      if (addedIds.add(os.id)) todas.add(os);
    }

    todas.sort((a, b) {
      DateTime getEffectiveDate(Os os) {
        if (os.fechaEjecucionFin != null) {
          return DateTime.tryParse(os.fechaEjecucionFin!) ?? DateTime(2000);
        }
        if (os.fechaEjecucionInicio != null) {
          return DateTime.tryParse(os.fechaEjecucionInicio!) ?? DateTime(2000);
        }
        if (os.fechaProgramacion != null) {
          return DateTime.tryParse(os.fechaProgramacion!) ?? DateTime(2000);
        }
        return DateTime(2000);
      }

      final dateA = getEffectiveDate(a);
      final dateB = getEffectiveDate(b);
      final cmp = dateB.compareTo(dateA);
      if (cmp != 0) return cmp;
      return b.id.compareTo(a.id);
    });

    return todas;
  }

  bool get hasPendingSyncs => _colaLocal.any((r) => r.status == 'PENDING_SYNC');

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SupervisorOsViewModel({
    required OsRepository osRepository,
    required SupervisorRepository supervisorRepository,
    CatalogRepository? catalogRepository,
  })  : _osRepository = osRepository,
        _supervisorRepository = supervisorRepository,
        _catalogRepository = catalogRepository {
    _loadAll();

    _syncSubscription = _osRepository.syncStream.listen((_) {
      _loadAll();
    });
  }

  Future<void> cargarTodo() => _loadAll();

  Future<OsExcelExport?> exportCompletedOrders() async {
    if (_isExporting || _disposed) return null;
    _isExporting = true;
    _exportErrorMessage = null;
    _notify();
    try {
      // Fetch again: never export a stale list after a failed refresh.
      final orders = await _supervisorRepository.getOrdenesServicio();
      final localReports = await _osRepository.getPendingReports();
      final completed = OsExcelExporter.completedOrders(
        orders,
        excludedIds: localReports
            .where((report) => report.status != 'SYNCED')
            .map((report) => report.osId)
            .toSet(),
      );
      if (completed.isEmpty) {
        _exportErrorMessage =
            'No hay órdenes realizadas y sincronizadas para exportar.';
        return null;
      }
      final descriptions = <String, String>{};
      try {
        final options = await _catalogRepository?.getGroup('TIPO_PROBLEMA');
        for (final option in options ?? []) {
          final description = option.description?.trim();
          descriptions[option.code] =
              description?.isNotEmpty == true ? description! : option.label;
        }
      } catch (_) {
        // The original problem code remains available if the catalog is down.
      }
      if (_disposed) return null;
      return await compute(
          OsExcelExporter.generate,
          OsExcelExportRequest(
            orders: completed,
            generatedAt: DateTime.now(),
            problemDescriptions: descriptions,
          ));
    } on DioException catch (e) {
      _exportErrorMessage = _mapDioError(e);
      return null;
    } catch (e) {
      _exportErrorMessage = 'No se pudo generar el Excel. Intente nuevamente.';
      debugPrint('Error exportando órdenes realizadas: $e');
      return null;
    } finally {
      _isExporting = false;
      _notify();
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> _loadAll() async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    try {
      _colaLocal = await _osRepository.getPendingReports();
      _osList = await _supervisorRepository.getOrdenesServicio();
    } on DioException catch (e) {
      _errorMessage = _mapDioError(e);
      _osList = [];
      debugPrint('Error cargando OS: $e');
    } catch (e, st) {
      _errorMessage = 'Error inesperado al cargar O.S.';
      _osList = [];
      debugPrint('Error inesperado: $e\n$st');
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  String _mapDioError(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        return 'Sesion expirada. Inicie sesion nuevamente.';
      case 403:
        return 'No tiene permisos para ver O.S.';
      case 500:
        return 'Error del servidor. Intente nuevamente.';
      default:
        return 'No se pudieron cargar las O.S. Verifique su conexion.';
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _syncSubscription?.cancel();
    super.dispose();
  }
}
