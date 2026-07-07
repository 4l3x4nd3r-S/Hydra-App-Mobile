# ESPECIFICACIÓN: REDISEÑO DE VALIDACIÓN MANOMÉTRICA CIEGA (Offline-First)

Este documento detalla la re-calibración del flujo de verificación hidráulica de **HYDRA**. Se descarta el "ping en tiempo real" por HTTP a sensores inteligentes (inviables en la infraestructura actual) y se adopta un **flujo híbrido offline-first con ingreso manual por manómetro analógico y contraste blindado contra la línea base histórica**.

---

## 🎯 Objetivo del Rediseño
Implementar una validación de presión inquebrantable que no requiera conexión a internet ni sensores activos en la calle. El técnico ingresará manualmente la lectura tomada de su manómetro físico de aguja, y la aplicación la contrastará silenciosamente contra la presión de referencia guardada en los metadatos de la orden de trabajo (`presionReferencial`). Si el valor ingresado es menor al umbral tolerado, se forzará la justificación técnica obligatoria.

---

## 📂 Archivos a Modificar
Para migrar el flujo existente hacia este nuevo modelo híbrido, debemos modificar exactamente **3 archivos** del proyecto frontend:
1.  `lib/features/ot_inbox/domain/ot_model.dart` (Modificar modelo de datos)
2.  `lib/features/ot_inbox/presentation/inbox_screen.dart` (Modificar mock data y listado)
3.  `lib/features/ot_execution/presentation/execution_screen.dart` (Modificar interfaz del formulario y lógica de validación)

---

## 🛠️ Detalle de Modificaciones en el Código

### Paso 1: Modificar `lib/features/ot_inbox/domain/ot_model.dart`
Añadimos la propiedad `presionReferencial` a la clase `OtModel` para almacenar la presión histórica óptima (en MCA) de cada sector hidráulico:

```diff
class OtModel {
  final int id;
  final String sensorId;
  final String pointId;
  final String sectorNombre;
  final int sectorId;
  final String prioridad;
  final String tipoAlerta;
  final String diametroTeorico;
  final String materialTeorico;
  final double latitud;
  final double longitud;
  final double distanciaMetros;
+ final double presionReferencial; // Línea base histórica en MCA (ej: 16.5)
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
+   required this.presionReferencial,
    required this.fechaCreacion,
  });
}
```

---

### Paso 2: Modificar `lib/features/ot_inbox/presentation/inbox_screen.dart`
Actualizamos el listado de OTs de prueba (`_baseMockOts`) en el estado para inyectar las diferentes líneas bases históricas de presión según la elevación y topografía de cada sector:

```diff
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
+     presionReferencial: 16.5, // 16.5 MCA óptimo para El Triunfo
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
+     presionReferencial: 13.8, // 13.8 MCA óptimo para La Joya
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
+     presionReferencial: 18.2, // 18.2 MCA óptimo para Centro Histórico
      fechaCreacion: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
```
*(También se debe actualizar el constructor de `OtModel` dentro del bucle de mapeo de geolocalización `_calculateDistancesAndSort` para propagar el campo `presionReferencial`).*

---

### Paso 3: Modificar `lib/features/ot_execution/presentation/execution_screen.dart`
Este es el cambio principal. Reemplazamos la llamada a la API por una caja de entrada de texto numérica y un botón de contraste local:

#### 1. Definición de variables y controladores:
```dart
  // En el State de _ExecutionScreenState:
  final TextEditingController _presionMedidaController = TextEditingController();
  
  @override
  void dispose() {
    _presionMedidaController.dispose();
    _justificacionController.dispose();
    _signatureController.dispose();
    super.dispose();
  }
```

#### 2. Reemplazo del método `_validarPresion()` (Lógica a Ciegas):
Eliminamos `DioClient` y la llamada HTTP. Hacemos que contraste el valor de la caja de texto directamente contra `widget.ot.presionReferencial` tolerando un margen aceptable de caída (ej. hasta 1.5 MCA por debajo de la línea base):

```dart
  Future<void> _validarPresion() async {
    final String input = _presionMedidaController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe ingresar la lectura del manómetro físico primero'),
          backgroundColor: Color(0xFFF87171),
        ),
      );
      return;
    }

    final double? presionIngresada = double.tryParse(input);
    if (presionIngresada == null || presionIngresada < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingrese un valor numérico de presión válido'),
          backgroundColor: Color(0xFFF87171),
        ),
      );
      return;
    }

    setState(() => _validandoPresion = true);
    await Future.delayed(const Duration(milliseconds: 600)); // Efecto de cálculo

    final double baseHistorica = widget.ot?.presionReferencial ?? 15.0;
    
    // Si la presión es mayor o igual a la línea base histórica - 1.5 MCA, se considera ACEPTABLE
    final bool exito = presionIngresada >= (baseHistorica - 1.5) && presionIngresada >= 12.0;

    setState(() {
      _validandoPresion = false;
      _presionOk = exito;
      _presionMca = presionIngresada;
      if (exito) {
        _justificacionController.clear(); // Ocultar y limpiar justificación
      }
    });
  }
```

#### 3. Rediseño del Widget en `_buildPressureVerificationSection()`:
Quitamos el botón simple y añadimos el campo de texto numérico para que el técnico ingrese su lectura real antes de validar:

```dart
  Widget _buildPressureVerificationSection() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              const Text('Validación de Presión Manométrica', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              if (_validandoPresion)
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF38BDF8)))
              else if (_presionOk == true)
                const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399))
              else if (_presionOk == false)
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFFBBF24))
              else
                const Icon(Icons.info_outline_rounded, color: Color(0xFF94A3B8)),
            ],
          ),
          const SizedBox(height: 12),
          
          // Campo para que el técnico ingrese la presión medida
          const Text('Lectura física del manómetro (MCA):', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _presionMedidaController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Ej: 16.2',
              hintStyle: const TextStyle(color: Colors.white24),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white10)),
              suffixText: 'MCA',
              suffixStyle: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
            ),
          ),
          
          if (_presionOk == true) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF34D399).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF34D399).withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Color(0xFF34D399), size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Presión dentro del rango esperado para este sector. Cierre autorizado.', style: TextStyle(color: Color(0xFF34D399), fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
          
          if (_presionOk == false) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFFBBF24), size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Presión inferior a la línea base esperada. Justificación técnica de purga o baja carga obligatoria.', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _justificacionController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Justificación técnica requerida...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white10)),
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _validandoPresion ? null : _validarPresion,
              child: const Text('Validar Lectura de Manómetro', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
```

---

## 📈 Resumen del Flujo Anti-Fraude Resultante
1. El técnico abre la pantalla y ve una caja de texto limpia esperando la lectura física del manómetro analógico.
2. El técnico **no conoce** cuál es el valor exacto de `presionReferencial` de la OT (oculto en los metadatos en segundo plano).
3. Si el técnico inventa un número al azar fuera de rango, la app le obliga a ingresar una justificación técnica detallada que será auditada por EMAPAT.
4. Si ingresa el valor de presión real medida de forma honesta, y coincide con la línea base del catastro, la app aprueba el cierre de manera ágil e inmediata.
