class Projeto {
  final int idProjeto;
  final String titulo;
  final String descricao;
  final int tipoProjeto;
  final DateTime dataInicio;
  final DateTime? dataFim;
  final int idStatus;

  Projeto({
   required this.idProjeto,
    required this.titulo,
    required this.descricao,
    required this.tipoProjeto,
    required this.dataInicio,
    this.dataFim,
    required this.idStatus,
  });

  factory Projeto.fromMap(Map<String, dynamic> map) {
  return Projeto(
    idProjeto: map['id_projeto'],
    titulo: map['titulo'],
    descricao: map['descricao'],
    tipoProjeto: map['tipo_projeto'],
    dataInicio: DateTime.parse(map['data_inicio'] as String),
    dataFim: map['data_fim'] != null
        ? DateTime.parse(map['data_fim'] as String)
        : null,
    idStatus: map['id_status_projetos'],
  );
}


  Map<String, dynamic> toMap() {
    return {
      'id_projeto': idProjeto,
      'titulo': titulo,
      'descricao': descricao,
      'tipo_projeto': tipoProjeto,
      'data_inicio': dataInicio,
      'data_fim': dataFim,
      'id_status_projetos': idStatus,
    };
  }
}
