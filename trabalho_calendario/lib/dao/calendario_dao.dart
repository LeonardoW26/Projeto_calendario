import 'package:trabalho_calendario/database/database_provider.dart';
import 'package:trabalho_calendario/model/calendario.dart';

class CalendarioDao {
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Calendario calendario) async {
    final db = await dbProvider.database;
    final valores = calendario.toMap();
    if (calendario.id == null) {
      calendario.id = await db.insert(Calendario.nome_tabela, valores);
      return true;
    } else {
      final registrosAtualizados = await db.update(
        Calendario.nome_tabela, valores,
        where: '${Calendario.campo_id} = ?',
        whereArgs: [calendario.id],
      );
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover(int id) async {
    final db = await dbProvider.database;
    final removerRegistro = await db.delete(Calendario.nome_tabela,
        where: '${Calendario.campo_id} = ?', whereArgs: [id]);

    return removerRegistro > 0;
  }

  Future<List<Calendario>> Lista() async {
    final db = await dbProvider.database;

    final resultado = await db.query(Calendario.nome_tabela,
      columns: [
        Calendario.campo_id, Calendario.campo_descricao,
        Calendario.campo_dia, Calendario.campo_latitude,
        Calendario.campo_longitude
      ],
    );
    return resultado.map((m) => Calendario.fromMap(m)).toList();
  }
}
