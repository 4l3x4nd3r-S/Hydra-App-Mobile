import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SyncQueueStorageService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hydra_offline.db');

    return await openDatabase(
      path,
      version: 7,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE offline_sync_queue (
        os_id INTEGER PRIMARY KEY,
        insumos_utilizados TEXT,
        observaciones_gasfitero TEXT,
        ruta_carpeta_evidencias TEXT,
        trabajo_ejecutado TEXT,
        problemas TEXT,
        soluciones TEXT,
        comentarios_instrucciones TEXT,
        latitud REAL,
        longitud REAL,
        fotos_problema_urls TEXT,
        fotos_solucion_urls TEXT,
        fecha_ejecucion_inicio TEXT,
        fecha_ejecucion_fin TEXT,
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

  Future<void> _upgradeDB(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      await db.execute('DROP TABLE IF EXISTS offline_sync_queue');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS offline_sync_queue (
          os_id INTEGER PRIMARY KEY,
          insumos_utilizados TEXT,
          observaciones_gasfitero TEXT,
          ruta_carpeta_evidencias TEXT,
          status TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 6) {
      await db.execute('DROP TABLE IF EXISTS offline_sync_queue');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS offline_sync_queue (
          os_id INTEGER PRIMARY KEY,
          insumos_utilizados TEXT,
          observaciones_gasfitero TEXT,
          ruta_carpeta_evidencias TEXT,
          trabajo_ejecutado TEXT,
          problemas TEXT,
          soluciones TEXT,
          comentarios_instrucciones TEXT,
          latitud REAL,
          longitud REAL,
          fotos_problema_urls TEXT,
          fotos_solucion_urls TEXT,
          status TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 7) {
      await db.execute('DROP TABLE IF EXISTS offline_sync_queue');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS offline_sync_queue (
          os_id INTEGER PRIMARY KEY,
          insumos_utilizados TEXT,
          observaciones_gasfitero TEXT,
          ruta_carpeta_evidencias TEXT,
          trabajo_ejecutado TEXT,
          problemas TEXT,
          soluciones TEXT,
          comentarios_instrucciones TEXT,
          latitud REAL,
          longitud REAL,
          fotos_problema_urls TEXT,
          fotos_solucion_urls TEXT,
          fecha_ejecucion_inicio TEXT,
          fecha_ejecucion_fin TEXT,
          status TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    }
  }

  Future<void> insertPending({
    required int osId,
    String? insumosUtilizados,
    String? observacionesGasfitero,
    String? rutaCarpetaEvidencias,
    String? trabajoEjecutado,
    String? problemas,
    String? soluciones,
    String? comentariosInstrucciones,
    double? latitud,
    double? longitud,
    String? fotosProblemaUrls,
    String? fotosSolucionUrls,
    String? fechaEjecucionInicio,
    String? fechaEjecucionFin,
  }) async {
    final db = await database;
    await db.insert(
      'offline_sync_queue',
      {
        'os_id': osId,
        'insumos_utilizados': insumosUtilizados,
        'observaciones_gasfitero': observacionesGasfitero,
        'ruta_carpeta_evidencias': rutaCarpetaEvidencias,
        'trabajo_ejecutado': trabajoEjecutado,
        'problemas': problemas,
        'soluciones': soluciones,
        'comentarios_instrucciones': comentariosInstrucciones,
        'latitud': latitud,
        'longitud': longitud,
        'fotos_problema_urls': fotosProblemaUrls,
        'fotos_solucion_urls': fotosSolucionUrls,
        'fecha_ejecucion_inicio': fechaEjecucionInicio,
        'fecha_ejecucion_fin': fechaEjecucionFin,
        'status': 'PENDING_SYNC',
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getPending() async {
    final db = await database;
    return await db.query(
      'offline_sync_queue',
      where: 'status = ?',
      whereArgs: ['PENDING_SYNC'],
    );
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await database;
    return await db.query('offline_sync_queue');
  }

  Future<void> markSynced(int osId) async {
    final db = await database;
    await db.update(
      'offline_sync_queue',
      {'status': 'SYNCED'},
      where: 'os_id = ?',
      whereArgs: [osId],
    );
  }
}
