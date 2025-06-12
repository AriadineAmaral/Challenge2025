import 'package:europro/data/repository/colaborador_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:europro/domain/models/colaborador.dart';

class RemoteColaboradorRepository implements ColaboradorRepository {
  final SupabaseClient client;

  RemoteColaboradorRepository({required this.client});

  @override
   Future<List<Colaborador>> listRankingColaborador() async{
    final result = await client.from('colaboradores').select().order('pontuacao', ascending: false).limit(10);
    final colaboradores = result.map((e) => Colaborador.fromMap(e)).toList();
    return colaboradores;
  }


}
