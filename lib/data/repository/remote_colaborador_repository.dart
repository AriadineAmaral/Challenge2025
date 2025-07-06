import 'package:europro/data/repository/colaborador_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:europro/domain/models/colaborador.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:europro/domain/models/colaborador.dart';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class RemoteColaboradorRepository implements ColaboradorRepository {
  final SupabaseClient client;

  RemoteColaboradorRepository({required this.client});

  @override
  Future<List<Colaborador>> listRankingColaborador() async {
    final result = await client
        .from('colaboradores')
        .select()
        .order('pontuacao', ascending: false)
        .limit(10);
    final colaboradores = result.map((e) => Colaborador.fromMap(e)).toList();
    return colaboradores;
  }

  // Novo método para upload da foto

  Future<String> uploadFotoPerfil(dynamic file) async {
  final user = client.auth.currentUser;
  if (user == null) throw Exception('Usuário não logado');

  final fileName = 'foto_${DateTime.now().millisecondsSinceEpoch}.jpg';
  final storagePath = 'fotos_perfil/${user.id}/$fileName';

  if (kIsWeb) {
    // Aqui, file é Uint8List (file.bytes)
    Uint8List bytes = file as Uint8List;
    await client.storage.from('fotosperfil').uploadBinary(
      storagePath,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );
  } else {
    // Aqui, file é File do dart:io
    File fileMobile = file as File;
    await client.storage.from('fotosperfil').upload(
      storagePath,
      fileMobile,
      fileOptions: const FileOptions(upsert: true),
    );
  }

  final publicUrl = client.storage.from('fotosperfil').getPublicUrl(storagePath);
  return publicUrl;
}

  // Atualiza a URL da foto no colaborador
  Future<void> atualizarFotoUrl(String fotoUrl) async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não logado');
    }

    await client
        .from('colaboradores')
        .update({'foto_url': fotoUrl})
        .eq('user_id', user.id);
  }
}
