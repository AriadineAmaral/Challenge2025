import 'package:europro/data/repository/perfil_repository.dart';
import 'package:europro/domain/models/Perfil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemotePerfilRepository implements PerfilRepository {
  final SupabaseClient client;

  RemotePerfilRepository({required this.client});

  @override
  Future<Perfil> perfilUsuario() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      final usuario =
          await client
              .from('usuarios')
              .select('id_colaborador')
              .eq('user_id', userId.toString())
              .maybeSingle();

      if (usuario == null) {
        throw Exception('Não foi possível localizar o usuário');
      }

      final colaboradorId = usuario['id_colaborador'];

      final resultado =
          await client
              .from('colaboradores')
              .select('nome, usuarios(email, id_colaborador)')
              .eq('id_colaborador', colaboradorId)
              .maybeSingle();

      if (resultado == null) {
        throw Exception('Colaborador não encontrado');
      }

      final nome = resultado['nome'] ?? '';
      final email = resultado['usuarios']?['email'] ?? '';
      final id = resultado['usuarios']?['id_colaborador'] ?? '';

      return Perfil(nome: nome, email: email, id: id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Perfil>> listUsuarios() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      final usuarioLogado =
          await client
              .from('usuarios')
              .select('id_colaborador')
              .eq('user_id', userId.toString())
              .maybeSingle();

      if (usuarioLogado == null) {
        throw (Exception('Usuário não localizado'));
      }

      final idColaboradorLogado = usuarioLogado['id_colaborador'];

      final resultado =
          await client
                  .from('usuarios')
                  .select('email, colaboradores(nome, id_colaborador)')
                  .neq('id_colaborador', idColaboradorLogado)
              as List;

      final perfis =
          resultado.map((item) {
            final nome = item['colaboradores']?['nome'] ?? '';
            final email = item['email'] ?? '';
            final id = item['colaboradores']?['id_colaborador'] ?? '';
            return Perfil(nome: nome, email: email, id: id);
          }).toList();

      return perfis;
    } catch (e) {
      rethrow;
    }
  }
}
