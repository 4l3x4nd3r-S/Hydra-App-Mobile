import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

class ParseGeoJsonRequest {
  final String jsonString;
  final String defaultType;
  final String defaultState;
  final String nameField;

  ParseGeoJsonRequest(this.jsonString, this.defaultType, this.defaultState, this.nameField);
}

List<CatastroElement> parseGeoJsonIsolate(ParseGeoJsonRequest req) {
  final data = json.decode(req.jsonString) as Map<String, dynamic>;
  final features = data['features'] as List<dynamic>? ?? [];
  final List<CatastroElement> elements = [];

  for (var feature in features) {
    if (feature['geometry'] != null && feature['geometry']['type'] == 'Point') {
      final coords = feature['geometry']['coordinates'] as List<dynamic>;
      final props = feature['properties'] ?? {};
      
      final lat = (coords[1] as num).toDouble();
      final lng = (coords[0] as num).toDouble();
      
      final nombre = props['id']?.toString() ?? props['name']?.toString() ?? props['Name']?.toString() ?? props[req.nameField]?.toString() ?? 'Sin nombre';
      final estado = props['estado']?.toString() ?? props['Estado']?.toString() ?? req.defaultState;
      
      elements.add(CatastroElement(
        nombre: nombre,
        tipo: req.defaultType,
        estado: estado,
        ubicacion: LatLng(lat, lng),
      ));
    }
  }
  return elements;
}

List<CatastroSector> parseSectoresIsolate(String jsonString) {
  final data = json.decode(jsonString) as Map<String, dynamic>;
  final features = data['features'] as List<dynamic>? ?? [];
  final List<CatastroSector> sectors = [];

  final colors = [
    Colors.blue, Colors.green, Colors.orange, Colors.purple,
    Colors.red, Colors.teal, Colors.pink, Colors.indigo,
    Colors.amber, Colors.cyan
  ];

  for (int i = 0; i < features.length; i++) {
    final feature = features[i];
    if (feature['geometry'] != null && feature['geometry']['type'] == 'Polygon') {
      final coords = feature['geometry']['coordinates'] as List<dynamic>;
      if (coords.isNotEmpty) {
        final ring = coords[0] as List<dynamic>;
        final puntos = ring.map((pt) {
          final p = pt as List<dynamic>;
          return LatLng((p[1] as num).toDouble(), (p[0] as num).toDouble());
        }).toList();
        
        final props = feature['properties'] ?? {};
        final nombre = props['name']?.toString() ?? props['sector']?.toString() ?? 'Sector ${i + 1}';
        
        // Calcular centroide simple (promedio)
        double sumLat = 0;
        double sumLng = 0;
        for (var pt in puntos) {
          sumLat += pt.latitude;
          sumLng += pt.longitude;
        }
        final centroid = LatLng(sumLat / puntos.length, sumLng / puntos.length);

        sectors.add(CatastroSector(
          nombre: nombre.startsWith('Sector') ? nombre : 'Sector $nombre',
          puntos: puntos,
          color: colors[i % colors.length].withValues(alpha: 0.3),
          centroid: centroid,
        ));
      }
    }
  }
  return sectors;
}

class CatastroGisViewModel extends ChangeNotifier {
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
      // Cargar Válvulas de aire
      final valvulasAireJson = await rootBundle.loadString('assets/geojson/valvulas_de_aire.geojson');
      final valvulasSeccJson = await rootBundle.loadString('assets/geojson/valvulas_seccionamiento_consolidado.geojson');
      
      final valvulasAire = await compute(parseGeoJsonIsolate, ParseGeoJsonRequest(valvulasAireJson, 'Válvula de Aire', 'Activo', 'Name'));
      final valvulasSecc = await compute(parseGeoJsonIsolate, ParseGeoJsonRequest(valvulasSeccJson, 'Válvula de Seccionamiento', 'Activo', 'Name'));
      
      valvulas = [...valvulasAire, ...valvulasSecc];

      // Cargar Puntos de Presión estrictamente el solicitado
      final pp3Json = await rootBundle.loadString('assets/geojson/puntos_presion_puerto_maldonado.geojson');
      final pp3 = await compute(parseGeoJsonIsolate, ParseGeoJsonRequest(pp3Json, 'Punto de Presión', 'Operativo', 'Name'));
      
      puntosPresion = [...pp3];

      // Cargar Sectores (reversión a GeoJSON por ahora)
      final sectoresJson = await rootBundle.loadString('assets/geojson/sectores_de_agua.geojson');
      sectores = await compute(parseSectoresIsolate, sectoresJson);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = 'Error al cargar mapa GIS';
      isLoading = false;
      notifyListeners();
    }
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
