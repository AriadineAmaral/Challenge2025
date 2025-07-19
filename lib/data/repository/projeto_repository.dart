import 'package:europro/domain/models/projeto.dart';

abstract class ProjetoRepository {
  Future<int> addProjeto(String titulo, String descricao, String tipoProjeto, {
    List<int>? idColaboradores, 
  });
  Future<List<Projeto>> listProjetosColaborador();
}
