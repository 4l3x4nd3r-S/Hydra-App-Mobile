# INSTRUCCIONES - DESARROLLADOR B: BANDEJA MAPA INTERACTIVO, GPS Y ORDENAMIENTO (paso_5)

Esta especificación técnica detalla cómo implementar el mapa interactivo de Google Maps, el ordenamiento de OTs por distancia en tiempo real basándose en la ubicación del celular, y el soporte offline para estas vistas en **HYDRA**.

---

## 🎯 Objetivo de Tarea
Mejorar la Bandeja de OTs (`lib/features/ot_inbox/presentation/inbox_screen.dart`) permitiendo al técnico alternar entre una vista de **Lista** y una de **Mapa interactivo**. Además, integrar el paquete `geolocator` para obtener las coordenadas GPS del celular, ordenar las OTs automáticamente por cercanía (la más cercana primero) y mostrar marcadores diferenciados por prioridad en el mapa.

---

## 📂 Archivos a Crear / Modificar
*   `lib/features/ot_inbox/presentation/inbox_screen.dart` (Modificar para integrar Geolocalización, Google Maps y alternador de vistas)

---

## 📋 Directrices de Programación y Flujo de Trabajo

### 1. Obtención de Ubicación en Vivo (`geolocator`)
*   Al abrir `InboxScreen`, solicita de manera proactiva los permisos de GPS mediante `Geolocator.requestPermission()`.
*   Obtén la ubicación actual del dispositivo usando `Geolocator.getCurrentPosition()`.
*   Calcula dinámicamente la distancia de cada OT al dispositivo en tiempo real usando:
    ```dart
    double distancia = Geolocator.distanceBetween(
      posicionActual.latitude,
      posicionActual.longitude,
      ot.latitud,
      ot.longitud,
    );
    ```
*   Ordena la lista de OTs en base a esta distancia (`distanciaMetros`) de forma ascendente.

### 2. Diseño de Vistas (Lista vs Mapa)
*   Añade una barra de botones horizontales (`ToggleButtons` o `IconButton` de alternancia estilizados con colores Slate `#1E293B` y Sky Blue `#38BDF8`) debajo de la cabecera para alternar entre "Vista Lista" y "Vista Mapa".

### 3. Mapa de Google Maps Interactivo
*   Integra el widget `GoogleMap`.
*   Inicializa la cámara del mapa en la posición actual del usuario.
*   Dibuja marcadores (`Marker`) para cada OT asignada:
    *   Asigna colores visuales según prioridad a cada pin/marcador:
        *   **Crítica**: Rojo (`BitmapDescriptor.hueRed`).
        *   **Alta**: Naranja/Ámbar (`BitmapDescriptor.hueOrange`).
        *   **Media**: Verde (`BitmapDescriptor.hueGreen`).
    *   Al presionar un marcador, abre un cuadro informativo flotante premium que muestre el ID de la OT, tipo de falla y un botón de "Ver Orden" que navegue directamente a la pantalla de ejecución `ExecutionScreen`.

### 4. Soporte Offline-First para el Mapa
*   Cuando la red móvil del técnico se pierde (`ConnectivityResult.none`), el mapa no puede descargar nuevas capas de Google.
*   **Comportamiento robusto:** Captura cualquier error o pérdida de red y degrada la interfaz graciosamente:
    *   Muestra un aviso sobre el mapa indicando: *"Modo Offline: Mostrando ubicaciones guardadas en caché local"*.
    *   Permite hacer clic y navegar a las OTs incluso sin conexión a internet.

---

## 🎨 Código Base y Plantilla de Integración para InboxScreen

