import 'package:europro/domain/models/colaborador_missao.dart';
import 'package:europro/domain/models/missao.dart';

abstract class MissaoRepository {
  Future<List<Missao>> listMissoes();
  Future<List<ColaboradorMissao>> listColaboradorMissoes();
  Future<void> concluirMissao(int idMissao, int pontos);
  Future<int> countMissaoColaborador();
  Future<int> countMissaoDisponivel();
}
