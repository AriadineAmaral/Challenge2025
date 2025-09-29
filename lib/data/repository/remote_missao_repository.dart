import 'package:europro/data/repository/missao_repository.dart';
import 'package:europro/domain/models/colaborador_missao.dart';
import 'package:europro/domain/models/missao.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteMissaoRepository implements MissaoRepository {
  final SupabaseClient client;

  RemoteMissaoRepository({required this.client});

  @override
  Future<List<Missao>> listMissoes() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      final usuario =
          await client
              .from('usuarios')
              .select('id_colaborador')
              .eq('user_id', userId.toString())
              .maybeSingle();

      if (usuario == null) return [];

      final result = await client
          .from('missoes')
          .select()
          .eq('disponivel', true);

      final missoes = result.map((e) => Missao.fromMap(e)).toList();

      return missoes;
    } catch (e) {
      throw Exception('Erro ao buscar missões: $e');
    }
  }

  @override
  Future<List<ColaboradorMissao>> listColaboradorMissoes() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      final usuario =
          await client
              .from('usuarios')
              .select('id_colaborador')
              .eq('user_id', userId.toString())
              .maybeSingle();

      if (usuario == null) return [];

      final colaboradorId = usuario['id_colaborador'];

      final result = await client
          .from('colaboradores_missoes')
          .select('*, missoes!inner(*)')
          .eq('missoes.disponivel', true)
          .eq('id_colaborador', colaboradorId);

      if (result.isEmpty) return [];

      final missoes = result.map((e) => ColaboradorMissao.fromMap(e)).toList();

      return missoes;
    } catch (e) {
      throw Exception('Erro ao buscar missões: $e');
    }
  }

  @override
  Future<void> concluirMissao(int idMissao, int pontos) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      final usuario =
          await client
              .from('usuarios')
              .select('id_colaborador')
              .eq('user_id', userId.toString())
              .maybeSingle();

      if (usuario == null) {
        throw Exception('Não foi possivel concluir a missão');
      }

      final colaboradorId = usuario['id_colaborador'];

      final resultado = await client
          .from('colaboradores_missoes')
          .select('*')
          .eq('id_colaborador', colaboradorId)
          .eq('id_missao', idMissao);

      if (resultado.isEmpty) {
        await client.from('colaboradores_missoes').insert({
          'id_colaborador': colaboradorId,
          'id_missao': idMissao,
        });

        final colaborador =
            await client
                .from('colaboradores')
                .select('pontos')
                .eq('id_colaborador', colaboradorId)
                .maybeSingle();

        if (colaborador == null) {
          return;
        }

        final pontosAtuais = colaborador['pontos'] ?? 0;
        final novoTotal = pontosAtuais + pontos;

        await client
            .from('colaboradores')
            .update({'pontos': novoTotal})
            .eq('id_colaborador', colaboradorId);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> countMissaoColaborador() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      final usuario =
          await client
              .from('usuarios')
              .select('id_colaborador')
              .eq('user_id', userId.toString())
              .maybeSingle();

      if (usuario == null) {
        throw Exception('Não foi possível contabilizar as missões concluídas');
      }

      final colaboradorId = usuario['id_colaborador'];

      final resultado = await client
          .from('colaboradores_missoes')
          .select('*, missoes(*)')
          .eq('id_colaborador', colaboradorId);

      final lista = resultado.map((e) => Missao.fromMap(e['missoes'])).toList();

      final dataAtual = DateTime.now();

      final count =
          lista.where((missao) {
            final data = missao.dataVencimento;
            return data.month == dataAtual.month && data.year == dataAtual.year;
          }).length;

      return count;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> countMissaoDisponivel() async {
    try {
      final resultado = await client
          .from('missoes')
          .select('*')
          .eq('disponivel', true);

      final lista = resultado.map((e) => Missao.fromMap(e)).toList();
      return lista.length;
    } catch (e) {
      rethrow;
    }
  }
}
