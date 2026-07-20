import 'package:flutter/material.dart';
import '../../../../domain/models/reclamo.dart';
import '../../../../domain/use_cases/crear_reclamo_use_case.dart';
import '../../../../data/repositories/catalog_repository.dart';
import '../../../../domain/models/catalog_option.dart';

import 'package:dio/dio.dart';

class NuevoReclamoViewModel extends ChangeNotifier {
  final CrearReclamoUseCase _crearReclamoUseCase;
  final CatalogRepository _catalogRepository;

  final TextEditingController codigoController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numeroSuministroController =
      TextEditingController();

  String _formato = '';
  String _canalEntrada = '';
  String _tipoProblema = '';
  String _estado = '';

  String get formato => _formato;
  String get canalEntrada => _canalEntrada;
  String get tipoProblema => _tipoProblema;

  DateTime _fechaRegistro = DateTime.now();
  DateTime get fechaRegistro => _fechaRegistro;

  bool _submitting = false;
  bool _success = false;
  String? _errorMsg;

  bool get submitting => _submitting;
  bool get success => _success;
  String? get errorMsg => _errorMsg;

  bool _loadingCatalogs = true;
  bool get loadingCatalogs => _loadingCatalogs;
  String? _catalogError;
  String? get catalogError => _catalogError;
  List<CatalogOption> _catalogOptions = const [];

  final Map<String, String?> fieldErrors = {};

  List<String> get canales => _codesFor('CANAL_RECLAMO');
  List<String> get formatos => _codesFor('FORMATO_RECLAMO');
  List<String> get tiposProblema => _catalogOptions
      .where((option) =>
          option.group == 'TIPO_PROBLEMA' && option.parentCode == _formato)
      .map((option) => option.code)
      .toList(growable: false);
  Map<String, String> get descripcionesProblema => {
        for (final option in _catalogOptions.where((option) =>
            option.group == 'TIPO_PROBLEMA' && option.parentCode == _formato))
          option.code: option.description ?? '',
      };

  NuevoReclamoViewModel({
    required CrearReclamoUseCase crearReclamoUseCase,
    required CatalogRepository catalogRepository,
  })  : _crearReclamoUseCase = crearReclamoUseCase,
        _catalogRepository = catalogRepository {
    _loadCatalogs();
  }

  List<String> _codesFor(String group) => _catalogOptions
      .where((option) => option.group == group)
      .map((option) => option.code)
      .toList(growable: false);

  String _defaultFor(String group, List<CatalogOption> options) {
    final groupOptions = options.where((option) => option.group == group);
    if (groupOptions.isEmpty) return '';
    return groupOptions
        .firstWhere((option) => option.isDefault,
            orElse: () => groupOptions.first)
        .code;
  }

  Future<void> _loadCatalogs() async {
    try {
      final options = await _catalogRepository.getOptions();
      _catalogOptions = options;
      _formato = _defaultFor('FORMATO_RECLAMO', options);
      _canalEntrada = _defaultFor('CANAL_RECLAMO', options);
      _estado = _defaultFor('ESTADO_RECLAMO', options);
      final types = tiposProblema;
      _tipoProblema = types.isEmpty ? '' : types.first;
    } catch (_) {
      _catalogError = 'No se pudo cargar la configuración del formulario.';
    } finally {
      _loadingCatalogs = false;
      notifyListeners();
    }
  }

  void setFormato(String v) {
    if (_formato == v) return;
    _formato = v;
    if (!tiposProblema.contains(_tipoProblema)) {
      _tipoProblema = tiposProblema.first;
    }
    notifyListeners();
  }

  void setCanalEntrada(String v) {
    _canalEntrada = v;
    notifyListeners();
  }

  void setTipoProblema(String v) {
    if (!tiposProblema.contains(v)) return;
    _tipoProblema = v;
    notifyListeners();
  }