Reemplaza e integra la siguiente estructura lógica dentro de `lib/features/ot_inbox/presentation/inbox_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../domain/ot_model.dart';
import '../../../../core/database/sync_service.dart';
import '../../ot_execution/presentation/execution_screen.dart';

class InboxScreen extends StatefulWidget {
  final SyncService syncService;

  const InboxScreen({super.key, required this.syncService});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  bool _showMap = false;
  Position? _currentPosition;
  bool _loadingLocation = true;
  GoogleMapController? _mapController;

  // Lista de OTs dinámicas
  List<OtModel> _ots = [];

  final List<OtModel> _baseMockOts = [
    OtModel(
      id: 104,
      sensorId: 'DL-02',
      pointId: 'TRIUNFO_P-02',
      sectorNombre: 'JASS El Triunfo',
      sectorId: 12,
      prioridad: 'CRITICA',
      tipoAlerta: 'ROTURA',
      diametroTeorico: '4 pulgadas',
      materialTeorico: 'ASBESTO CEMENTO',
      latitud: -12.5934,
      longitud: -69.1923,
      distanciaMetros: 0,
      fechaCreacion: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    OtModel(
      id: 105,
      sensorId: 'DL-08',
      pointId: 'P-38',
      sectorNombre: 'La Joya',
      sectorId: 9,
      prioridad: 'ALTA',
      tipoAlerta: 'FUGA',
      diametroTeorico: '3 pulgadas',
      materialTeorico: 'PVC',
      latitud: -12.5845,
      longitud: -69.1842,
      distanciaMetros: 0,
      fechaCreacion: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    OtModel(
      id: 106,
      sensorId: 'DL-01',
      pointId: 'P-04',
      sectorNombre: 'Centro Histórico',
      sectorId: 1,
      prioridad: 'MEDIA',
      tipoAlerta: 'FUGA',
      diametroTeorico: '2 pulgadas',
      materialTeorico: 'PVC',
      latitud: -12.5912,
      longitud: -69.1990,
      distanciaMetros: 0,
      fechaCreacion: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ots = List.from(_baseMockOts);
    _initGeolocation();
  }

  Future<void> _initGeolocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentPosition = position;
          _loadingLocation = false;
        });
        _calculateDistancesAndSort();
      } else {
        setState(() => _loadingLocation = false);
      }
    } catch (e) {
      setState(() => _loadingLocation = false);
      print("Error al obtener geolocalización: $e");
    }
  }

  void _calculateDistancesAndSort() {
    if (_currentPosition == null) return;

    for (var i = 0; i < _ots.length; i++) {
      final ot = _ots[i];
      final dist = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        ot.latitud,
        ot.longitud,
      );
      // Reemplazamos la OT con una con distancia real calculada
      _ots[i] = OtModel(
        id: ot.id,
        sensorId: ot.sensorId,
        pointId: ot.pointId,
        sectorNombre: ot.sectorNombre,
        sectorId: ot.sectorId,
        prioridad: ot.prioridad,
        tipoAlerta: ot.tipoAlerta,
        diametroTeorico: ot.diametroTeorico,
        materialTeorico: ot.materialTeorico,
        latitud: ot.latitud,
        longitud: ot.longitud,
        distanciaMetros: dist,
        fechaCreacion: ot.fechaCreacion,
      );
    }

    // Ordenamiento: Menor distancia primero
    _ots.sort((a, b) => a.distanciaMetros.compareTo(b.distanciaMetros));
    setState(() {});
  }

  Set<Marker> _buildMarkers() {
    return _ots.map((ot) {
      double color = BitmapDescriptor.hueGreen;
      if (ot.prioridad == 'CRITICA') {
        color = BitmapDescriptor.hueRed;
      } else if (ot.prioridad == 'ALTA') {
        color = BitmapDescriptor.hueOrange;
      }

      return Marker(
        markerId: MarkerId('OT_${ot.id}'),
        position: LatLng(ot.latitud, ot.longitud),
        icon: BitmapDescriptor.defaultMarkerWithHue(color),
        infoWindow: InfoWindow(
          title: 'OT #${ot.id} - ${ot.tipoAlerta}',
          snippet: 'Presiona para ver reporte de campo',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExecutionScreen(ot: ot, syncService: widget.syncService),
              ),
            );
          },
        ),
      );
    }).toSet();
  }

  Color _getPriorityColor(String prioridad) {
    switch (prioridad) {
      case 'CRITICA':
        return const Color(0xFFF87171);
      case 'ALTA':
        return const Color(0xFFFBBF24);
      case 'MEDIA':
      default:
        return const Color(0xFF34D399);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalOts = _ots.length;
    final criticalOts = _ots.where((ot) => ot.prioridad == 'CRITICA').length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('HYDRA', style: TextStyle(fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('EMAPAT S.A. - Mapa y Lista de OTs', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF94A3B8))),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_showMap ? Icons.view_list_rounded : Icons.map_rounded, color: const Color(0xFF38BDF8)),
            onPressed: () => setState(() => _showMap = !_showMap),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Panel de Resumen
            Row(
              children: [
                Expanded(child: _buildSummaryCard('Total Activas', '$totalOts', const Color(0xFF38BDF8))),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('Críticas', '$criticalOts', const Color(0xFFF87171))),
              ],
            ),
            const SizedBox(height: 16),
            
            // Selector / Vista principal
            Expanded(
              child: _showMap ? _buildMapWidget() : _buildListWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListWidget() {
    return ListView.builder(
      itemCount: _ots.length,
      itemBuilder: (context, index) {
        final ot = _ots[index];
        final priColor = _getPriorityColor(ot.prioridad);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
          color: const Color(0xFF1E293B),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExecutionScreen(ot: ot, syncService: widget.syncService),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(color: Color(0xFF0F172A), shape: BoxShape.circle),
                    child: Center(
                      child: Text('S-${ot.sectorId}', style: const TextStyle(fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('OT-${ot.id} / ${ot.tipoAlerta}', style: const TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('Punto: ${ot.pointId}', style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF94A3B8))),
                        const SizedBox(height: 2),
                        Text('Tubería Teórica: ${ot.materialTeorico} ${ot.diametroTeorico}', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white24)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: priColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: priColor.withOpacity(0.3)),
                        ),
                        child: Text(ot.prioridad, style: TextStyle(color: priColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.navigation_outlined, size: 12, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text('${ot.distanciaMetros > 1000 ? '${(ot.distanciaMetros / 1000).toStringAsFixed(1)} km' : '${ot.distanciaMetros.toInt()} m'}',
                              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapWidget() {
    LatLng initialCenter = const LatLng(-12.5934, -69.1923); // Centro de prueba JASS El Triunfo
    if (_currentPosition != null) {
      initialCenter = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: initialCenter, zoom: 14),
              onMapCreated: (controller) => _mapController = controller,
              markers: _buildMarkers(),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            if (_loadingLocation)
              const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8))),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
```
