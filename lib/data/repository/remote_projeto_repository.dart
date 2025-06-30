import 'package:europro/data/repository/projeto_repository.dart';
import 'package:europro/domain/models/projeto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteProjetoRepository implements ProjetoRepository {
  final SupabaseClient client;

  RemoteProjetoRepository({required this.client});

  @override
Future<int> addProjeto(
  String titulo,
  String descricao,
  String tipoProjeto,
) async {
  try {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    final usuario = await Supabase.instance.client
        .from('usuarios')
        .select('id_colaborador')
        .eq('user_id', userId.toString())
        .maybeSingle();

    if (usuario != null) {
      final colaboradorId = usuario['id_colaborador'];

      final projetoInserido = await client
          .from('projetos')
          .insert({
            'titulo': titulo,
            'descricao': descricao,
            'data_inicio': DateTime.now().toIso8601String(),
            'tipo_projeto': tipoProjeto,
            'id_status_projetos': 1,
          })
          .select('id_projeto')
          .single();

      final idProjeto = projetoInserido['id_projeto'];

      await client.from('inscricoes_projetos').insert({
        'id_colaborador': colaboradorId,
        'id_projeto': idProjeto,
      });

      return idProjeto;
    } else {
      throw Exception('Usuário não encontrado');
    }
  } catch (e) {
    throw Exception('Erro ao enviar inscrição: $e');
  }
}


  @override
  Future<List<Projeto>> listProjetosColaborador() async {
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

      final inscricoes = await client
          .from('inscricoes_projetos')
          .select('id_projeto')
          .eq('id_colaborador', colaboradorId);

      final idsProjeto = inscricoes.map((i) => i['id_projeto']).toList();

      if (idsProjeto.isEmpty) return [];

      final projetosData = await client
          .from('projetos')
          .select()
          .inFilter('id_projeto', idsProjeto);


      final projetos = projetosData.map((e) => Projeto.fromMap(e)).toList();

      return projetos;
    } catch (e) {
      throw Exception('Erro ao buscar projetos: $e');
    }
  }
}
