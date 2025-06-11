import 'package:europro/data/repository/usuario_repository.dart';
import 'package:europro/domain/models/colaborador.dart';
import 'package:europro/domain/models/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class RemoteUsuarioRepository implements UsuarioRepository {
  final SupabaseClient client;

  RemoteUsuarioRepository({required this.client});

  @override
  Future<void> addUsuario(Usuario usuario, String cpf) async {
    try {

      final cpfFormatado = cpf.trim();

          print('CPF consultado: "$cpfFormatado"');
          final result = await client
          .from('colaboradores')
          .select('*')
          .eq('cpf', cpfFormatado)
          .maybeSingle();

          print('Dados retornados: $result');



      if (result == null) {
        throw Exception('CPF não encontrado no banco de colaboradores.');
      }

      final colaborador = Colaborador.fromMap(result);
      print('✅ Colaborador encontrado: ${colaborador.nome}');

      final senhaCriptografada = sha256.convert(utf8.encode(usuario.senha)).toString();

  
      await client.from('usuarios').insert({
        'id_colaborador': colaborador.idColaborador,
        'email': usuario.email,
        'senha': senhaCriptografada,
      });
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }
}
