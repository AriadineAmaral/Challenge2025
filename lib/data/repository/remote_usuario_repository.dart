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
}
