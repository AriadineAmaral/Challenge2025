import 'package:europro/domain/models/Perfil.dart';

abstract class PerfilRepository {
  Future<Perfil> perfilUsuario();
  Future<List<Perfil>> listUsuarios();
}
