import 'package:sqflite/sqflite.dart';
import 'sync_queue_storage_service.dart';

class SessionStorageService {
  static const String _tokenKey = 'jwt_token';
  static const String _refreshTokenKey = 'jwt_refresh_token';
  static const String _nameKey = 'user_name';
  static const String _roleKey = 'user_role';
  static const String _userIdKey = 'user_id';
  static const String _codeKey = 'user_code';

  final SyncQueueStorageService _storage;

  SessionStorageService({required SyncQueueStorageService storage})
      : _storage = storage;

  Future<void> saveToken(String token) async {
    final db = await _storage.database;
    await db.insert(
      'session_store',
      {'key': _tokenKey, 'value': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getToken() async {
    final db = await _storage.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'session_store',
      where: 'key = ?',
      whereArgs: [_tokenKey],
    );
    if (maps.isEmpty) return null;
    return maps.first['value'] as String;
  }

  Future<void> saveRefreshToken(String token) async {
    final db = await _storage.database;
    await db.insert(
      'session_store',
      {'key': _refreshTokenKey, 'value': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getRefreshToken() async {
    final db = await _storage.database;
    final maps = await db.query(
      'session_store',
      where: 'key = ?',
      whereArgs: [_refreshTokenKey],
    );
    if (maps.isEmpty) return null;
    return maps.first['value'] as String;
  }

  Future<void> saveUserName(String name) async {
    final db = await _storage.database;
    await db.insert(
      'session_store',
      {'key': _nameKey, 'value': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getUserName() async {
    final db = await _storage.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'session_store',
      where: 'key = ?',
      whereArgs: [_nameKey],
    );
    if (maps.isEmpty) return null;
    return maps.first['value'] as String;
  }

  Future<void> saveUserRole(String role) async {
    final db = await _storage.database;
    await db.insert(
      'session_store',
      {'key': _roleKey, 'value': role},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getUserRole() async {
    final db = await _storage.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'session_store',
      where: 'key = ?',
      whereArgs: [_roleKey],
    );
    if (maps.isEmpty) return null;
    return maps.first['value'] as String;
  }

  Future<void> saveUserId(int id) async {
    final db = await _storage.database;
    await db.insert(
      'session_store',
      {'key': _userIdKey, 'value': id.toString()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> saveUserCode(String code) async {
    final db = await _storage.database;
    await db.insert(
      'session_store',
      {'key': _codeKey, 'value': code},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getUserCode() async {
    final db = await _storage.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'session_store',
      where: 'key = ?',
      whereArgs: [_codeKey],
    );
    if (maps.isEmpty) return null;
    return maps.first['value'] as String;
  }

  Future<int?> getUserId() async {
    final db = await _storage.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'session_store',
      where: 'key = ?',
      whereArgs: [_userIdKey],
    );
    if (maps.isEmpty) return null;
    final raw = maps.first['value'] as String?;
    if (raw == null) return null;
    return int.tryParse(raw);
  }

  Future<void> clearSession() async {
    final db = await _storage.database;
    await db.delete('session_store', where: 'key = ?', whereArgs: [_tokenKey]);
    await db.delete(
      'session_store',
      where: 'key = ?',
      whereArgs: [_refreshTokenKey],
    );
    await db.delete('session_store', where: 'key = ?', whereArgs: [_nameKey]);
    await db.delete('session_store', where: 'key = ?', whereArgs: [_roleKey]);
    await db.delete('session_store', where: 'key = ?', whereArgs: [_userIdKey]);
    await db.delete('session_store', where: 'key = ?', whereArgs: [_codeKey]);
    await _storage.clearAssignedOrdersCache();
  }

  Future<bool> hasSession() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
