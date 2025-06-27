
abstract class UsuarioRepository {
  Future<void> addUsuario(String email, String senha, String cpf);
  Future<bool> findLoginUsuario(String email, String senha);
}
