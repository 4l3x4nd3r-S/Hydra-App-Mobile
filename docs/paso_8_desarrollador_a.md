# INSTRUCCIONES - DESARROLLADOR A: AUDITORÍA EXIF, CONTROL ANTI-FRAUDE Y METADATOS GPS (paso_8)

Esta especificación técnica detalla cómo implementar el control de auditoría de metadatos EXIF sobre las fotografías tomadas por la cámara nativa en la pantalla de ejecución, cumpliendo con la normativa anti-fraude SUNASS.

---

## 🎯 Objetivo de Tarea
Asegurar la veracidad de los reportes técnicos en `ExecutionScreen` mediante el análisis de metadatos EXIF en las imágenes tomadas. Al capturar la foto de la tubería, se debe extraer sus coordenadas GPS embebidas y contrastarlas con la ubicación en vivo del teléfono celular. Si la distancia entre la foto y la ubicación real supera los 50 metros, se debe lanzar una alerta visual de seguridad y auditar el fraude.

---

## 📂 Archivos a Crear / Modificar
*   `lib/features/ot_execution/presentation/execution_screen.dart` (Integrar validación de metadatos EXIF al capturar fotos)

---

## 📋 Directrices de Programación y Flujo de Trabajo

### 1. Extracción de Coordenadas de la Imagen (Paquete `exif`)
*   Al capturar una fotografía exitosamente con `_tomarFoto()`, lee los metadatos binary EXIF del archivo de imagen mediante la librería `exif`:
    ```dart
    final bytes = await File(photo.path).readAsBytes();
    final tags = await readExifFromBytes(bytes);
    ```
*   Extrae las etiquetas `GPS GPSLatitude`, `GPS GPSLatitudeRef`, `GPS GPSLongitude`, y `GPS GPSLongitudeRef` del mapa de tags.
*   Crea una función auxiliar para convertir el formato EXIF (Grados, Minutos, Segundos en formato de fracciones) a grados decimales estándar:
    ```dart
    double _exifToDecimal(List<dynamic> values, String ref) { ... }
    ```

### 2. Validación Cruzada de Posición (Anti-Spoofing / Anti-Fraude)
*   Obtén la ubicación GPS actual del dispositivo mediante `Geolocator.getCurrentPosition()`.
*   Calcula la distancia física entre la ubicación en vivo del celular y el punto geográfico embebido en el EXIF de la foto tomada usando `Geolocator.distanceBetween()`.
*   **Umbral de Tolerancia**: Si la distancia calculada es **superior a 50 metros**, se detecta un reporte fraudulento (p. ej., se tomó una foto de otra tubería a la distancia o se intentó evadir la inspección):
    *   Muestra un cuadro de diálogo rojo de advertencia: *"Alerta de Seguridad: La posición de la fotografía no coincide con tu ubicación GPS actual. Este reporte será marcado para auditoría."*
    *   Registra una bandera `fraude_exif: 1` en el payload de SQLite de la orden de trabajo para que el backend web la resalte en color de alerta.

---

## 🎨 Código Base de Apoyo y Conversión de EXIF a Grados

Integra esta lógica auxiliar dentro de tu State en `execution_screen.dart`:

```dart
import 'package:exif/exif.dart';

  // Convierte las fracciones de grados de EXIF a decimales
  double _convertRatioToDecimal(List<dynamic> values, String ref) {
    if (values.length < 3) return 0.0;
    
    // Extraer grados, minutos y segundos
    double degrees = _ratioToDouble(values[0]);
    double minutes = _ratioToDouble(values[1]);
    double seconds = _ratioToDouble(values[2]);

    double decimal = degrees + (minutes / 60.0) + (seconds / 3600.0);
    if (ref == 'S' || ref == 'W') {
      decimal = -decimal;
    }
    return decimal;
  }

  double _ratioToDouble(dynamic ratio) {
    if (ratio is Ratio) {
      return ratio.numerator / ratio.denominator;
    }
    return double.tryParse(ratio.toString()) ?? 0.0;
  }

  // Método de validación de metadatos de la foto tomada
  Future<bool> _validarAuditoriaExif(XFile photo) async {
    try {
      final bytes = await File(photo.path).readAsBytes();
      final data = await readExifFromBytes(bytes);

      if (data.isEmpty || !data.containsKey('GPS GPSLatitude')) {
        print("La imagen no contiene metadatos GPS o EXIF.");
        return true; // Permitir por defecto en dispositivos que no soporten EXIF en emulación
      }

      final latTag = data['GPS GPSLatitude']!.values.toList();
      final latRef = data['GPS GPSLatitudeRef']!.toString();
      final lonTag = data['GPS GPSLongitude']!.values.toList();
      final lonRef = data['GPS GPSLongitudeRef']!.toString();

      final double fotoLat = _convertRatioToDecimal(latTag, latRef);
      final double fotoLon = _convertRatioToDecimal(lonTag, lonRef);

      // Obtener ubicación GPS actual
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Calcular diferencia de metros
      final double metrosDiferencia = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        fotoLat,
        fotoLon,
      );

      if (metrosDiferencia > 50.0) {
        // Alerta de posible fraude
        return false;
      }
    } catch (e) {
      print("Error en auditoría EXIF: $e");
    }
    return true;
  }
```

*Invoca `_validarAuditoriaExif(photo)` inmediatamente después de capturar la imagen. Si devuelve `false`, notifica al usuario con un Banner o Dialogo y activa el indicador de auditoría para la orden de trabajo.*
