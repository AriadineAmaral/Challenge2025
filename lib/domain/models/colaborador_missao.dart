class ColaboradorMissao {
  int idColaboradorMissao;
  int idColaborador;
  int idMissao;

  ColaboradorMissao({
    required this.idColaboradorMissao,
    required this.idColaborador,
    required this.idMissao,
  });

  factory ColaboradorMissao.fromMap(Map<String, dynamic> map) {
    return ColaboradorMissao(
      idColaboradorMissao: map['id_colaborador_missao'],
      idColaborador: map['id_colaborador'],
      idMissao: map['id_missao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_colaborador_missao': idColaboradorMissao,
      'id_colaborador': idColaborador,
      'id_missao': idMissao,
    };
  }

}
