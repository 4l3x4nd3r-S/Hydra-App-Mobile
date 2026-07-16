import 'package:flutter/material.dart';
import '../../../../domain/models/os.dart';
import '../../../../domain/use_cases/save_os_report_use_case.dart';
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

  OsExecutionViewModel({
    required this.os,
    required SaveOsReportUseCase saveOsReportUseCase,
  }) : _saveOsReportUseCase = saveOsReportUseCase {
    if (os.fechaEjecucionInicio != null &&
        os.fechaEjecucionInicio!.isNotEmpty) {
      fechaInicio = DateTime.tryParse(os.fechaEjecucionInicio!)?.toLocal();
    }
    fechaFin = DateTime.now();
  }

  bool updateFechaInicio(DateTime date) {
    if (_isBeforeCurrentMinute(date)) {
      _errorMsg = 'La fecha y hora de inicio no pueden estar en el pasado';
      notifyListeners();
      return false;
    }

    fechaInicio = date;
    if (fechaFin == null || !fechaFin!.isAfter(date)) {
      fechaFin = date.add(const Duration(minutes: 1));
    }
    _errorMsg = null;
    notifyListeners();
    return true;
  }

  bool updateFechaFin(DateTime date) {
    if (_isBeforeCurrentMinute(date)) {
      _errorMsg =
          'La fecha y hora de finalización no pueden estar en el pasado';
      notifyListeners();
      return false;
    }
    if (fechaInicio != null && !date.isAfter(fechaInicio!)) {
      _errorMsg =
          'La finalización debe ser posterior a la fecha y hora de inicio';
      notifyListeners();
      return false;
    }

    fechaFin = date;
    _errorMsg = null;
    notifyListeners();
    return true;
  }

  bool _isBeforeCurrentMinute(DateTime date) {
    final now = DateTime.now();
    final currentMinute = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
    return date.isBefore(currentMinute);
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
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
    notifyListeners();
  }

  void removeFotoSolucion(int index) {
    if (index < 0 || index >= _fotosSolucion.length) return;
    _fotosSolucion.removeAt(index);
    notifyListeners();
  }

  Future<bool> submit() async {
    if (observacionesController.text.trim().isEmpty) {
      _errorMsg = 'Debe ingresar observaciones del trabajo realizado';
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
      return true;
    } catch (e) {
      _errorMsg = 'Error al guardar reporte';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    insumosController.dispose();
    observacionesController.dispose();
    evidenciasController.dispose();
    trabajoEjecutadoController.dispose();
    problemasSolucionesController.dispose();
    comentariosInstruccionesController.dispose();
    super.dispose();
  }
}
