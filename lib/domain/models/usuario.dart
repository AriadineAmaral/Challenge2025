class Usuario {
  final int? idUsuario;
  final int? idColaborador;
  final String email;
  final String senha;

  Usuario({
    this.idUsuario,
    this.idColaborador,
    required this.email,
    required this.senha,
  });


factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['id_usuario'],
      idColaborador: map['id_colaborador'],
      email: (map['email']),
      senha: map['senha'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id_usuario': idUsuario,
      'id_colaborador': idColaborador,
      'email': email,
      'senha': senha,
    };
  }
}
