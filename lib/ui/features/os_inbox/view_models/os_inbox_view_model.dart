import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/os_repository.dart';
import '../../../../domain/models/os.dart';
import '../../../../domain/models/pending_sync_report.dart';
import '../../../../domain/use_cases/start_os_use_case.dart';
import '../../../../domain/use_cases/sync_pending_reports_use_case.dart';

class OsInboxViewModel extends ChangeNotifier {
  static const pendingSyncStatus = 'PENDIENTE DE SINCRONIZAR';

  final OsRepository _osRepository;
  final AuthRepository _authRepository;
  final StartOsUseCase _startOsUseCase;
  final SyncPendingReportsUseCase _syncPendingReportsUseCase;

  StreamSubscription<void>? _syncSubscription;

  List<Os> _osList = [];
  List<PendingSyncReport> _colaLocal = [];
  bool _sincronizandoManual = false;
  bool _recargandoOs = false;
  String? _syncErrorMessage;
  String _userName = '';
  String _userRole = '';
  String? _userCode;
  int? _currentUserId;
  int _queueLoadGeneration = 0;
  int _ordersLoadGeneration = 0;

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
    final osById = {for (final os in _osList) os.id: os};
    final remotasArchivadas = _osList.where((os) {
      final estado = os.estadoOrden?.toUpperCase();
      return estado == 'ARCHIVADO' || estado == 'COMPLETADO';
    }).toList();
    final todas = <Os>[];
    final addedIds = <int>{};

    for (final report in _colaLocal) {
      final cached = osById[report.osId] ?? Os(id: report.osId);
      final localStatus = report.status == 'PENDING_SYNC'
          ? pendingSyncStatus
          : (cached.estadoOrden?.toUpperCase() == 'ARCHIVADO'
              ? 'ARCHIVADO'
              : 'COMPLETADO');
      if (addedIds.add(cached.id)) {
        todas.add(
          cached.copyWith(
            estadoOrden: localStatus,
            insumosUtilizados:
                report.insumosUtilizados ?? cached.insumosUtilizados,
            observacionesGasfitero:
                report.observacionesGasfitero ?? cached.observacionesGasfitero,
            trabajoEjecutado:
                report.trabajoEjecutado ?? cached.trabajoEjecutado,
            fechaEjecucionInicio:
                report.fechaEjecucionInicio ?? cached.fechaEjecucionInicio,
            fechaEjecucionFin:
                report.fechaEjecucionFin ?? cached.fechaEjecucionFin,
          ),
        );
      }
    }

    for (final os in remotasArchivadas) {
      if (addedIds.add(os.id)) todas.add(os);
    }
    
