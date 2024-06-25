import 'package:trabalho_calendario/model/calendario.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const _dbName = 'calendario.db';
  static const _dbVersion = 2;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String dbPath = '$databasePath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE ${Calendario.nome_tabela} (
          ${Calendario.campo_id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${Calendario.campo_descricao} TEXT NOT NULL,
          ${Calendario.campo_dia} TEXT,
          ${Calendario.campo_latitude} REAL,
          ${Calendario.campo_longitude} REAL
        );
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE ${Calendario.nome_tabela} ADD COLUMN ${Calendario.campo_latitude} REAL;
      ''');
      await db.execute('''
        ALTER TABLE ${Calendario.nome_tabela} ADD COLUMN ${Calendario.campo_longitude} REAL;
      ''');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
