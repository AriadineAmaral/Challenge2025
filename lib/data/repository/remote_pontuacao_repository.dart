import 'package:europro/data/repository/pontuacao_repository.dart';
import 'package:europro/domain/models/pontuacao.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemotePontuacaoRepository implements PontuacaoRepository {
  final SupabaseClient client;

  RemotePontuacaoRepository({required this.client});

  @override
  Future<int> pontuacaoColaborador() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final usuario =
          await client
              .from('usuarios')
              .select('id_colaborador')
              .eq('user_id', userId)
              .maybeSingle();

      if (usuario == null) {
        throw Exception('Usuário não localizado');
      }

      final idColaborador = usuario['id_colaborador'];

      final response = await client
          .from('pontuacao')
          .select('pontos')
          .eq('id_colaborador', idColaborador)
          .gte('data_vencimento', DateTime.now().toIso8601String());

    final pontos = (response as List)
          .map((e) => e['pontos'] ?? 0)
          .fold<int>(0, (sum, value) => sum + (value as int));
      return pontos;
      
    } catch (e) {
      throw Exception('Erro ao calcular pontuação: $e');
    }
  }

  @override
  Future<List<Pontuacao>> listPontuacao() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final usuario =
          await client
              .from('usuarios')
              .select('id_colaborador')
              .eq('user_id', userId)
              .maybeSingle();

      if (usuario == null) {
        throw Exception('Usuário não localizado');
      }

      final idColaborador = usuario['id_colaborador'];

      final result = await client
          .from('pontuacao')
          .select()
          .eq('id_colaborador', idColaborador);

      final colaboradores = result.map((e) => Pontuacao.fromMap(e)).toList();
      return colaboradores;
    } catch (e) {
      rethrow;
    }
  }
}
