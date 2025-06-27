class Missao {
  final int idMissao;
  final String titulo;
  final int pontos;
  final bool disponivel;
  final DateTime dataVencimento;


  Missao({
    required this.idMissao,
    required this.titulo,
    required this.pontos,
    required this.disponivel,
    required this.dataVencimento,
  });

  factory Missao.fromMap(Map<String, dynamic> map) {
    return Missao(
      idMissao: map['id_missao'],
      titulo: map['titulo'],
      pontos: map['pontos'],
      disponivel: map['disponivel'],
      dataVencimento: DateTime.parse(map['data_vencimento'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_missao': idMissao,
      'titulo': titulo,
      'pontos': pontos,
      'disponivel': disponivel,
      'data_vencimento': dataVencimento,
    };
  }
}
