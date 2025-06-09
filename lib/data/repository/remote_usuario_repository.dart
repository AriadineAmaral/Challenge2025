import 'package:europro/data/repository/usuario_repository.dart';
import 'package:europro/domain/models/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteUsuarioRepository implements UsuarioRepository {
  final SupabaseClient client;

  RemoteUsuarioRepository({required this.client});

  @override
  Future<void> addUsuario(Usuario usuario, String cpf) async {
    try {
      final List<Map<String, dynamic>> result = await client
          .from('colaboradores')
          .select('id_colaborador')
          .eq('cpf', cpf);

      if (result.isNotEmpty) {
        await client.from('usuarios').insert([usuario.toMap()]);
      } 
    } catch (e) {
       throw Exception('Acesso não permitido: CPF não registrado como colaborador');
    }
  }
}
