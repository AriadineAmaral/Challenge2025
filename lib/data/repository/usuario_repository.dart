import 'package:europro/domain/models/usuario.dart';

abstract class UsuarioRepository {
  Future<void> addUsuario(Usuario usuario, String cpf);
}
