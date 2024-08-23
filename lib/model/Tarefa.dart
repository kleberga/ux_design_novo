import 'dart:ffi';

class Tarefa {
  final String id;
  final String titulo;
  final String descricao;
  final String data;
  final String hora_ini;
  final String hora_fim;
  final String prioridade;
  final String data_concluida;

  const Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.hora_ini,
    required this.hora_fim,
    required this.prioridade,
    required this.data_concluida
  });

  factory Tarefa.fromFirebaseDatabase(Map<String, dynamic> map) => Tarefa(
      id: map['id'],
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      data: map['data'],
      hora_ini: map['hora_ini'] ?? '',
      hora_fim: map['hora_fim'] ?? '',
      prioridade: map['prioridade'] ?? '',
      data_concluida: map['data_concluida'] ?? false
  );

  Map<String, dynamic> toMapForDb(){
    return{
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': data,
      'hora_ini': hora_ini,
      'hora_fim': hora_fim,
      'prioridade': prioridade,
      'data_concluida': data_concluida
    };
  }

  @override
  String toString(){
    return 'Tarefa{id: $id, titulo: $titulo, descricao: $descricao, '
        'data: $data, hora inicial: $hora_ini, hora final: $hora_fim, '
        'prioridade: $prioridade, data_concluida: $data_concluida';
  }
}