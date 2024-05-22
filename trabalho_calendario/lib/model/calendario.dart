
import 'package:intl/intl.dart';

class Calendario{
  static const nome_tabela = 'calendario';
  static const campo_id = '_id';
  static const campo_descricao = 'descricao';
  static const campo_dia = 'dia';

  int? id;
  String? descricao;
  String? dia;

  Calendario({ this.id, this.descricao, this.dia});

  Map<String, dynamic> toMap() => <String, dynamic>{
    campo_id: id,
    campo_descricao: descricao,
    campo_dia: dia,
  };

  factory Calendario.fromMap(Map<String, dynamic> map) => Calendario(
    id: map[campo_id] is int ? map[campo_id]: null,
    descricao: map[campo_descricao] is String ? map[campo_descricao] : '',
    dia: map[campo_dia] is String ? map[campo_dia] : '',
  );

}