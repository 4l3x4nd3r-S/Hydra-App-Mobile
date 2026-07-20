import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../../data/repositories/catastro_repository.dart';

class CatastroElement {
  final String nombre;
  final String tipo;
  final String estado;
  final LatLng ubicacion;

  CatastroElement({
    required this.nombre,
    required this.tipo,
    required this.estado,
    required this.ubicacion,
  });
}

class CatastroSector {
  final String nombre;
  final List<LatLng> puntos;
  final Color color;
  final LatLng centroid;

  CatastroSector({
    required this.nombre,
    required this.puntos,
    required this.color,
    required this.centroid,
  });
}

class CatastroGisViewModel extends ChangeNotifier {
  CatastroGisViewModel({required CatastroRepository catastroRepository})
      : _catastroRepository = catastroRepository;

  final CatastroRepository _catastroRepository;

  bool isLoading = true;
  String? error;
  List<CatastroElement> valvulas = [];
  List<CatastroElement> puntosPresion = [];
  List<CatastroSector> sectores = [];
  bool showPipesAndSectors = true;
  bool showValves = true;
  bool showPressurePoints = true;
  String searchQuery = '';

  Future<void> loadDynamicData() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final valvesFuture = _catastroRepository.getValvulas();
      final pointsFuture = _catastroRepository.getPuntosPresion();
      final sectorsFuture = _catastroRepository.getSectores();
      final valves = await valvesFuture;
      final points = await pointsFuture;
      final serverSectors = await sectorsFuture;

      final result = await compute(_processData, {
        'valves': valves,
        'points': points,
        'sectors': serverSectors,
      });

      valvulas = result['valvulas'] as List<CatastroElement>;
      puntosPresion = result['puntosPresion'] as List<CatastroElement>;
      sectores = result['sectores'] as List<CatastroSector>;
    } catch (_) {
      error = 'No se pudo cargar el catastro desde el servidor';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  static Map<String, dynamic> _processData(Map<String, dynamic> data) {
    final valves = data['valves'] as List<dynamic>;
    final points = data['points'] as List<dynamic>;
    final serverSectors = data['sectors'] as List<dynamic>;

    final valvulas = valves
        .where((item) => item.latitud != null && item.longitud != null)
        .map((item) => CatastroElement(
              nombre: item.codigoPlano ?? '',
              tipo: item.tipo ?? '',
              estado: item.estadoOperativo ?? '',
              ubicacion: LatLng(item.latitud!, item.longitud!),
            ))
        .toList(growable: false);
        
    final puntosPresion = points
        .where((item) => item.latitud != null && item.longitud != null)
        .map((item) => CatastroElement(
              nombre: item.codigoPunto ?? '',
              tipo: 'PUNTO_PRESION',
              estado: '',
              ubicacion: LatLng(item.latitud!, item.longitud!),
            ))
        .toList(growable: false);

    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
    ];
    
    final sectores = <CatastroSector>[];
    for (var index = 0; index < serverSectors.length; index++) {
      final sector = serverSectors[index];
      final points = _parsePolygon(sector.geometriaGeojson);
      if (points.isEmpty) continue;
      final sumLat =
          points.fold<double>(0, (sum, point) => sum + point.latitude);
      final sumLng =
          points.fold<double>(0, (sum, point) => sum + point.longitude);
      sectores.add(CatastroSector(
        nombre: sector.nombre ?? '',
        puntos: points,
        color: colors[index % colors.length].withValues(alpha: 0.3),
        centroid: LatLng(sumLat / points.length, sumLng / points.length),
      ));
    }

    return {
      'valvulas': valvulas,
      'puntosPresion': puntosPresion,
      'sectores': sectores,
    };
  }

  static List<LatLng> _parsePolygon(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    final geometry = jsonDecode(raw) as Map<String, dynamic>;
    final coordinates = geometry['coordinates'] as List<dynamic>?;
    if (geometry['type'] != 'Polygon' ||
        coordinates == null ||
        coordinates.isEmpty) {
      return const [];
    }
    final ring = coordinates.first as List<dynamic>;
    return ring.map((value) {
      final coordinate = value as List<dynamic>;
      return LatLng(
        (coordinate[1] as num).toDouble(),
        (coordinate[0] as num).toDouble(),
      );
    }).toList(growable: false);
  }

  void togglePipesAndSectors(bool value) {
    showPipesAndSectors = value;
    notifyListeners();
  }

  void toggleValves(bool value) {
    showValves = value;
    notifyListeners();
  }

  void togglePressurePoints(bool value) {
    showPressurePoints = value;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }
}
