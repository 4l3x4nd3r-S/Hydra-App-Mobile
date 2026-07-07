# INSTRUCCIONES - DESARROLLADOR A: PANTALLA DE EJECUCIÓN Y MULTIMEDIA (ot_execution)

Esta es una especificación técnica de desarrollo para que un asistente de IA o programador implemente la pantalla de ejecución, formulario de reporte y captura de firmas/cámara en la aplicación **HYDRA**.

---

## 🎯 Objetivo de Tarea
Desarrollar la interfaz interactiva `lib/features/ot_execution/presentation/execution_screen.dart` que permite al técnico documentar la reparación de la tubería, tomar fotografías obligatorias y firmar digitalmente.

---

## 📂 Archivos a Crear / Modificar
*   `lib/features/ot_execution/presentation/execution_screen.dart` (UI del Formulario y Cámara)
*   `pubspec.yaml` (Asegurar dependencias de `image_picker` o `camera`, y `signature`)

---

## 📋 Directrices de Programación para la UI (Material 3)

### 1. Cabecera de la Pantalla (AppBar)
*   Título: "Ejecución de OT #<ID>" (ej: "Ejecución de OT #104").
*   Fondo: Slate-900 (`#0F172A`).
*   Acción: Botón para volver atrás.

### 2. Sección de Datos Teóricos (Catastro CAD)
*   Presenta una tarjeta inactiva (`Card` de color Slate-800: `#1E293B`) que muestra la información teórica para que el técnico sepa qué esperar:
    *   Sensor origen: `TRIUNFO_P-02`
    *   Sector: `Sector 12 - El Triunfo`
    *   Tubería en planos: `Asbesto Cemento 4"`

### 3. Sección del Formulario Técnico (Entradas)
*   **Dropdown: Hallazgo Real en Red**
    *   Opciones: `ROTURA`, `FUGA`, `FALSA ALARMA`.
*   **Dropdown: Material de la Tubería Real**
    *   Opciones: `ASBESTO CEMENTO`, `PVC`, `HDPE`, `HIERRO FUNDIDO`.
*   **Dropdown: Diámetro de la Tubería Real**
    *   Opciones: `2"`, `3"`, `4"`, `6"`, `8"`, `10"`.
*   **Lista de Materiales Utilizados (Checklist / Contador):**
    *   Abrazaderas de reparación (Contador de cantidad).
    *   Uniones de reparación (Contador de cantidad).
    *   Pegamento / Sellador (Checkbox).

### 4. Sección Multimedia (Control de Fraudes - SUNASS)
*   Dos botones horizontales elegantes: **"Foto del Antes"** y **"Foto del Después"**.
*   **Restricción Crítica:** Al presionar los botones, el sistema debe abrir la cámara nativa utilizando la fuente de cámara en vivo (`ImageSource.camera`). **Prohíbe por completo el uso de la galería del teléfono** para evitar reportes falsificados.
*   Una vez tomada la foto, muestra una miniatura redonda de previsualización en la pantalla con la hora e indicador GPS.

### 5. Botón de Validación de Presión (Inspección Hidráulica)
*   Un botón destacado llamado **"Validar Presión de Red"**:
    *   Al presionarlo, muestra un indicador de carga (`CircularProgressIndicator`).
    *   Simula una petición HTTP (o conéctala al `verify-pressure` endpoint).
    *   Si devuelve éxito, muestra un banner verde flotante: *"Presión normalizada en el sector. Aprobado para cierre."*
    *   Si falla, muestra una advertencia en amarillo: *"Presión baja detectada. Si desea cerrar la orden, deberá justificarlo en el siguiente campo."* y despliega una caja de texto de justificación obligatoria.

### 6. Lienzo de Firma Digital
*   Añade un widget de dibujo táctil (`Signature` canvas) con fondo negro y trazo en color cian (`#38BDF8`) para que el técnico firme la orden en la pantalla del celular.

---

## 🎨 Código Base de Plantilla para Desarrollador A:

```dart
import 'package:flutter/material.dart';

class ExecutionScreen extends StatefulWidget {
  const ExecutionScreen({super.key});

  @override
  State<ExecutionScreen> createState() => _ExecutionScreenState();
}

class _ExecutionScreenState extends State<ExecutionScreen> {
  String? _hallazgoReal;
  String? _materialReal;
  String? _diametroReal;
  int _abrazaderas = 0;
  bool _validandoPresion = false;
  bool _presionValidada = false;
  final TextEditingController _justificacionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text(
          'Ejecutar Orden #104',
          style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de Datos Teóricos (Catastro)
            _buildTheoreticalCard(),
            const SizedBox(height: 20),

            // Formulario
            const Text('Reporte Técnico de Reparación', style: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            
            _buildDropdown(
              label: 'Hallazgo Real',
              value: _hallazgoReal,
              items: ['ROTURA', 'FUGA', 'FALSA ALARMA'],
              onChanged: (val) => setState(() => _hallazgoReal = val),
            ),
            _buildDropdown(
              label: 'Material de Tubería Real',
              value: _materialReal,
              items: ['ASBESTO CEMENTO', 'PVC', 'HDPE', 'HIERRO FUNDIDO'],
              onChanged: (val) => setState(() => _materialReal = val),
            ),
            _buildDropdown(
              label: 'Diámetro Real',
              value: _diametroReal,
              items: ['2"', '3"', '4"', '6"', '8"'],
              onChanged: (val) => setState(() => _diametroReal = val),
            ),

            const SizedBox(height: 20),

            // Fotos
            const Text('Evidencia Fotográfica (Obligatoria)', style: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E293B), padding: const EdgeInsets.symmetric(vertical: 12)),
                    icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFF38BDF8)),
                    label: const Text('Foto Antes', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      // Implementar captura de foto en vivo
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E293B), padding: const EdgeInsets.symmetric(vertical: 12)),
                    icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFF38BDF8)),
                    label: const Text('Foto Después', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      // Implementar captura de foto en vivo
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Botón de Validación de Presión
            _buildPressureVerificationSection(),

            const SizedBox(height: 24),

            // Panel de Firma
            const Text('Firma del Técnico Responsable', style: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: const Center(
                child: Text('Lienzo para Firma Digital (Cuadrilla)', style: TextStyle(color: Colors.white24, fontSize: 12)),
              ),
            ),

            const SizedBox(height: 24),

            // Botón de Envío
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Guardar reporte (Llamar a SyncService)
                },
                child: const Text(
                  'FINALIZAR REPARACIÓN',
                  style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTheoreticalCard() {
    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('DATOS TEÓRICOS DE CATASTRO', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
            SizedBox(height: 8),
            Text('Sensor Asignado: DL-02 / P-02 El Triunfo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 4),
            Text('Tubería en Planos: Asbesto Cemento 4 pulgadas', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({required String label, required String? value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
          filled: true,
          fillColor: const Color(0xFF1E293B),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        value: value,
        dropdownColor: const Color(0xFF1E293B),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPressureVerificationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              const Text('Validación Hidráulica de Red', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              if (_validandoPresion)
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF38BDF8)))
              else if (_presionValidada)
                const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399))
              else
                const Icon(Icons.info_outline_rounded, color: Color(0xFFFBBF24)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
              onPressed: () {
                setState(() => _validandoPresion = true);
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    _validandoPresion = false;
                    _presionValidada = true;
                  });
                });
              },
              child: const Text('Comprobar Presión del Sensor', style: TextStyle(color: Color(0xFF38BDF8))),
            ),
          ),
        ],
      ),
    );
  }
}
```