  void setFechaRegistro(DateTime v) {
    _fechaRegistro = v;
    notifyListeners();
  }

  void clearFieldError(String key) {
    fieldErrors[key] = null;
    notifyListeners();
  }

  Future<bool> submit() async {
    fieldErrors.clear();
    _errorMsg = null;

    final codigo = codigoController.text.trim();
    final descripcion = descripcionController.text.trim();
    final nombre = nombreController.text.trim();
    final telefono = telefonoController.text.trim();
    final email = emailController.text.trim();
    final numeroSuministro = numeroSuministroController.text.trim();
    final direccion = direccionController.text.trim();

    if (codigo.isEmpty) {
      fieldErrors['codigo_solicitud'] = 'Requerido';
    } else if (!RegExp(r'^\d{5}$').hasMatch(codigo)) {
      fieldErrors['codigo_solicitud'] = 'Debe tener exactamente 5 dígitos';
    } else if (codigo == '00000') {
      fieldErrors['codigo_solicitud'] = 'No puede ser 00000';
    }
    if (descripcion.isEmpty) {
      fieldErrors['descripcion'] = 'Requerido';
    } else if (descripcion.length > 500) {
      fieldErrors['descripcion'] = 'Máximo 500 caracteres';
    }
    if (nombre.isEmpty) {
      fieldErrors['nombre_solicitante'] = 'Requerido';
    } else if (nombre.length > 100) {
      fieldErrors['nombre_solicitante'] = 'Máximo 100 caracteres';
    } else if (!RegExp(r'^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$').hasMatch(nombre)) {
      fieldErrors['nombre_solicitante'] = 'Solo letras y espacios';
    }
    if (telefono.isEmpty) {
      fieldErrors['telefono'] = 'Requerido';
    } else if (!RegExp(r'^9\d{8}$').hasMatch(telefono)) {
      fieldErrors['telefono'] = 'Debe empezar con 9 y tener 9 dígitos';
    }
    if (email.isEmpty) {
      fieldErrors['email'] = 'Requerido';
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      fieldErrors['email'] = 'Email inválido';
    }
    if (direccion.isEmpty) {
      fieldErrors['direccion'] = 'Requerido';
    } else if (direccion.length > 255) {
      fieldErrors['direccion'] = 'Máximo 255 caracteres';
    }
    if (numeroSuministro.isEmpty) {
      fieldErrors['numero_suministro'] = 'Requerido';
    } else if (!RegExp(r'^\d{7}$').hasMatch(numeroSuministro)) {
      fieldErrors['numero_suministro'] = 'Debe tener exactamente 7 dígitos';
    } else if (numeroSuministro == '0000000') {
      fieldErrors['numero_suministro'] = 'No puede ser 0000000';
    }

    if (fieldErrors.isNotEmpty) {
      notifyListeners();
      return false;
    }

    _submitting = true;
    notifyListeners();

    try {
      final nuevo = Reclamo(
        id: 0,
        formato: _formato,
        codigoSolicitud: codigo,
        canalEntrada: _canalEntrada,
        tipoProblema: _tipoProblema,
        estado: _estado,
        descripcion: descripcion,
        nombreSolicitante: nombre,
        telefono: telefono.isEmpty ? null : telefono,
        email: email.isEmpty ? null : email,
        numeroSuministro: numeroSuministro.isEmpty ? null : numeroSuministro,
        direccion: direccion.isEmpty ? null : direccion,
        fechaRegistro: _fechaRegistro.toIso8601String(),
      );
      await _crearReclamoUseCase(nuevo);
      _success = true;
      _submitting = false;
      notifyListeners();
      return true;
    } on DioException {
      _errorMsg = 'Error al crear reclamo';
      _submitting = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMsg = 'Error al crear reclamo';
      _submitting = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    codigoController.dispose();
    descripcionController.dispose();
    nombreController.dispose();
    direccionController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    numeroSuministroController.dispose();
    super.dispose();
  }
}
