import 'package:flutter/material.dart';
import '../../../../domain/models/os.dart';
import '../../../../domain/use_cases/save_os_report_use_case.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class OsExecutionViewModel extends ChangeNotifier {
  final Os os;
  final SaveOsReportUseCase _saveOsReportUseCase;

  final TextEditingController insumosController = TextEditingController();
  final TextEditingController observacionesController = TextEditingController();
  final TextEditingController evidenciasController = TextEditingController();
  
  final TextEditingController trabajoEjecutadoController = TextEditingController();
  final TextEditingController problemasSolucionesController = TextEditingController();
  final TextEditingController comentariosInstruccionesController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  
  double? latitud;
  double? longitud;
  bool isLocating = false;

  List<String> fotosProblema = [];
  List<String> fotosSolucion = [];

  DateTime? fechaInicio;
  DateTime? fechaFin;

  String? _errorMsg;

  String? get errorMsg => _errorMsg;

  OsExecutionViewModel({
    required this.os,
    required SaveOsReportUseCase saveOsReportUseCase,
  }) : _saveOsReportUseCase = saveOsReportUseCase {
    if (os.fechaEjecucionInicio != null && os.fechaEjecucionInicio!.isNotEmpty) {
      fechaInicio = DateTime.tryParse(os.fechaEjecucionInicio!)?.toLocal();
    }
    fechaFin = DateTime.now();
  }

  void updateFechaInicio(DateTime date) {
    fechaInicio = date;
    notifyListeners();
  }

  void updateFechaFin(DateTime date) {
    fechaFin = date;
    notifyListeners();
  }

  Future<void> recordLocation() async {
    isLocating = true;
    _errorMsg = null;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Los servicios de ubicacion estan deshabilitados.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Los permisos de ubicacion fueron denegados.');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Los permisos de ubicacion estan denegados permanentemente.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      
      latitud = position.latitude;
      longitud = position.longitude;
    } catch (e) {
      _errorMsg = 'Error al obtener la ubicación';
    } finally {
      isLocating = false;
      notifyListeners();
    }
  }

  Future<void> takeFotoProblema() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        fotosProblema.add(photo.path);
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
        fotosSolucion.add(photo.path);
        notifyListeners();
      }
    } catch (e) {
      _errorMsg = 'Error al tomar foto de la solucion';
      notifyListeners();
    }
  }

  Future<bool> submit() async {
    if (observacionesController.text.trim().isEmpty) {
      _errorMsg = 'Debe ingresar observaciones del trabajo realizado';
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
        comentariosInstrucciones: comentariosInstruccionesController.text.trim(),
        latitud: latitud,
        longitud: longitud,
        fotosProblemaUrls: fotosProblema.isNotEmpty ? fotosProblema.join(',') : null,
        fotosSolucionUrls: fotosSolucion.isNotEmpty ? fotosSolucion.join(',') : null,
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
