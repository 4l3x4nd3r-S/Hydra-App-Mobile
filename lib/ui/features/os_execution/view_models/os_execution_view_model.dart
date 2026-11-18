import 'package:flutter/material.dart';
import '../../../../domain/models/os.dart';
import '../../../../domain/use_cases/save_os_report_use_case.dart';
import '../../../../data/services/sync_queue_storage_service.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
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
  final DateTime Function() _clock;
  final DateTime _openedAt;

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

  bool _showValidationErrors = false;
  bool get showValidationErrors => _showValidationErrors;

  String? get errorMsg => _errorMsg;
  LocationError? get lastLocationError => _lastLocationError;

  bool _isDraftLoaded = false;
  bool get isDraftLoaded => _isDraftLoaded;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Uint8List? _userSignature;
  Uint8List? get userSignature => _userSignature;

  void setSignature(Uint8List? bytes) {
    _userSignature = bytes;
    _notificar();
  }

  /// Carga asíncrona del borrador. Permite esperar a que el formulario esté
  /// hidratado antes de leer el estado (tests y consumidores que lo
  /// necesiten).
  late final Future<void> _cargaInicial;

  /// Se completa cuando el borrador (o la orden) ya se cargaron.
  Future<void> get listo => _cargaInicial;

  bool _disposed = false;

  OsExecutionViewModel({
    required this.os,
    required SaveOsReportUseCase saveOsReportUseCase,
    required SyncQueueStorageService syncQueueStorageService,
    DateTime Function()? clock,
  })  : _saveOsReportUseCase = saveOsReportUseCase,
        _syncQueueStorageService = syncQueueStorageService,
        _clock = clock ?? DateTime.now,
        _openedAt = (clock ?? DateTime.now)().toLocal() {
    _cargaInicial = _initDraft();

    // Listeners para autoguardado y progreso
    trabajoEjecutadoController.addListener(_onFieldChanged);
    problemasSolucionesController.addListener(_onFieldChanged);
    insumosController.addListener(_onFieldChanged);
    observacionesController.addListener(_onFieldChanged);
    comentariosInstruccionesController.addListener(_onFieldChanged);
    evidenciasController.addListener(_onFieldChanged);
  }

  Future<void> _initDraft() async {
    fechaInicio = _openedAt;
    try {
      final draft = await _syncQueueStorageService.getDraft(os.id);
      if (_disposed) return;
      final localStart = _validStart(draft?['fecha_ejecucion_inicio']);
      // Server timestamps without an offset are ambiguous. A new form starts
      // from the device event instead of assuming a timezone for those values.
      final remoteRaw = os.fechaEjecucionInicio?.trim();
      final remoteStart = remoteRaw != null &&
              RegExp(r'(?:[zZ]|[+-]\d{2}:?\d{2})$').hasMatch(remoteRaw)
          ? _validStart(remoteRaw)
          : null;
      fechaInicio = localStart ?? remoteStart ?? _openedAt;
      final persistStart = localStart == null;

      if (draft != null) {
        insumosController.text = draft['insumos_utilizados'] ?? '';
        observacionesController.text = draft['observaciones_gasfitero'] ?? '';
        evidenciasController.text = draft['ruta_carpeta_evidencias'] ?? '';
        trabajoEjecutadoController.text = draft['trabajo_ejecutado'] ?? '';
        problemasSolucionesController.text = draft['problemas'] ?? '';
        comentariosInstruccionesController.text =
            draft['comentarios_instrucciones'] ?? '';

        latitud = _aDouble(draft['latitud']);
        longitud = _aDouble(draft['longitud']);

        final pUrls = draft['fotos_problema_urls'] as String?;
        if (pUrls != null && pUrls.isNotEmpty) {
          _fotosProblema.addAll(pUrls.split(','));
        }

        final sUrls = draft['fotos_solucion_urls'] as String?;
        if (sUrls != null && sUrls.isNotEmpty) {
          _fotosSolucion.addAll(sUrls.split(','));
        }

        final fFin = draft['fecha_ejecucion_fin'] as String?;
        if (fFin != null && fFin.isNotEmpty) {
          fechaFin = DateTime.tryParse(fFin)?.toLocal();
        }

        // Confirmaciones explícitas guardadas en una sesión anterior. Nunca se
        // deducen de los datos: un paso solo avanza con el botón.
        final confirmados = draft['pasos_confirmados'] as String?;
        if (confirmados != null && confirmados.isNotEmpty) {
          for (final raw in confirmados.split(',')) {
            final paso = int.tryParse(raw.trim());
            if (paso != null && paso >= 0 && paso < totalPasos - 1) {
              _pasosConfirmados.add(paso);
            }
          }
        }
      }

      // La ubicación puede venir del borrador local o de la propia orden (por
      // ejemplo si la O.S. ya fue reportada al servidor en una visita
      // anterior, o si el borrador local fue pisado por un reporte ya
      // encolado). Si ya está registrada, el siguiente paso del formulario
      // tiene que quedar desbloqueado: el técnico no debe volver a tomar el
      // GPS para poder avanzar.
      if (latitud == null || longitud == null) {
        latitud = os.latitud;
        longitud = os.longitud;
      }
      // Persist before editing anything, so reopening resumes the same start.
      if (persistStart) await saveDraft();
    } catch (e) {
      // Un borrador corrupto no debe dejar el formulario inservible.
      debugPrint('No se pudo restaurar el borrador de la O.S. ${os.id}: $e');
    }

    _isDraftLoaded = true;
    _recalcularPasoDesbloqueado();
    _notificar();
  }

  DateTime? _validStart(Object? raw) {
    if (raw is! String || raw.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(raw.trim())?.toLocal();
    return parsed == null || parsed.isAfter(_openedAt) ? null : parsed;
  }

  /// Convierte un valor que viene de SQLite a `double` sin romper la carga.
  /// SQLite puede devolver un `int` cuando el valor se guardó sin decimales.
  double? _aDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// `notifyListeners` seguro: la carga del borrador y las operaciones con
  /// GPS/fotos son asíncronas y pueden terminar después de que el
  /// ViewModel ya fue descartado.
  void _notificar() {
    if (_disposed) return;
    notifyListeners();
  }

  void _onFieldChanged() {
    if (_isDraftLoaded) {
      // Escribir no revela el siguiente paso: el avance depende de que el
      // técnico confirme el bloque actual.
      saveDraft();
      _notificar();
    }
  }

  // ---------------------------------------------------------------------
  // Flujo progresivo del formulario
  //
  // Los bloques se revelan por pasos para no saturar al técnico con
  // información que todavía no corresponde registrar:
  //
  //   0. Hora de inicio + ubicación
  //   1. Fotos del problema
  //   2. Fotos de la solución
  //   3. Trabajo ejecutado (obligatorio) + información adicional (opcional)
  //   4. Hora de finalización + firma (opcional)
  // ---------------------------------------------------------------------

  /// Cantidad total de pasos del formulario.
  static const int totalPasos = 5;

  /// Pasos que el técnico ya confirmó explícitamente en esta sesión. El
  /// avance del formulario depende de esta confirmación, no solo de que el
  /// campo tenga datos: así el técnico decide cuándo pasó al siguiente bloque.
  final Set<int> _pasosConfirmados = <int>{};

  /// Paso más avanzado que ya se desbloqueó. Es monótono: una vez que un paso
  /// se mostró nunca vuelve a ocultarse, así el técnico no pierde de vista
  /// lo que ya registró si decide borrar una foto por error.
  int _pasoDesbloqueado = 0;

  /// Paso actual que le toca completar al técnico.
  int get pasoDesbloqueado => _pasoDesbloqueado;

  /// `true` cuando la ubicación ya quedó registrada.
  bool get ubicacionRegistrada => latitud != null && longitud != null;

  bool get mostrarFotosProblema => _pasoDesbloqueado >= 1;
  bool get mostrarFotosSolucion => _pasoDesbloqueado >= 2;
  bool get mostrarTrabajo => _pasoDesbloqueado >= 3;
  bool get mostrarCierre => _pasoDesbloqueado >= 4;

  /// `true` cuando el paso ya tiene los datos mínimos para confirmarse.
  bool pasoConDatos(int paso) {
    switch (paso) {
      case 0:
        return ubicacionRegistrada;
      case 1:
        return _fotosProblema.isNotEmpty;
      case 2:
        return _fotosSolucion.isNotEmpty;
      case 3:
        return trabajoEjecutadoController.text.trim().isNotEmpty;
      case 4:
        return fechaFin != null;
      default:
        return false;
    }
  }

  /// `true` cuando el técnico ya confirmó el paso. Se exige que los datos
  /// sigan presentes: si borra la última foto, el paso vuelve a quedar
  /// pendiente y hay que confirmarlo otra vez.
  bool pasoConfirmado(int paso) {
    if (paso >= totalPasos - 1) return pasoConDatos(paso);
    return _pasosConfirmados.contains(paso) && pasoConDatos(paso);
  }

  /// Confirma un paso y desbloquea el siguiente. Devuelve `false` cuando el
  /// paso todavía no tiene los datos mínimos.
  bool confirmarPaso(int paso) {
    if (paso < 0 || paso >= totalPasos - 1) return false;

    if (!pasoConDatos(paso)) {
      _showValidationErrors = true;
      _errorMsg = _mensajeFaltaDato(paso);
      _notificar();
      return false;
    }

    _pasosConfirmados.add(paso);
    _showValidationErrors = false;
    _errorMsg = null;
    _recalcularPasoDesbloqueado();
    // La confirmación queda guardada: si la cámara o el sistema reinician la
    // pantalla, el paso sigue confirmado y no se le pide de nuevo.
    saveDraft();
    _notificar();
    return true;
  }

  /// Recalcula hasta dónde puede avanzar el formulario a partir de los pasos
  /// confirmados. Es monótono: nunca retrocede.
  void _recalcularPasoDesbloqueado() {
    var paso = 0;
    while (paso < totalPasos - 1 && pasoConfirmado(paso)) {
      paso++;
    }
    if (paso > _pasoDesbloqueado) _pasoDesbloqueado = paso;
  }

  /// Revela los pasos hasta el primero pendiente (inclusive) para que el
  /// técnico vea qué le falta, sin desbloquear de golpe los posteriores.
  void _revelarHastaPasoPendiente() {
    final pendiente = pasoPendiente;
    if (pendiente == null) return;
    if (_pasoDesbloqueado < pendiente) {
      _pasoDesbloqueado = pendiente;
    }
  }

  /// `true` cuando ya se confirmó todo lo obligatorio y la orden puede
  /// enviarse.
  bool get puedeFinalizar => pasoPendiente == null;

  /// Primer paso del flujo que quedó pendiente (0..4), o `null` cuando no
  /// falta nada.
  int? get pasoPendiente {
    for (var paso = 0; paso < totalPasos; paso++) {
      if (!pasoConfirmado(paso)) return paso;
    }
    return null;
  }

  /// Texto de lo que falta cuando el paso todavía no tiene datos.
  String _mensajeFaltaDato(int paso) {
    switch (paso) {
      case 0:
        return 'Registre la ubicación del trabajo para continuar.';
      case 1:
        return 'Añada al menos una foto del problema.';
      case 2:
        return 'Añada al menos una foto de la solución.';
      case 3:
        return 'Describa el trabajo ejecutado.';
      case 4:
        return 'Registre la hora de finalización.';
      default:
        return 'Complete este paso para continuar.';
    }
  }

  /// Texto de lo que falta cuando el paso ya tiene datos pero falta la
  /// confirmación explícita del técnico.
  String _mensajeFaltaConfirmar(int paso) {
    switch (paso) {
      case 0:
        return 'Confirme la ubicación registrada para continuar.';
      case 1:
        return 'Confirme las fotos del problema para continuar.';
      case 2:
        return 'Confirme las fotos de la solución para continuar.';
      case 3:
        return 'Confirme el trabajo ejecutado para continuar.';
      default:
        return 'Confirme este paso para continuar.';
    }
  }

  /// Qué falta para poder finalizar la tarea.
  String? get mensajePendiente {
    final paso = pasoPendiente;
    if (paso == null) return null;
    if (!pasoConDatos(paso)) return _mensajeFaltaDato(paso);
    return _mensajeFaltaConfirmar(paso);
  }

  /// Revela el paso pendiente para que el técnico vea qué le falta, sin
  /// desbloquear de golpe los pasos posteriores. Marca el campo pendiente
  /// en rojo.
  void revelarPasoPendiente() {
    _showValidationErrors = true;
    _revelarHastaPasoPendiente();
    _notificar();
  }

  double get progress {
    var completados = 0;
    for (var paso = 0; paso < totalPasos; paso++) {
      if (pasoConfirmado(paso)) completados++;
    }
    return completados / totalPasos;
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
      pasosConfirmados: _pasosConfirmados.isEmpty
          ? null
          : (_pasosConfirmados.toList()..sort()).join(','),
    );
  }

  void iniciarAhora() {
    fechaInicio = _clock().toLocal();
    saveDraft();
    _notificar();
  }

  bool updateFechaInicio(DateTime date) {
    if (date.isAfter(_clock())) {
      _errorMsg = 'La hora de inicio no puede ser posterior a la hora actual.';
      _notificar();
      return false;
    }
    fechaInicio = date.toLocal();
    _errorMsg = null;
    saveDraft();
    _notificar();
    return true;
  }

  void updateFechaFin(DateTime date) {
    // La finalización debe ser posterior al inicio. Se valida con el mismo
    // criterio que usa `submit()` para que el selector de hora y el envío
    // no se contradigan.
    if (fechaInicio != null && !date.isAfter(fechaInicio!)) {
      _errorMsg = 'La finalización no puede ser anterior al inicio';
      _notificar();
      return;
    }
    fechaFin = date;
    _errorMsg = null;
    saveDraft();
    _notificar();
  }

  void finalizarAhora() {
    if (fechaInicio != null && DateTime.now().isBefore(fechaInicio!)) {
      _errorMsg = 'La finalización no puede ser anterior al inicio';
      _notificar();
      return;
    }
    fechaFin = DateTime.now();
    _errorMsg = null;
    saveDraft();
    _notificar();
  }

  Future<void> recordLocation() async {
    isLocating = true;
    _errorMsg = null;
    _lastLocationError = null;
    _notificar();

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
      _notificar();
    }
  }

  Future<void> takeFotoProblema(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        imageQuality: 60,
        maxWidth: 1600,
      );
      if (photo != null) await agregarFotoProblema(photo.path);
    } catch (e) {
      _errorMsg = 'Error al tomar foto del problema';
      _notificar();
    }
  }

  /// Agrega una foto del problema. No desbloquea el siguiente paso: eso
  /// ocurre cuando el técnico confirma el bloque.
  Future<void> agregarFotoProblema(String path) async {
    _fotosProblema.add(path);
    _errorMsg = null;
    await saveDraft();
    _notificar();
  }

  Future<void> takeFotoSolucion(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        imageQuality: 60,
        maxWidth: 1600,
      );
      if (photo != null) await agregarFotoSolucion(photo.path);
    } catch (e) {
      _errorMsg = 'Error al tomar foto de la solucion';
      _notificar();
    }
  }

  /// Agrega una foto de la solución. No desbloquea el siguiente paso: eso
  /// ocurre cuando el técnico confirma el bloque.
  Future<void> agregarFotoSolucion(String path) async {
    _fotosSolucion.add(path);
    _errorMsg = null;
    await saveDraft();
    _notificar();
  }

  void removeFotoProblema(int index) {
    if (index < 0 || index >= _fotosProblema.length) return;
    _fotosProblema.removeAt(index);
    saveDraft();
    _notificar();
  }

  void removeFotoSolucion(int index) {
    if (index < 0 || index >= _fotosSolucion.length) return;
    _fotosSolucion.removeAt(index);
    saveDraft();
    _notificar();
  }

  Future<bool> submit() async {
    // No se envía nada hasta que el técnico haya confirmado cada bloque.
    if (!puedeFinalizar) {
      _showValidationErrors = true;
      // El flujo progresivo deja ocultos los pasos que todavía no
      // corresponden: se revela únicamente el primero pendiente para que el
      // mensaje sea verificable sin saturar al técnico de golpe.
      _revelarHastaPasoPendiente();
      _errorMsg = mensajePendiente ?? 'Debe completar los campos obligatorios.';
      _notificar();
      return false;
    }

    _showValidationErrors = false;

    if (!fechaFin!.isAfter(fechaInicio!)) {
      _errorMsg =
          'La finalización debe ser posterior a la fecha y hora de inicio';
      _notificar();
      return false;
    }

    _isSubmitting = true;
    _errorMsg = null;
    _notificar();

    try {
      final solutionPhotos = List<String>.from(_fotosSolucion);
      if (_userSignature != null) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/signature_${os.id}.png');
        if (file.existsSync()) {
          solutionPhotos.add(file.path);
        }
      }

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
            solutionPhotos.isNotEmpty ? solutionPhotos.join(',') : null,
        fechaEjecucionInicio: fechaInicio?.toUtc().toIso8601String(),
        fechaEjecucionFin: fechaFin?.toUtc().toIso8601String(),
      );

      // Si todo fue exitoso y la sincronización no arrojó excepción no capturada
      // borramos el draft
      await _syncQueueStorageService.deleteDraft(os.id);

      _isSubmitting = false;
      _notificar();
      return true;
    } catch (e) {
      _isSubmitting = false;
      _errorMsg =
          'No se pudo subir la orden al sistema de inmediato. Se intentará en segundo plano si hay red.';
      _notificar();
      // Retornamos true porque la orden sí se guardó en local y se intentará reenviar.
      // Así el usuario puede continuar.
      return true;
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
    _disposed = true;

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
