import 'package:bcrypt/bcrypt.dart';
import 'package:europro/data/repository/usuario_repository.dart';
import 'package:europro/domain/models/colaborador.dart';
import 'package:europro/domain/models/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteUsuarioRepository implements UsuarioRepository {
  final SupabaseClient client;

  RemoteUsuarioRepository({required this.client});

  @override
  Future<void> addUsuario(Usuario usuario, String cpf) async {
    try {
      final consultaCPF =
          await client
              .from('colaboradores')
              .select()
              .eq('cpf', cpf)
              .maybeSingle();

      if (consultaCPF == null) {
        throw Exception(
          'Não foi possível concluir o cadastro. CPF não registrado como colaborador',
        );
      }

      final colaborador = Colaborador.fromMap(consultaCPF);

      final colaboradorRegistrado =
          await client
              .from('usuarios')
              .select()
              .eq('id_colaborador', colaborador.idColaborador)
              .maybeSingle();

      if (colaboradorRegistrado != null) {
        throw Exception('Colaborador já registrado');
      }

      final emailRegistrado =
          await client
              .from('usuarios')
              .select()
              .eq('email', usuario.email)
              .maybeSingle();

      if (emailRegistrado != null) {
        throw Exception('Email vinculado a outro usuário');
      }

      final hashSenha = BCrypt.hashpw(usuario.senha, BCrypt.gensalt());

      await client.from('usuarios').insert({
        'id_colaborador': colaborador.idColaborador,
        'email': usuario.email,
        'senha': hashSenha,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> findLoginUsuario(String email, String senha) async {
    try {
      final result = await client
          .from('usuarios')
          .select('senha')
          .eq('email', email);

      if (result.isEmpty) {
        throw Exception('Email ou senha inválidos');
      }

      if (result.isNotEmpty) {
        String senhaHash = result[0]['senha'];
        bool senhaCorreta = BCrypt.checkpw(senha, senhaHash);

        if (!senhaCorreta) {
          throw Exception('Email ou senha inválidos');
        }
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
