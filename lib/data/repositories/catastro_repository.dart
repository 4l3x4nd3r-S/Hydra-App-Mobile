import '../models/elemento_red_dto.dart';
import '../models/sector_dto.dart';
import '../models/punto_presion_dto.dart';
import '../models/registro_presion_dto.dart';
import '../services/catastro_api_service.dart';
import '../../domain/models/datalogger.dart';
import '../../domain/models/valvula.dart';
import '../../domain/models/sector.dart';
import '../../domain/models/punto_presion.dart';
import '../../domain/models/registro_presion.dart';

class CatastroRepository {
  final CatastroApiService _apiService;

  CatastroRepository({required CatastroApiService apiService})
      : _apiService = apiService;

  Future<List<Datalogger>> getDataloggers() async {
    final response = await _apiService.getElementosRed();
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map(
              (json) => ElementoRedDto.fromJson(json as Map<String, dynamic>))
          .where((e) =>
              (e.tipo?.toUpperCase() ?? '') == 'DATALOGGER')
          .map(_dataloggerToDomain)
          .toList();
    }
    return [];
  }

  Future<List<Valvula>> getValvulas() async {
    final response = await _apiService.getElementosRed();
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map(
              (json) => ElementoRedDto.fromJson(json as Map<String, dynamic>))
          .where(
              (e) => (e.tipo?.toUpperCase() ?? '') == 'VALVULA')
          .map(_valvulaToDomain)
          .toList();
    }
    return [];
  }

  Future<List<Sector>> getSectores() async {
    final response = await _apiService.getSectores();
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((json) =>
              SectorDto.fromJson(json as Map<String, dynamic>))
          .map(_sectorToDomain)
          .toList();
    }
    return [];
  }

  Future<List<PuntoPresion>> getPuntosPresion() async {
    final response = await _apiService.getPuntosPresion();
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((json) => PuntoPresionDto.fromJson(
              json as Map<String, dynamic>))
          .map(_puntoToDomain)
          .toList();
    }
    return [];
  }

  Future<RegistroPresion?> getUltimoRegistroPresion(int puntoId) async {
    final response =
        await _apiService.getUltimoRegistroPresion(puntoId);
    if (response.statusCode == 200 && response.data != null) {
      final dto = RegistroPresionDto.fromJson(
          response.data as Map<String, dynamic>);
      return _registroToDomain(dto);
    }
    return null;
  }

  Datalogger _dataloggerToDomain(ElementoRedDto dto) {
    return Datalogger(
      id: dto.id,
      codigoPlano: dto.codigoPlano,
      tipo: dto.tipo,
      sectorId: dto.sectorId,
      latitud: dto.latitud,
      longitud: dto.longitud,
      estadoOperativo: dto.estadoOperativo,
      fechaModificacion: dto.fechaModificacion,
    );
  }

  Valvula _valvulaToDomain(ElementoRedDto dto) {
    return Valvula(
      id: dto.id,
      codigoPlano: dto.codigoPlano,
      tipo: dto.tipo,
      sectorId: dto.sectorId,
      latitud: dto.latitud,
      longitud: dto.longitud,
      estadoOperativo: dto.estadoOperativo,
      estadoValvula: dto.estadoValvula,
      fechaModificacion: dto.fechaModificacion,
    );
  }

  Sector _sectorToDomain(SectorDto dto) {
    return Sector(
      id: dto.id,
      nombre: dto.nombre,
      reservorioAsociado: dto.reservorioAsociado,
    );
  }

  PuntoPresion _puntoToDomain(PuntoPresionDto dto) {
    return PuntoPresion(
      id: dto.id,
      codigoPunto: dto.codigoPunto,
      sectorId: dto.sectorId,
      latitud: dto.latitud,
      longitud: dto.longitud,
    );
  }

  RegistroPresion _registroToDomain(RegistroPresionDto dto) {
    return RegistroPresion(
      fechaHora: dto.fechaHora,
      presionMca: dto.presionMca,
      temperaturaC: dto.temperaturaC,
      dispositivoSerie: dto.dispositivoSerie,
    );
  }
}
