
abstract class UsuarioRepository {
  Future<void> addUsuario(String email, String senha, String cpf);
  Future<bool> findLoginUsuario(String email, String senha);
  Future<void> updateSenha(String novaSenha, String senhaAtual);
  Future<void> updateEmail(String novoEmail, String emailAtual);
  
}
