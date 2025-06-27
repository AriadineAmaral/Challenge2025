import 'package:europro/domain/models/projeto.dart';

abstract class ProjetoRepository {
  Future<void> addProjeto(String titulo, String descricao, String tipoProjeto);
  Future<List<Projeto>> listProjetosColaborador();
}
