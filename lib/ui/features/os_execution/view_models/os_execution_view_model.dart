import 'package:flutter/material.dart';
import '../../../../domain/models/os.dart';
import '../../../../domain/use_cases/save_os_report_use_case.dart';
import '../../../../data/services/sync_queue_storage_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

enum LocationError {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  unknown,
}

class OsExecutionViewModel extends ChangeNotifier {
  final Os os;
  final SaveOsReportUseCase _saveOsReportUseCase;
  final SyncQueueStorageService _syncQueueStorageService;

  final TextEditingController insumosController = TextEditingController();
  final TextEditingController observacionesController = TextEditingController();
  final TextEditingController evidenciasController = TextEditingController();

  final TextEditingController trabajoEjecutadoController =
      TextEditingController();
  final TextEditingController problemasSolucionesController =
      TextEditingController();
  final TextEditingController comentariosInstruccionesController =
      TextEditingController();

  final ImagePicker _picker = ImagePicker();

  double? latitud;
  double? longitud;
  bool isLocating = false;

  final List<String> _fotosProblema = [];
  List<String> get fotosProblema => List.unmodifiable(_fotosProblema);

  final List<String> _fotosSolucion = [];
  List<String> get fotosSolucion => List.unmodifiable(_fotosSolucion);

  DateTime? fechaInicio;
  DateTime? fechaFin;

  String? _errorMsg;
  LocationError? _lastLocationError;

  String? get errorMsg => _errorMsg;
  LocationError? get lastLocationError => _lastLocationError;

  bool _isDraftLoaded = false;
  bool get isDraftLoaded => _isDraftLoaded;

  OsExecutionViewModel({
    required this.os,
    required SaveOsReportUseCase saveOsReportUseCase,
    required SyncQueueStorageService syncQueueStorageService,
  })  : _saveOsReportUseCase = saveOsReportUseCase,
        _syncQueueStorageService = syncQueueStorageService {
    _initDraft();

    // Listeners para autoguardado y progreso
    trabajoEjecutadoController.addListener(_onFieldChanged);
    problemasSolucionesController.addListener(_onFieldChanged);
    insumosController.addListener(_onFieldChanged);
    observacionesController.addListener(_onFieldChanged);
    comentariosInstruccionesController.addListener(_onFieldChanged);
    evidenciasController.addListener(_onFieldChanged);
  }

  Future<void> _initDraft() async {
    final draft = await _syncQueueStorageService.getDraft(os.id);

    if (draft != null) {
      insumosController.text = draft['insumos_utilizados'] ?? '';
      observacionesController.text = draft['observaciones_gasfitero'] ?? '';
      evidenciasController.text = draft['ruta_carpeta_evidencias'] ?? '';
      trabajoEjecutadoController.text = draft['trabajo_ejecutado'] ?? '';
      problemasSolucionesController.text = draft['problemas'] ?? '';
      comentariosInstruccionesController.text =
          draft['comentarios_instrucciones'] ?? '';

      latitud = draft['latitud'] as double?;
      longitud = draft['longitud'] as double?;

      final pUrls = draft['fotos_problema_urls'] as String?;
      if (pUrls != null && pUrls.isNotEmpty) {
        _fotosProblema.addAll(pUrls.split(','));
      }

      final sUrls = draft['fotos_solucion_urls'] as String?;
      if (sUrls != null && sUrls.isNotEmpty) {
        _fotosSolucion.addAll(sUrls.split(','));
      }

      final fIni = draft['fecha_ejecucion_inicio'] as String?;
      if (fIni != null && fIni.isNotEmpty) {
        fechaInicio = DateTime.tryParse(fIni)?.toLocal();
      }

      final fFin = draft['fecha_ejecucion_fin'] as String?;
      if (fFin != null && fFin.isNotEmpty) {
        fechaFin = DateTime.tryParse(fFin)?.toLocal();
      }
    } else {
      // Valores por defecto si no hay borrador
      if (os.fechaEjecucionInicio != null &&
          os.fechaEjecucionInicio!.isNotEmpty) {
        fechaInicio = DateTime.tryParse(os.fechaEjecucionInicio!)?.toLocal();
      }
    }

    _isDraftLoaded = true;
    notifyListeners();
  }

  void _onFieldChanged() {
    if (_isDraftLoaded) {
      saveDraft();
      notifyListeners();
    }
  }

  double get progress {
    int total = 5;
    int completed = 0;
    if (fechaInicio != null) completed++;
    if (trabajoEjecutadoController.text.trim().isNotEmpty) completed++;
    if (latitud != null && longitud != null) completed++;
    if (_fotosProblema.isNotEmpty || _fotosSolucion.isNotEmpty) completed++;
    if (fechaFin != null) completed++;
    return completed / total;
  }

  Future<void> saveDraft() async {
    await _syncQueueStorageService.saveDraft(
      osId: os.id,
      insumosUtilizados: insumosController.text.trim(),
      observacionesGasfitero: observacionesController.text.trim(),
      rutaCarpetaEvidencias: evidenciasController.text.trim(),
      trabajoEjecutado: trabajoEjecutadoController.text.trim(),
      problemas: problemasSolucionesController.text.trim(),
      soluciones: problemasSolucionesController.text.trim(),
      comentariosInstrucciones: comentariosInstruccionesController.text.trim(),
      latitud: latitud,
      longitud: longitud,
      fotosProblemaUrls:
          _fotosProblema.isNotEmpty ? _fotosProblema.join(',') : null,
      fotosSolucionUrls:
          _fotosSolucion.isNotEmpty ? _fotosSolucion.join(',') : null,
      fechaEjecucionInicio: fechaInicio?.toUtc().toIso8601String(),
      fechaEjecucionFin: fechaFin?.toUtc().toIso8601String(),
    );
  }

