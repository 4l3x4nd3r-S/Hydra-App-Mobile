import 'package:sqflite/sqflite.dart';
import 'sync_queue_storage_service.dart';

class ThemeStorageService {
  static const String _themeModeKey = 'theme_mode';

  final SyncQueueStorageService _storage;

  ThemeStorageService({required SyncQueueStorageService storage})
      : _storage = storage;

  Future<void> saveThemeMode(String mode) async {
    final db = await _storage.database;
    await db.insert(
      'session_store',
      {'key': _themeModeKey, 'value': mode},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getThemeMode() async {
    final db = await _storage.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'session_store',
      where: 'key = ?',
      whereArgs: [_themeModeKey],
    );
    if (maps.isEmpty) return null;
    return maps.first['value'] as String;
  }
}
