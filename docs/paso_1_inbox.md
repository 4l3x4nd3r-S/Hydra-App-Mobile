# INSTRUCCIONES DE DESARROLLO - PASO 1: BANDEJA DE OTS (ot_inbox)

Este documento contiene las especificaciones técnicas exactas y las plantillas de código para que un asistente de IA (como Claude) programe de forma automatizada la **Bandeja de Entrada de Órdenes de Trabajo (Buzón de OTs)** de la aplicación **HYDRA**.

---

## 🎯 Objetivo de Programación
Desarrollar la pantalla principal de la aplicación (`lib/features/ot_inbox/presentation/inbox_screen.dart`) y su modelo de datos de prueba (`lib/features/ot_inbox/domain/ot_model.dart`), mostrando las tarjetas de OTs clasificadas por prioridad (Crítica, Alta, Media), contadores dinámicos y navegación fluida.

---

## 📂 Archivos a Crear / Modificar

### Archivo 1: Modelo de Datos `lib/features/ot_inbox/domain/ot_model.dart`
Crea este archivo para definir la estructura de datos que representa una Orden de Trabajo (OT) con georreferenciación.

```dart
// lib/features/ot_inbox/domain/ot_model.dart
class OtModel {
  final int id;
  final String sensorId;
  final String pointId;
  final String sectorNombre;
  final int sectorId;
  final String prioridad; // 'CRITICA' | 'ALTA' | 'MEDIA'
  final String tipoAlerta; // 'ROTURA' | 'FUGA'
  final String diametroTeorico; // '2"', '4"', '6"', etc.
  final String materialTeorico; // 'ASBESTO CEMENTO' / 'PVC'
  final double latitud;
  final double longitud;
  final double distanciaMetros; // Distancia calculada al GPS actual
  final DateTime fechaCreacion;

  OtModel({
    required this.id,
    required this.sensorId,
    required this.pointId,
    required this.sectorNombre,
    required this.sectorId,
    required this.prioridad,
    required this.tipoAlerta,
    required this.diametroTeorico,
    required this.materialTeorico,
    required this.latitud,
    required this.longitud,
    required this.distanciaMetros,
    required this.fechaCreacion,
  });
}
```

---

### Archivo 2: Pantalla de la UI `lib/features/ot_inbox/presentation/inbox_screen.dart`
Reemplaza el esqueleto existente en este archivo con una interfaz móvil premium bajo diseño Material 3 y esquema de colores corporativo de HYDRA (Slate-Dark).

#### Directrices Estéticas y Funcionales para Claude:
1.  **Esquema de Colores (Corporativo):**
    *   Fondo de pantalla: `#0F172A` (Slate-900).
    *   Fondo de Tarjetas: `#1E293B` (Slate-800).
    *   Color Primario / Resaltados: `#38BDF8` (Sky Blue).
    *   Prioridad Crítica: `#F87171` (Rojo pastel / Soft Red).
    *   Prioridad Alta: `#FBBF24` (Ámbar / Soft Orange).
    *   Prioridad Media: `#34D399` (Esmeralda / Soft Green).
2.  **Estructura de la Interfaz:**
    *   **AppBar Premium:** Muestra el título "HYDRA" en fuente Outfit negrita, un subtítulo pequeño "EMAPAT S.A. - JASS El Triunfo", y un botón circular de actualización a la derecha.
    *   **Panel de Resumen (Counters):** Una sección en la parte superior que muestra dos tarjetas horizontales elegantes:
        *   Tarjeta 1: "Total Activas" (Muestra el número total de OTs asignadas).
        *   Tarjeta 2: "Críticas" (Muestra el contador de OTs con prioridad 'CRITICA' resaltado en rojo suave).
    *   **Lista de Tarjetas de OTs:** Un `ListView.builder` que renderiza las OTs simuladas.
        *   Cada tarjeta debe tener esquinas redondeadas (`BorderRadius.circular(16)`) y un borde sutil para destacar sobre el fondo.
        *   *Parte Izquierda:* Un círculo indicador con fondo `#38BDF8` y texto blanco mostrando el número del sector hidráulico (ej: "S-12").
        *   *Parte Central:* Texto que destaca el ID de la OT (ej: "OT-104"), el ID del Punto de presión (ej: "P-02 Triunfo") y el diámetro de tubería en letra muted (ej: "Red: PVC 4 pulgadas").
        *   *Parte Derecha:* Un chip de prioridad redondeado con su respectivo color pastel y la distancia en metros desde el GPS (ej: "180 m").
    *   **Navegación Interactiva:** Al presionar cualquier tarjeta, debe realizar una transición animada hacia la pantalla de ejecución `ExecutionScreen` enviándole los datos de la OT seleccionada.

