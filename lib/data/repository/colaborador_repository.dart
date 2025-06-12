import 'package:europro/domain/models/colaborador.dart';

abstract class ColaboradorRepository {
  Future<List<Colaborador>> listRankingColaborador();
}