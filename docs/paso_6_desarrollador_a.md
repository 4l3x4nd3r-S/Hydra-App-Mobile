# INSTRUCCIONES - DESARROLLADOR A: PING AL SENSOR Y VERIFICACIÓN HIDRÁULICA REAL (paso_6)

Esta especificación técnica detalla cómo conectar la validación de presión de red con el endpoint HTTP de FastAPI real y gestionar los estados hidráulicos dinámicos en la pantalla de ejecución.

---

## 🎯 Objetivo de Tarea
Reemplazar la simulación de tiempo de espera (`Future.delayed`) del botón de "Validar Presión de Red" en `ExecutionScreen` con una consulta HTTP real usando el cliente `dio` contra el endpoint `/api/v1/ots/{ot_id}/verify-pressure` (especificado en `ApiEndpoints.verifyPressure`). Dependiendo de la respuesta, habilitar dinámicamente el cierre normal o exigir de forma obligatoria la justificación técnica por baja presión persistente.

---

## 📂 Archivos a Crear / Modificar
*   `lib/features/ot_execution/presentation/execution_screen.dart` (Modificar botón de validación de presión e integración HTTP)

---

## 📋 Directrices de Programación y Flujo de Trabajo

### 1. Consumo del Endpoint de Presión Real
*   En `ExecutionScreen`, localiza la función `_validarPresion()`.
*   Realiza una llamada HTTP `GET` usando `DioClient().dio` (para heredar el interceptor JWT configurado en Paso 4) hacia la ruta `/api/v1/ots/{ot_id}/verify-pressure`.
*   **Gestión de Estados en la UI:**
    1.  **Carga (`_validandoPresion = true`)**: Muestra un spinner azul circular mientras dura la petición.
    2.  **Presión Normalizada (`presion_recuperada = true`)**:
        *   Muestra la tarjeta de éxito de color verde: *"Presión normalizada en el sector. Aprobado para cierre."*
        *   Guarda la lectura en una variable local `double? _presionMca` (obtenida de `response.data["presion_actual_mca"]`).
        *   Oculta y vacía la caja de justificación.
    3.  **Presión Insuficiente (`presion_recuperada = false`)**:
        *   Muestra la tarjeta de advertencia en color amarillo: *"Presión baja detectada. Si desea cerrar la orden, deberá justificarlo en el siguiente campo."*
        *   Despliega inmediatamente el campo de justificación técnica y haz que sea obligatorio completarlo para poder finalizar.
    4.  **Error de Conexión o Modo Offline**:
        *   Si el celular no tiene señal (comprobando con `ConnectivityResult.none`) o el backend no responde, captura la excepción y muestra un aviso amarillo de degradación: *"Modo Offline: No es posible contactar al sensor en tiempo real. Ingrese una justificación técnica para el cierre forzado."*
        *   Haz que el campo de justificación sea obligatorio para permitir la finalización de la orden en modo offline-first.

### 2. Modificación de Métodos e Interfaz
*   Asegúrate de inyectar y almacenar la lectura real (`_presionMca`) al guardar el reporte offline mediante `saveReportOffline` (añadiéndolo como un dato extra o pasándolo adecuadamente).

---

## 🎨 Código de Integración Sugerido para `_validarPresion()`

Reemplaza e integra este método dentro del State en `execution_screen.dart`:

```dart
  double? _presionMca;

  Future<void> _validarPresion() async {
    setState(() {
      _validandoPresion = true;
      _presionOk = null;
    });

    final otId = widget.ot?.id ?? 0;

    try {
      final dio = DioClient().dio;
      final response = await dio.get('/ots/$otId/verify-pressure');

      if (response.statusCode == 200 && response.data != null) {
        final bool recuperada = response.data['presion_recuperada'] ?? false;
        final double presion = (response.data['presion_actual_mca'] as num).toDouble();

        setState(() {
          _presionOk = recuperada;
          _presionMca = presion;
        });
      }
    } on DioException catch (e) {
      // Degradación graciosa si está Offline o falla el Servidor
      setState(() {
        _presionOk = false; // Requiere justificación
        _presionMca = 0.0;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.type == DioExceptionType.connectionTimeout || e.response == null
                ? 'Conexión débil o sin red. Se requerirá justificación para cierre offline.'
                : 'Error al contactar sensor: ${e.message}'
          ),
          backgroundColor: const Color(0xFFFBBF24),
        ),
      );
    } finally {
      setState(() => _validandoPresion = false);
    }
  }
```

### Actualización del Envío
En tu botón de `FINALIZAR REPARACIÓN` (dentro de `_buildSubmitButton()`), asegúrate de pasar la presión guardada:
```dart
  // En saveReportOffline puedes mandar _presionMca en los metadatos o materiales
  // asegurando que el backend lo reciba tras la sincronización.
```