  void iniciarAhora() {
    fechaInicio = DateTime.now();
    saveDraft();
    notifyListeners();
  }

  void finalizarAhora() {
    if (fechaInicio != null && DateTime.now().isBefore(fechaInicio!)) {
      _errorMsg = 'La finalización no puede ser anterior al inicio';
      notifyListeners();
      return;
    }
    fechaFin = DateTime.now();
    _errorMsg = null;
    saveDraft();
    notifyListeners();
  }

  Future<void> recordLocation() async {
    isLocating = true;
    _errorMsg = null;
    _lastLocationError = null;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _lastLocationError = LocationError.serviceDisabled;
        throw Exception(
            'El GPS esta desactivado. Activalo para grabar tu ubicacion.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _lastLocationError = LocationError.permissionDenied;
          throw Exception(
              'Necesitamos permiso de ubicacion para grabar tu ubicacion.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _lastLocationError = LocationError.permissionDeniedForever;
        throw Exception(
            'El permiso de ubicacion esta bloqueado. Activalo en ajustes.');
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latitud = position.latitude;
      longitud = position.longitude;
      await saveDraft();
    } catch (e) {
      _errorMsg = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Error al obtener la ubicacion';
      _lastLocationError ??= LocationError.unknown;
    } finally {
      isLocating = false;
      notifyListeners();
    }
  }

  Future<void> takeFotoProblema() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        _fotosProblema.add(photo.path);
        _errorMsg = null;
        await saveDraft();
        notifyListeners();
      }
    } catch (e) {
      _errorMsg = 'Error al tomar foto del problema';
      notifyListeners();
    }
  }

  Future<void> takeFotoSolucion() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        _fotosSolucion.add(photo.path);
        _errorMsg = null;
        await saveDraft();
        notifyListeners();
      }
    } catch (e) {
      _errorMsg = 'Error al tomar foto de la solucion';
      notifyListeners();
    }
  }

  void removeFotoProblema(int index) {
    if (index < 0 || index >= _fotosProblema.length) return;
    _fotosProblema.removeAt(index);
    saveDraft();
    notifyListeners();
  }

  void removeFotoSolucion(int index) {
    if (index < 0 || index >= _fotosSolucion.length) return;
    _fotosSolucion.removeAt(index);
    saveDraft();
    notifyListeners();
  }

  Future<bool> submit() async {
    if (trabajoEjecutadoController.text.trim().isEmpty) {
      _errorMsg = 'Debe ingresar el trabajo ejecutado';
      notifyListeners();
      return false;
    }

    if (fechaInicio == null) {
      _errorMsg = 'Debe registrar la fecha y hora de inicio';
      notifyListeners();
      return false;
    }

    if (fechaFin == null || !fechaFin!.isAfter(fechaInicio!)) {
      _errorMsg =
          'La finalización debe ser posterior a la fecha y hora de inicio';
      notifyListeners();
      return false;
    }

    try {
      await _saveOsReportUseCase(
        osId: os.id,
        insumosUtilizados: insumosController.text.trim(),
        observacionesGasfitero: observacionesController.text.trim(),
        rutaCarpetaEvidencias: evidenciasController.text.trim(),
        trabajoEjecutado: trabajoEjecutadoController.text.trim(),
        problemas: problemasSolucionesController.text.trim(),
        soluciones: problemasSolucionesController.text.trim(),
        comentariosInstrucciones:
            comentariosInstruccionesController.text.trim(),
        latitud: latitud,
        longitud: longitud,
        fotosProblemaUrls:
            _fotosProblema.isNotEmpty ? _fotosProblema.join(',') : null,
        fotosSolucionUrls:
            _fotosSolucion.isNotEmpty ? _fotosSolucion.join(',') : null,
        fechaEjecucionInicio: fechaInicio?.toUtc().toIso8601String(),
        fechaEjecucionFin: fechaFin?.toUtc().toIso8601String(),
      );

      // Si todo fue exitoso, limpiamos el borrador local
      await _syncQueueStorageService.deleteDraft(os.id);

      return true;
    } catch (e) {
      _errorMsg = 'Error al guardar reporte';
      notifyListeners();
      return false;
    }
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  @override
  void dispose() {
    trabajoEjecutadoController.removeListener(_onFieldChanged);
    problemasSolucionesController.removeListener(_onFieldChanged);
    insumosController.removeListener(_onFieldChanged);
    observacionesController.removeListener(_onFieldChanged);
    comentariosInstruccionesController.removeListener(_onFieldChanged);
    evidenciasController.removeListener(_onFieldChanged);

    insumosController.dispose();
    observacionesController.dispose();
    evidenciasController.dispose();
    trabajoEjecutadoController.dispose();
    problemasSolucionesController.dispose();
    comentariosInstruccionesController.dispose();
    super.dispose();
  }
}
