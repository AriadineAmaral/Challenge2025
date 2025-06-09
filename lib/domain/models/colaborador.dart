class Colaborador {
  final int idColaborador;
  final String nome;
  final String email;
  final String cpf;
  final int pontuacao;

  Colaborador({
    required this.idColaborador,
    required this.nome,
    required this.email,
    required this.cpf,
    required this.pontuacao,
  });


  
factory Colaborador.fromMap(Map<String, dynamic> map) {
    return Colaborador(
      idColaborador: map['id_colaborador'],
      nome: (map['nome']),
      email: map['email'],
      cpf: map['cpf'],
      pontuacao: map['pontuacao'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id_colaborador': idColaborador,
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'pontuacao': pontuacao,
    };
  }
}