    todas.sort((a, b) {
      DateTime getEffectiveDate(Os os) {
        if (os.fechaEjecucionFin != null) return DateTime.tryParse(os.fechaEjecucionFin!) ?? DateTime(2000);
        if (os.fechaEjecucionInicio != null) return DateTime.tryParse(os.fechaEjecucionInicio!) ?? DateTime(2000);
        if (os.fechaProgramacion != null) return DateTime.tryParse(os.fechaProgramacion!) ?? DateTime(2000);
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

  List<PendingSyncReport> get colaLocal => _colaLocal;
  List<Os> get pendingSyncOrders => osArchivadas
      .where((os) => os.estadoOrden == pendingSyncStatus)
      .toList(growable: false);
  int get pendingSyncCount =>
      _colaLocal.where((report) => report.status == 'PENDING_SYNC').length;
  bool get sincronizandoManual => _sincronizandoManual;
  bool get recargandoOs => _recargandoOs;
  String? get syncErrorMessage => _syncErrorMessage;
  String get userName => _userName;
  String get userRole => _userRole;
  String? get userCode => _userCode;
  int? get currentUserId => _currentUserId;

  String? get cuadrillaNombre {
    for (final os in _osList) {
      if (os.cuadrilla != null) {
        final cod = os.cuadrilla!.codigoGrupo ?? os.cuadrilla!.id.toString();
        final codeClean = cod.replaceFirst(RegExp(r'^Cuadrilla\s+', caseSensitive: false), '');
        return '$codeClean · ${os.cuadrilla!.especialidad ?? "Sin especialidad"}';
      }
    }
    return null;
  }

  bool canExecuteOs(Os os) {
    if (_currentUserId == null) return false;

    final liderId = os.cuadrilla?.lider?.id;
    if (liderId == _currentUserId) return true;

    if (os.responsable?.id == _currentUserId) return true;

    return false;
  }

  OsInboxViewModel({
    required OsRepository osRepository,
    required AuthRepository authRepository,
    required StartOsUseCase startOsUseCase,
    required SyncPendingReportsUseCase syncPendingReportsUseCase,
  })  : _osRepository = osRepository,
        _authRepository = authRepository,
        _startOsUseCase = startOsUseCase,
        _syncPendingReportsUseCase = syncPendingReportsUseCase {
    _loadColaLocal();
    _cargarOsDelServidor();
    _cargarDatosUsuario();
    _cargarCurrentUserId();

    _syncSubscription = _osRepository.syncStream.listen((_) {
      _loadColaLocal();
      _cargarOsDelServidor();
    });
  }

  Future<void> _loadColaLocal() async {
    final generation = ++_queueLoadGeneration;
    final reports = await _osRepository.getPendingReports();
    if (generation != _queueLoadGeneration) return;
    _colaLocal = reports;
    notifyListeners();
  }

  Future<void> _cargarOsDelServidor() async {
    final generation = ++_ordersLoadGeneration;
    try {
      final orders = await _osRepository.getAssignedOrders();
      if (generation != _ordersLoadGeneration) return;
      _osList = orders;
    } finally {
      if (generation == _ordersLoadGeneration) {
        notifyListeners();
      }
    }
  }

  Future<void> _cargarDatosUsuario() async {
    final name = await _authRepository.getUserName();
    final role = await _authRepository.getUserRole() ?? 'Gasfitero';
    final code = await _authRepository.getUserCode();

    if (name != null) {
      _userName = name;
    }

    _userCode = code;
    // Capitalize first letter of role
    _userRole = role.isEmpty
        ? ''
        : role[0].toUpperCase() + role.substring(1).toLowerCase();
    notifyListeners();
  }

  Future<void> _cargarCurrentUserId() async {
    final id = await _authRepository.getUserId();
    _currentUserId = id;
    notifyListeners();
  }

  Future<void> refreshOs() async {
    _recargandoOs = true;
    notifyListeners();
    try {
      await _loadColaLocal();
      await _cargarOsDelServidor();
    } finally {
      _recargandoOs = false;
      notifyListeners();
    }
  }

  Future<void> startOs(Os os) async {
    final result = await _startOsUseCase(os.id);
    if (result.queuedOffline) {
      _osList = _osList
          .map(
            (item) => item.id == os.id
                ? item.copyWith(
                    estadoOrden: 'EN_PROCESO',
                    fechaEjecucionInicio: result.startedAt,
                  )
                : item,
          )
          .toList(growable: false);
      notifyListeners();
      return;
    }
    await _loadColaLocal();
    await _cargarOsDelServidor();
  }

  Future<void> syncManual() async {
    _sincronizandoManual = true;
    _syncErrorMessage = null;
    notifyListeners();
    try {
      final pendingBefore = pendingSyncCount;
      await _syncPendingReportsUseCase();
      await _loadColaLocal();
      await _cargarOsDelServidor();
      if (pendingBefore > 0 &&
          pendingSyncCount > 0 &&
          pendingSyncCount >= pendingBefore) {
        _syncErrorMessage = _osRepository.lastSyncErrorMessage ??
            'No se pudo confirmar la O.S. en el servidor. Inténtelo nuevamente.';
      }
    } finally {
      _sincronizandoManual = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _syncSubscription?.cancel();
    super.dispose();
  }
}
