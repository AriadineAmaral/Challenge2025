import 'package:europro/domain/models/pontuacao.dart';

abstract class PontuacaoRepository {
  Future<int> pontuacaoColaborador();
  Future<List<Pontuacao>> listPontuacao();
}
