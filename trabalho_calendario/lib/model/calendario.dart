import 'package:intl/intl.dart';

class Calendario {
  static const nome_tabela = 'calendario';
  static const campo_id = '_id';
  static const campo_descricao = 'descricao';
  static const campo_dia = 'dia';
  static const campo_latitude = 'latitude';
  static const campo_longitude = 'longitude';

  int? id;
  String? descricao;
  String? dia;
  double? latitude;
  double? longitude;

  Calendario({this.id, this.descricao, this.dia, this.latitude, this.longitude});

  Map<String, dynamic> toMap() => <String, dynamic>{
    campo_id: id,
    campo_descricao: descricao,
    campo_dia: dia,
    campo_latitude: latitude,
    campo_longitude: longitude,
  };

  factory Calendario.fromMap(Map<String, dynamic> map) => Calendario(
    id: map[campo_id] is int ? map[campo_id] : null,
    descricao: map[campo_descricao] is String ? map[campo_descricao] : '',
    dia: map[campo_dia] is String ? map[campo_dia] : '',
    latitude: map[campo_latitude] is double ? map[campo_latitude] : null,
    longitude: map[campo_longitude] is double ? map[campo_longitude] : null,
  );
}