#### Código Base a Implementar:

```dart
import 'package:flutter/material.dart';
import '../domain/ot_model.dart';
import '../../ot_execution/presentation/execution_screen.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  // Lista de datos de prueba simulados (Mock Data)
  final List<OtModel> mockOts = [
    OtModel(
      id: 104,
      sensorId: "DL-02",
      pointId: "TRIUNFO_P-02",
      sectorNombre: "JASS El Triunfo",
      sectorId: 12,
      prioridad: "CRITICA",
      tipoAlerta: "ROTURA",
      diametroTeorico: "4 pulgadas",
      materialTeorico: "ASBESTO CEMENTO",
      latitud: -12.5934,
      longitud: -69.1923,
      distanciaMetros: 120,
      fechaCreacion: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    OtModel(
      id: 105,
      sensorId: "DL-08",
      pointId: "P-38",
      sectorNombre: "La Joya",
      sectorId: 9,
      prioridad: "ALTA",
      tipoAlerta: "FUGA",
      diametroTeorico: "3 pulgadas",
      materialTeorico: "PVC",
      latitud: -12.5845,
      longitud: -69.1842,
      distanciaMetros: 450,
      fechaCreacion: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    OtModel(
      id: 106,
      sensorId: "DL-01",
      pointId: "P-04",
      sectorNombre: "Centro Histórico",
      sectorId: 1,
      prioridad: "MEDIA",
      tipoAlerta: "FUGA",
      diametroTeorico: "2 pulgadas",
      materialTeorico: "PVC",
      latitud: -12.5912,
      longitud: -69.1990,
      distanciaMetros: 820,
      fechaCreacion: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Color _getPriorityColor(String prioridad) {
    switch (prioridad) {
      case 'CRITICA':
        return const Color(0xFFF87171); // Soft Red
      case 'ALTA':
        return const Color(0xFFFBBF24); // Soft Orange
      case 'MEDIA':
      default:
        return const Color(0xFF34D399); // Soft Green
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalOts = mockOts.length;
    final criticalOts = mockOts.where((ot) => ot.prioridad == 'CRITICA').length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'HYDRA',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'EMAPAT S.A. - JASS El Triunfo',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF38BDF8)),
            onPressed: () {
              // Simular recarga de datos
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sincronizando órdenes de trabajo con el servidor...'),
                  backgroundColor: Color(0xFF1E293B),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Panel de Resumen (Contadores)
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Total Activas',
                    value: '$totalOts',
                    color: const Color(0xFF38BDF8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Críticas',
                    value: '$criticalOts',
                    color: const Color(0xFFF87171),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Título de la Sección
            const Text(
              'Órdenes en tu Sector',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            
            // Listado de OTs
            Expanded(
              child: ListView.builder(
                itemCount: mockOts.length,
                itemBuilder: (context, index) {
                  final ot = mockOts[index];
                  final priColor = _getPriorityColor(ot.prioridad);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Colors.white10),
                    ),
                    color: const Color(0xFF1E293B),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // Navegar a la pantalla de Ejecución con la OT seleccionada
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExecutionScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Círculo del Sector Hidráulico
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0F172A),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  'S-${ot.sectorId}',
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF38BDF8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Información Central
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'OT-${ot.id} / ${ot.tipoAlerta}',
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Punto: ${ot.pointId}',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Tubería Teórica: ${ot.materialTeorico} ${ot.diametroTeorico}',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      color: Colors.white24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Info Prioridad y Distancia
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, py: 4),
                                  decoration: BoxDecoration(
                                    color: priColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: priColor.withOpacity(0.3), width: 1),
                                  ),
                                  child: Text(
                                    ot.prioridad,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: priColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.navigation_outlined, size: 12, color: Color(0xFF94A3B8)),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${ot.distanciaMetros} m',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
```
