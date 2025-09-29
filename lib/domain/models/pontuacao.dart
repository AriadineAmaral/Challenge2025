class Pontuacao {
  final int idPontuacao;
  final int idColaborador;
  final String origem;
  final int pontos;
  final DateTime dataOrigem;
  final DateTime dataVencimento;

  Pontuacao({
    required this.idPontuacao, 
    required this.idColaborador,
    required this.origem,
    required this.pontos,
    required this.dataOrigem,
    required this.dataVencimento
  });

  factory Pontuacao.fromMap(Map<String, dynamic> map) {
  return Pontuacao(
    idPontuacao: map['id_pontuacao'],
    idColaborador: map['id_colaborador'],
    origem: map['origem'],
    pontos: map['pontos'],
    dataOrigem: DateTime.parse(map['data_origem'] as String),
    dataVencimento: DateTime.parse(map['data_vencimento'] as String),
  );
}


  Map<String, dynamic> toMap() {
    return {
      'id_pontuacao': idPontuacao,
      'id_colaborador': idColaborador,
      'origem': origem,
      'pontos': pontos,
      'data_origem': dataOrigem,
      'data_vencimento': dataVencimento,
    };
  }

  @override
String toString() {
  return 'Pontuacao(pontos: $pontos, origem: $origem, dataInicio: $dataOrigem, dataVencimento: $dataVencimento)';
}

}
