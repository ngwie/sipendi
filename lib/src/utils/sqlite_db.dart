import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDb {
  static Database? _client;

  static initialize() async {
    _client = await openDatabase(
      join(await getDatabasesPath(), 'sipendi_db.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reminder(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            active INTEGER,
            context TEXT,
            reference_id INTEGER,
            reference_name TEXT,
            recurrence_type TEXT
          );
          ''');
        await db.execute('''
          CREATE TABLE reminder_time(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            reminder_id INTEGER,
            time TEXT,
            FOREIGN KEY(reminder_id) REFERENCES reminder(id)
          );
        ''');
      },
      version: 1,
    );
  }

  static Database get client {
    if (_client == null) {
      throw const FormatException('Please initialize sqlite_db first');
    }

    return _client!;
  }
}
