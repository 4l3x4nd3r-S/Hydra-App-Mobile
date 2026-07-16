import 'dart:convert';

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
      version: 9,
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

    await _createAssignedOrdersCache(db);
    await _createPendingOrderStarts(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
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
    if (oldVersion < 8) {
      await _createAssignedOrdersCache(db);
    }
    if (oldVersion < 9) {
      await _createPendingOrderStarts(db);
    }
  }

  Future<void> _createAssignedOrdersCache(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS assigned_orders_cache (
        os_id INTEGER PRIMARY KEY,
        payload TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createPendingOrderStarts(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS offline_order_starts (
        os_id INTEGER PRIMARY KEY,
        started_at TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> savePendingOrderStart({
    required int osId,
    required String startedAt,
  }) async {
    final db = await database;
    await db.insert(
      'offline_order_starts',
      {
        'os_id': osId,
        'started_at': startedAt,
        'status': 'PENDING_SYNC',
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Map<String, dynamic>>> getPendingOrderStarts() async {
    final db = await database;
    return db.query(
      'offline_order_starts',
      where: 'status = ?',
      whereArgs: ['PENDING_SYNC'],
      orderBy: 'created_at ASC',
    );
  }

  Future<void> markOrderStartSynced(int osId) async {
    final db = await database;
    await db.delete(
      'offline_order_starts',
      where: 'os_id = ?',
      whereArgs: [osId],
    );
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
    await db.delete(
      'offline_sync_queue',
      where: 'os_id = ?',
      whereArgs: [osId],
    );
  }

  Future<void> updatePendingProblemPhotos(int osId, String paths) async {
    final db = await database;
    await db.update(
      'offline_sync_queue',
      {'fotos_problema_urls': paths},
      where: 'os_id = ?',
      whereArgs: [osId],
    );
  }

  Future<void> updatePendingSolutionPhotos(int osId, String paths) async {
    final db = await database;
    await db.update(
      'offline_sync_queue',
      {'fotos_solucion_urls': paths},
      where: 'os_id = ?',
      whereArgs: [osId],
    );
  }

  Future<void> replaceAssignedOrdersCache(
    List<Map<String, dynamic>> orders,
  ) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('assigned_orders_cache');
      final batch = txn.batch();
      final updatedAt = DateTime.now().toIso8601String();
      for (final order in orders) {
        final osId = order['id'];
        if (osId is! int) continue;
        batch.insert(
          'assigned_orders_cache',
          {
            'os_id': osId,
            'payload': jsonEncode(order),
            'updated_at': updatedAt,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<List<Map<String, dynamic>>> getAssignedOrdersCache() async {
    final db = await database;
    final rows = await db.query(
      'assigned_orders_cache',
      orderBy: 'os_id ASC',
    );
    return rows.map((row) {
      final decoded = jsonDecode(row['payload'] as String);
      return Map<String, dynamic>.from(decoded as Map);
    }).toList();
  }

  Future<void> upsertAssignedOrderCache(Map<String, dynamic> order) async {
    final osId = order['id'];
    if (osId is! int) return;

    final db = await database;
    await db.insert(
      'assigned_orders_cache',
      {
        'os_id': osId,
        'payload': jsonEncode(order),
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> markCachedOrderStarted({
    required int osId,
    required String startedAt,
  }) async {
    final db = await database;
    final rows = await db.query(
      'assigned_orders_cache',
      columns: ['payload'],
      where: 'os_id = ?',
      whereArgs: [osId],
      limit: 1,
    );
    if (rows.isEmpty) return;

    final decoded = jsonDecode(rows.first['payload'] as String);
    final order = Map<String, dynamic>.from(decoded as Map);
    order['estado_orden'] = 'EN_PROCESO';
    order['fecha_ejecucion_inicio'] = startedAt;
    await upsertAssignedOrderCache(order);
  }

  Future<void> clearAssignedOrdersCache() async {
    final db = await database;
    await db.delete('assigned_orders_cache');
  }
}
