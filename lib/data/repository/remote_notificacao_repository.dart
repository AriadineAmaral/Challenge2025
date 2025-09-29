import 'package:europro/data/repository/notificacao_repository.dart';
import 'package:europro/domain/models/notificacao.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteNotificacaoRepository implements NotificacaoRepository {
  final SupabaseClient client;

  RemoteNotificacaoRepository({required this.client});

  @override
  Future<List<Notificacao>> listNotificacoes() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      final usuario =
          await client
              .from('usuarios')
              .select('id_colaborador')
              .eq('user_id', userId.toString())
              .maybeSingle();

      if (usuario == null) {
        throw Exception('Colaborador não encontrado');
      }

      final colaboradorId = usuario['id_colaborador'];
      final result = await client
          .from('notificacoes')
          .select('*')
          .eq('id_colaborador', colaboradorId)
          .order('data', ascending: false);
      final notificacoes = result.map((e) => Notificacao.fromMap(e)).toList();

      return notificacoes;

    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteNotificacao(int idNotificacao) async {
    await client
        .from('notificacoes')
        .delete()
        .eq('id_notificacao', idNotificacao);
  }
}
