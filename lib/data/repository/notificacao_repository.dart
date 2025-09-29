import 'package:europro/domain/models/notificacao.dart';

abstract class NotificacaoRepository {
  Future<List<Notificacao>> listNotificacoes();
  Future<void> deleteNotificacao(int idNotificacao);
}
