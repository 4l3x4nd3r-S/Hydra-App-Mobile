import '../models/reclamo_dto.dart';
import '../models/cuadrilla_dto.dart';
import '../models/gasfitero_dto.dart';
import '../models/os_dto.dart';
import '../models/responsable_dto.dart';
import '../services/supervisor_api_service.dart';
import '../../domain/models/reclamo.dart';
import '../../domain/models/cuadrilla.dart';
import '../../domain/models/gasfitero.dart';
import '../../domain/models/os.dart';

class SupervisorRepository {
  final SupervisorApiService _apiService;

  SupervisorRepository({required SupervisorApiService apiService})
      : _apiService = apiService;

  Future<List<Reclamo>> getReclamos() async {
    final response = await _apiService.getReclamos();
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((json) => ReclamoDto.fromJson(json as Map<String, dynamic>))
          .map(_reclamoToDomain)
          .toList();
    }
    return [];
  }

  Future<List<Os>> getOrdenesServicio() async {
    final response = await _apiService.getOrdenesServicio();
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((json) => OsDto.fromJson(json as Map<String, dynamic>))
          .map(_osToDomain)
          .toList();
    }
    return [];
  }

  Future<List<Cuadrilla>> getCuadrillas() async {
    final response = await _apiService.getCuadrillas();
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((json) => CuadrillaDto.fromJson(json as Map<String, dynamic>))
          .map(_cuadrillaToDomain)
          .toList();
    }
    return [];
  }

  Future<List<Gasfitero>> getgasfiteros() async {
    final response = await _apiService.getgasfiteros();
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((json) => GasfiteroDto.fromJson(json as Map<String, dynamic>))
          .map(_gasfiteroToDomain)
          .toList();
    }
    return [];
  }

  Future<List<Gasfitero>> getgasfiterosDisponibles() async {
    final response = await _apiService.getgasfiterosDisponibles();
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((json) => GasfiteroDto.fromJson(json as Map<String, dynamic>))
          .map(_gasfiteroToDomain)
          .toList();
    }
    return [];
  }

  Future<Os> createOsFromReclamo({
    required int reclamoId,
    required int cuadrillaId,
  }) async {
    final response = await _apiService.createOrdenServicioFromReclamo(
      reclamoId: reclamoId,
      cuadrillaId: cuadrillaId,
    );
    final dto = OsDto.fromJson(response.data as Map<String, dynamic>);
    return _osToDomain(dto);
  }

  Future<Cuadrilla> getCuadrilla(int id) async {
    final response = await _apiService.getCuadrilla(id);
    final dto = CuadrillaDto.fromJson(response.data as Map<String, dynamic>);
    return _cuadrillaToDomain(dto);
  }

  Future<Reclamo> crearReclamo(Reclamo borrador) async {
    final response = await _apiService.crearReclamo(_toCreateJson(borrador));
    final dto = ReclamoDto.fromJson(response.data as Map<String, dynamic>);
    return _reclamoToDomain(dto);
  }

  Future<void> addGasfitero({
    required int cuadrillaId,
    required int usuarioId,
    String rol = 'APOYO',
  }) async {
    await _apiService.addPersonal(
      cuadrillaId: cuadrillaId,
      usuarioId: usuarioId,
      rol: rol,
    );
  }

  Future<void> removeGasfitero({
    required int cuadrillaId,
    required int usuarioId,
  }) async {
    await _apiService.removePersonal(
      cuadrillaId: cuadrillaId,
      usuarioId: usuarioId,
    );
  }

  Future<Cuadrilla> updateCuadrillaPersonal({
    required int cuadrillaId,
    required int liderId,
    required List<int> apoyosIds,
    int? choferId,
    int? operadorId,
  }) async {
    final response = await _apiService.updatePersonal(
      cuadrillaId: cuadrillaId,
      personal: {
        'lider_id': liderId,
        'apoyos_ids': apoyosIds,
        'chofer_id': choferId,
        'operador_id': operadorId,
      },
    );
    final dto = CuadrillaDto.fromJson(response.data as Map<String, dynamic>);
    return _cuadrillaToDomain(dto);
  }

  Future<Cuadrilla> createCuadrilla({
    required String especialidad,
    int? liderId,
    List<int> apoyosIds = const [],
    int? choferId,
    int? operadorId,
  }) async {
    final body = <String, dynamic>{
      'especialidad': especialidad,
    };
    if (liderId != null) {
      body['personal'] = {
        'lider_id': liderId,
        'apoyos_ids': apoyosIds,
        'chofer_id': choferId,
        'operador_id': operadorId,
      };
    }
    final response = await _apiService.createCuadrilla(body);
    final dto = CuadrillaDto.fromJson(response.data as Map<String, dynamic>);
    return _cuadrillaToDomain(dto);
  }

  Future<void> deleteCuadrilla(int id) async {
    await _apiService.deleteCuadrilla(id);
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

  Os _osToDomain(OsDto dto) {
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

  Map<String, dynamic> _toCreateJson(Reclamo r) => {
        'formato': r.formato,
        'codigo_solicitud': r.codigoSolicitud,
        'canal_entrada': r.canalEntrada,
        'tipo_problema': r.tipoProblema,
        'estado': r.estado ?? 'PENDIENTE',
        'descripcion': r.descripcion,
        'nombre_solicitante': r.nombreSolicitante,
        'direccion': r.direccion,
        'telefono': r.telefono,
        'email': r.email,
        'numero_medidor': r.numeroMedidor,
        'fecha_registro': r.fechaRegistro,
        'latitud': null,
        'longitud': null,
      };
}
