import 'package:flutter/material.dart';
import '../../../../domain/models/reclamo.dart';
import '../../../../domain/use_cases/crear_reclamo_use_case.dart';

import 'package:dio/dio.dart';

class NuevoReclamoViewModel extends ChangeNotifier {
  final CrearReclamoUseCase _crearReclamoUseCase;

  final TextEditingController codigoController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numeroMedidorController = TextEditingController();

  String _formato = 'Anexo 6';
  String _canalEntrada = 'Presencial';
  String _tipoProblema = 'OP-1';
  final String _estado = 'PENDIENTE';

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

  final Map<String, String?> fieldErrors = {};

  static const _canales = [
    'Presencial',
    'Call Center',
    'Llamada Directa',
  ];
  static const _tiposProblemaAnexo6 = [
    'OP-1',
    'OP-2',
    'OP-3',
    'OP-4',
    'OP-5',
    'OP-6',
    'OP-7',
  ];
  static const _descripcionesProblemaAnexo6 = {
    'OP-1': 'Obras inconclusas (vereda pendiente, calzada pendiente)',
    'OP-2':
        'Fugas en la red de agua potable e inundaciones (roturas de tuberías en redes matriz y secundaria, fuga de agua en vereda o en calzada)',
    'OP-3': 'Desbordes en la red de alcantarillado (rotura de tubería)',
    'OP-4':
        'Atoro en conexión de alcantarillado e inundaciones (taponamiento de conexiones en una zona, taponamiento con desborde en la calle)',
    'OP-5':
        'Cortes del servicio (efectuar cortes del servicio no programados, no cumplir con horario de abastecimiento injustificadamente, no informar a los usuarios sobre los casos fortuitos o de fuerza mayor)',
    'OP-6':
        'Falta de accesorios de seguridad (mantener por mas de 24 horas abierto el buzon del sistema de alcantarillado, pozo abierto, falta de tapa de registro, falta de tapa de medidor, falta de conexión de agua, ausencia de vallas de señalización y cintas de seguridad donde sea necesario por ejecución)',
    'OP-7': 'Seguridad: Emanaciones del sistema de alcantarillado',
  };
  static const _tiposProblemaFormato1 = [
    'B1',
    'B5',
    'B8',
    'B9',
    'B10',
    'B11',
    'B13',
    'B14',
    'FALTA DE PRESIÓN DE AGUA',
    'REPOSICIÓN DE CAJA DE MEDIDOR',
    'REPOSICIÓN DE MEDIDOR POR HURTO',
    'CAMBIO DE LLAVE DE PASO',
    'REUBICACIÓN DE CONEXION',
    'REPOSICIÓN DE MARCO Y TAPA DE AGUA',
    'NIVELACIÓN DE CAJA DE REGISTRO DE AGUA',
    'B6',
    'B7',
    'B12',
    'REPOSICIÓN DE MARCO Y TAPA DE DESAGÜE',
    'NIVELACIÓN DE CAJA DE REGISTRO DE DESAGÜE',
    'REPOSICIÓN DE TUBERIA DE CONCRETO A PVC - DESAGÜE',
    'A1',
    'TRABAJOS COLATERAS',
    'OTROS',
  ];
  static const _descripcionesProblemaFormato1 = {
    'B1':
        'Agua potable · FUGAS EN CONEXION DOMICILIARIA (fuga en el medidor o tubo de entrada a la casa)',
    'B5':
        'Agua potable · FUGAS EN RED MATRIZ (rotura de tubería principal de agua en la calle)',
    'B8':
        'Agua potable · FALTA DE AGUA (corte de suministro o desabastecimiento)',
    'B9':
        'Agua potable · LIMPIEZA LLAVE DE TOMA (mantenimiento de la llave principal)',
    'B10':
        'Agua potable · FUGA DE AGUA EN CAJA MEDIDOR (fuga visible en la caja de la vereda)',
    'B11':
        'Agua potable · MANTENIMIENTO DE MEDIDOR (limpieza o cambio de medidor)',
    'B13':
        'Agua potable · CALIDAD DE AGUA (agua turbia, con olor o sabor inusual)',
    'B14':
        'Agua potable · INSTALACION DE MEDIDOR (instalación de micromedición)',
    'FALTA DE PRESIÓN DE AGUA':
        'Agua potable · Presión insuficiente en el predio',
    'REPOSICIÓN DE CAJA DE MEDIDOR':
        'Agua potable · Caja de medidor rota o deteriorada',
    'REPOSICIÓN DE MEDIDOR POR HURTO': 'Agua potable · Robo del medidor',
    'CAMBIO DE LLAVE DE PASO': 'Agua potable · Válvula de control malograda',
    'REUBICACIÓN DE CONEXION':
        'Agua potable · Mover la toma de agua a otro punto',
    'REPOSICIÓN DE MARCO Y TAPA DE AGUA':
        'Agua potable · Cambio de la cubierta protectora',
    'NIVELACIÓN DE CAJA DE REGISTRO DE AGUA':
        'Agua potable · Ajustar la caja a la altura de la vereda',
    'B6':
        'Desagüe · ATORO EN CONEXION DOMICILIARIA (obstrucción en la salida de desagüe del predio)',
    'B7':
        'Desagüe · ATORO EN RED DE MATRIZ (obstrucción de la red principal de alcantarillado en la calle)',
    'B12':
        'Desagüe · BUZON SIN TAPA (peligro de buzón abierto en la vía pública)',
    'REPOSICIÓN DE MARCO Y TAPA DE DESAGÜE':
        'Desagüe · Tapa de registro domiciliario dañada',
    'NIVELACIÓN DE CAJA DE REGISTRO DE DESAGÜE':
        'Desagüe · Alinear la caja de registro de desagüe a la vereda',
    'REPOSICIÓN DE TUBERIA DE CONCRETO A PVC - DESAGÜE':
        'Desagüe · Modernización de redes viejas',
    'A1':
        'Otros · FILTRACION DE AGUA EXTERNAS HACIA EL PREDIO (humedad o filtraciones de la calle hacia la casa del usuario)',
    'TRABAJOS COLATERAS':
        'Otros · Daños incidentales a veredas o pistas tras reparaciones',
    'OTROS': 'Otros · Reclamos generales sin categoría definida',
  };
  static const _formatos = ['Anexo 6', 'Formato 1'];

  static List<String> get canales => _canales;
  static List<String> get formatos => _formatos;

  List<String> get tiposProblema =>
      _formato == 'Formato 1' ? _tiposProblemaFormato1 : _tiposProblemaAnexo6;

  Map<String, String> get descripcionesProblema => _formato == 'Formato 1'
      ? _descripcionesProblemaFormato1
      : _descripcionesProblemaAnexo6;

  NuevoReclamoViewModel({required CrearReclamoUseCase crearReclamoUseCase})
      : _crearReclamoUseCase = crearReclamoUseCase;

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
    final numeroMedidor = numeroMedidorController.text.trim();
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
    if (numeroMedidor.isEmpty) {
      fieldErrors['numero_medidor'] = 'Requerido';
    } else if (!RegExp(r'^\d{7}$').hasMatch(numeroMedidor)) {
      fieldErrors['numero_medidor'] = 'Debe tener exactamente 7 dígitos';
    } else if (numeroMedidor == '0000000') {
      fieldErrors['numero_medidor'] = 'No puede ser 0000000';
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
        numeroMedidor: numeroMedidor.isEmpty ? null : numeroMedidor,
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
    numeroMedidorController.dispose();
    super.dispose();
  }
}
