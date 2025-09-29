import 'package:europro/data/repository/usuario_repository.dart';
import 'package:europro/domain/models/colaborador.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteUsuarioRepository implements UsuarioRepository {
  final SupabaseClient client;

  RemoteUsuarioRepository({required this.client});

  @override
  Future<void> addUsuario(String email, String senha, String cpf) async {
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
              .eq('email', email)
              .maybeSingle();

      if (emailRegistrado != null) {
        throw Exception('Email vinculado a outro usuário');
      }

      final response = await client.auth.signUp(email: email, password: senha);

      if (response.user != null) {
        await client.from('usuarios').insert({
          'id_colaborador': colaborador.idColaborador,
          'email': email,
          'user_id': response.user!.id,
        });
      } else {
        throw Exception('Erro ao criar usuário.');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> findLoginUsuario(String email, String senha) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: senha,
      );

      if (response.user == null) {
        throw Exception('Email ou senha inválidos.');
      }

      return true;
    } catch (e) {
      if (e.toString().contains('Email not confirmed')) {
        throw Exception('Você precisa confirmar seu e-mail antes de entrar.');
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> updateSenha(String novaSenha, String senhaAtual) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw Exception('Usuário não encontrado');
      }

      final email = Supabase.instance.client.auth.currentUser!.email;

      final reauthResponse = await Supabase.instance.client.auth
          .signInWithPassword(email: email!, password: senhaAtual);

      if (reauthResponse.user == null) {
        throw Exception('Senha atual incorreta');
      }

      final response = await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: novaSenha),
      );

      if (response.user == null) {
        throw Exception('Erro ao atualizar a senha');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateEmail(String novoEmail, String emailAtual) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Usuário não encontrado');
      }

      final email =
          await Supabase.instance.client
              .from('usuarios')
              .select('email')
              .eq('email', emailAtual);
             

      if (email.isNotEmpty) {
        final usuario =
            await Supabase.instance.client
                .from('usuarios')
                .select('id_colaborador')
                .eq('user_id', userId.toString())
                .maybeSingle();

        if (usuario != null) {
          final colaboradorId = usuario['id_colaborador'];

          final response = await Supabase.instance.client.auth.updateUser(
            UserAttributes(email: novoEmail),
          );

          if (response.user != null) {
            await Supabase.instance.client
                .from('usuarios')
                .update({'email': novoEmail})
                .eq('id_colaborador', colaboradorId);
          }

          if (response.user == null) {
            throw Exception('Erro ao atualizar o e-mail');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
