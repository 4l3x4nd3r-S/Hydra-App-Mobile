# INSTRUCCIONES - DESARROLLADOR B: EXPORTACIÓN DE FIRMA Y ENVÍO MULTIPART EN SYNC (paso_7)

Esta especificación técnica detalla cómo exportar los trazos del lienzo de firma digital a un archivo PNG físico en el teléfono, modificar el esquema de base de datos SQLite y actualizar el motor de sincronización `SyncService` para realizar el envío Multipart final al servidor FastAPI.

---

## 🎯 Objetivo de Tarea
Completar el ciclo de vida del reporte técnico de reparación:
1. Exportar la firma del técnico (`SignatureController`) a un archivo PNG y guardarlo en el disco local del dispositivo.
2. Actualizar la base de datos local SQLite para incluir la columna `photo_signature_path`.
3. Modificar la cola de sincronización `SyncService` para empaquetar las 3 imágenes (antes, después y firma) en la petición `MultipartForm` y enviarla con éxito al backend FastAPI.

---

## 📂 Archivos a Crear / Modificar
*   `lib/core/database/database_helper.dart` (Actualizar versión del esquema SQLite a v2 para soportar la firma)
*   `lib/core/database/sync_service.dart` (Modificar firmas de guardado y carga de Multipart)
*   `lib/features/ot_execution/presentation/execution_screen.dart` (Integrar guardado físico de firma PNG al dar clic a Finalizar)

---

## 📋 Directrices de Programación y Flujo de Trabajo

### 1. Actualización Dinámica del Esquema SQLite (`database_helper.dart`)
*   Incrementa la versión de la base de datos a `version: 2`.
*   Añade el parámetro `onUpgrade` en `openDatabase` para aplicar la migración de forma segura sin borrar los datos existentes de los técnicos:
    ```dart
    static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE offline_sync_queue ADD COLUMN photo_signature_path TEXT');
      }
    }
    ```

### 2. Exportación de Trazos a Imagen PNG en Flutter
*   En `ExecutionScreen`, al presionar el botón de **Finalizar Reparación**, antes de invocar a `saveReportOffline(...)`, exporta los trazos del lienzo:
    ```dart
    final Uint8List? signatureBytes = await _signatureController.toPngBytes();
    ```
*   Guarda los bytes en un archivo temporal o en el directorio de documentos de la app:
    ```dart
    final directory = await getApplicationDocumentsDirectory();
    final String signaturePath = '${directory.path}/signature_ot_$otId.png';
    final File file = File(signaturePath);
    await file.writeAsBytes(signatureBytes!);
    ```
*   *Nota:* Para usar `getApplicationDocumentsDirectory()`, asegúrate de tener el paquete `path_provider` en tu archivo pubspec. Si no quieres añadir otra dependencia, puedes usar un archivo temporal en base a la ruta de las imágenes previas o escribirlo de forma cruda.

### 3. Actualización de Cola y Multipart (`sync_service.dart`)
*   Modifica el método `saveReportOffline` para que acepte el parámetro `required String signaturePath`.
*   Inserta este campo en la columna `photo_signature_path` de SQLite.
*   En el método `triggerSyncProcess`, extrae el archivo de la firma mediante Multipart:
    ```dart
    final formData = FormData.fromMap({
      ...
      'foto_antes': await MultipartFile.fromFile(report['photo_before_path']),
      'foto_despues': await MultipartFile.fromFile(report['photo_after_path']),
      'firma_tecnico': await MultipartFile.fromFile(report['photo_signature_path']), // FIRMA FÍSICA OBLIGATORIA
    });
    ```

---

## 🎨 Código Base de Apoyo

### 1. Migración en `lib/core/database/database_helper.dart`
```dart
  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hydra_offline.db');

    return await openDatabase(
      path,
      version: 2, // Incrementar a 2
      onCreate: _createDB,
      onUpgrade: _onUpgrade, // Agregar manejador de actualización
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
        photo_signature_path TEXT, -- Nueva columna agregada
        lat_reparacion REAL NOT NULL,
        lon_reparacion REAL NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE session_store (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE offline_sync_queue ADD COLUMN photo_signature_path TEXT');
      print("[SQLite] Esquema migrado con éxito a versión 2 (Soporte de Firma Digital).");
    }
  }
```

### 2. Guardado físico y envío en `lib/core/database/sync_service.dart`
```dart
  Future<void> saveReportOffline({
    required int otId,
    required String tipoHallazgo,
    required String material,
    required String diametro,
    required Map<String, int> materialesUsados,
    required String photoBeforePath,
    required String photoAfterPath,
    required String signaturePath, // Nuevo parámetro
    required double lat,
    required double lon,
  }) async {
    await database.insert(
      'offline_sync_queue',
      {
        'ot_id': otId,
        'tipo_hallazgo_real': tipoHallazgo,
        'material_real': material,
        'diametro_real': diametro,
        'materiales_usados': jsonEncode(materialesUsados),
        'photo_before_path': photoBeforePath,
        'photo_after_path': photoAfterPath,
        'photo_signature_path': signaturePath, // Guardar ruta física
        'lat_reparacion': lat,
        'lon_reparacion': lon,
        'status': 'PENDING_SYNC',
        'created_at': DateTime.now().toIso8601String()
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
```
*Asegúrate de agregar `'firma_tecnico': await MultipartFile.fromFile(report['photo_signature_path'])` en el mapa de `FormData` dentro de `triggerSyncProcess()`.*
