import 'package:europro/domain/models/colaborador_missao.dart';
import 'package:europro/domain/models/missao.dart';

abstract class MissaoRepository {
  Future<List<Missao>> listMissoes();
  Future<List<ColaboradorMissao>> listColaboradorMissoes();
  Future <void> concluirMissao(int idMissao);
  Future <int> countMissaoColaborador();
  Future<String> isMissaoConcluida(int idMissao);

}