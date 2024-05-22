
import 'package:trabalho_calendario/model/calendario.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider{
  static const _dbName = 'calendario.db';
  static const _dbVersion = 1;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async{
    if(_database == null){
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async{
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
      ${Calendario.campo_dia} TEXTs
      );
        ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async{

  }

  Future<void> close() async{
    if(_database != null){
      await _database!.close();
    }
  }
}