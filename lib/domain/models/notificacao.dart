class Notificacao {
  final int idNotificacao;
  final int idColaborador;
  final String conteudo;
  final DateTime data;

  Notificacao({
    required this.idNotificacao,
    required this.idColaborador,
    required this.conteudo,
    required this.data,
  });

  factory Notificacao.fromMap(Map<String, dynamic> map) {
    return Notificacao(
      idNotificacao: map['id_notificacao'],
      idColaborador: map['id_colaborador'],
      conteudo: map['conteudo'],
      data: DateTime.parse(map['data'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_notificacao': idNotificacao,
      'id_colaborador': idColaborador,
      'conteudo': conteudo,
      'data': data,
    };
  }
}
