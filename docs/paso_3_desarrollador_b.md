# INSTRUCCIONES - DESARROLLADOR B: INFRAESTRUCTURA OFFLINE-FIRST Y SQLite (core/database)

Esta es una especificación técnica de desarrollo para que un asistente de IA o programador implemente el almacenamiento local y la sincronización automática en segundo plano en la aplicación **HYDRA**.

---

## 🎯 Objetivo de Tarea
Desarrollar la infraestructura de datos SQLite local (`lib/core/database/database_helper.dart`) y conectar el servicio de sincronización asíncrona (`lib/core/database/sync_service.dart`) con el estado de la red del teléfono (`lib/core/utils/connectivity_service.dart`), garantizando la resiliencia en zonas sin cobertura de telefonía.

---

## 📂 Archivos a Crear / Modificar
*   `lib/core/database/database_helper.dart` (Inicialización de SQLite)
*   `lib/core/database/sync_service.dart` (Lógica de inserción y sincronización asíncrona)
*   `lib/core/utils/connectivity_service.dart` (Monitoreo de red móvil)
*   `lib/main.dart` (Inicialización de base de datos e inyección de escuchadores al arranque)

---

## 📋 Directrices de Programación para la Infraestructura

### 1. Inicialización de SQLite (`database_helper.dart`)
*   Define el nombre del archivo local de base de datos como `hydra_offline.db`.
*   Crea una tabla llamada `offline_sync_queue` con los campos necesarios para almacenar toda la metadata de reparación (ID, hallazgo real, material real, diámetro real, materiales usados en formato de texto JSON, rutas físicas locales de las fotos del antes/después, latitud/longitud de la reparación, estado del reporte y fecha de creación).

### 2. Guardado Local (`saveReportOffline` en `sync_service.dart`)
*   Cuando la cuadrilla completa su formulario (diseñado por Desarrollador A) y no tiene conexión, se llama a esta función.
*   Los datos se serializan (por ejemplo, el mapa de materiales usados se convierte en un String JSON usando `jsonEncode`) y se insertan de forma asíncrona en la base de datos SQLite local con un estado inicial `PENDING_SYNC`.

### 3. Monitor de Red (`connectivity_service.dart`)
*   Expón un Stream asíncrono (`onConnectivityChanged`) utilizando el plugin `connectivity_plus` para monitorear si el teléfono celular tiene WiFi o datos móviles.
*   Expón un Future booleano (`isConnected`) que permita comprobar el estado instantáneo de la red al momento de pulsar botones.

### 4. Sincronización en Segundo Plano (`triggerSyncProcess` en `sync_service.dart`)
*   Se activa automáticamente cuando el monitor de red detecta el cambio de estado de offline a online.
*   **Proceso secuencial:**
    1.  Consulta a SQLite todos los registros en `offline_sync_queue` con estado `PENDING_SYNC`.
    2.  Si la cola está vacía, finaliza silenciosamente.
    3.  Para cada reporte en la cola, prepara un objeto `FormData` de la librería `dio`.
    4.  Carga las imágenes locales (utilizando `MultipartFile.fromFile` con la ruta guardada).
    5.  Realiza la petición `POST` al endpoint `/api/v1/ots/<ot_id>/close` de FastAPI.
    6.  Si el backend responde con un código `200 OK` (Cierre exitoso), elimina de forma definitiva esa orden de la tabla SQLite local para evitar duplicaciones.
    7.  Si la petición falla (ej: micro-cortes de señal), mantiene el registro en SQLite para el siguiente intento.

### 5. Configuración al Arranque (`lib/main.dart`)
*   En el método `main()` de la aplicación, antes de `runApp()`, se debe inicializar de forma asíncrona la base de datos (`await DatabaseHelper.database`) e inyectar el método de escucha activa (`SyncService.listenToNetworkChanges()`) para que el hilo de sincronización opere en segundo plano de manera autónoma desde el momento en que se enciende la app.

---

## 🎨 Código Base de Plantilla para Desarrollador B:

```dart
// lib/core/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hydra_offline.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  static Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE offline_sync_queue (
        ot_id INTEGER PRIMARY KEY,
        tipo_hallazgo_real TEXT NOT NULL,
        material_real TEXT NOT NULL,
        diametro_real TEXT NOT NULL,
        materiales_usados TEXT NOT NULL,
        photo_before_path TEXT NOT NULL,
        photo_after_path TEXT NOT NULL,
        lat_reparacion REAL NOT NULL,
        lon_reparacion REAL NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    print("[SQLite] Base de datos local inicializada con cola de sincronización.");
  }
}
```
