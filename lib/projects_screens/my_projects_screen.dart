import 'package:europro/data/repository/remote_projeto_repository.dart';
import 'package:europro/domain/models/projeto.dart';
import 'package:europro/notification_screens/notification_screen.dart';
import 'package:europro/perfil_screens/perfil_screen.dart';
import 'package:europro/projects_screens/detail_projects_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyProjects extends StatefulWidget {
  const MyProjects({Key? key}) : super(key: key);

  @override
  State<MyProjects> createState() => _MeusProjetosScreenState();
}

class _MeusProjetosScreenState extends State<MyProjects> {


  final projetoRepo = RemoteProjetoRepository(
   client: Supabase.instance.client,
  );

  List<Projeto> projetos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _findProjetos();
  }

  Future<void> _findProjetos() async {
    print('userID: ${Supabase.instance.client.auth.currentUser?.id}');

    try {
      final resultado = await projetoRepo.listProjetosColaborador();
      setState(() {
        projetos = resultado;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: const Text(
          'EuroPro',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com botão voltar e título
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Meus projetos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Lista de projetos + a classe com os dados!!!
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: projetos.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final projeto = projetos[index];
                return _ProjetoCard(
                  projeto: projeto,
                  onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailProjects(projeto: projeto),
                    ),
                  );
                }

                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Color(0xFF00358E),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Botão Notificações
            _buildSimpleNavIcon(
              icon: Icons.notifications_none,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  ),
            ),

            // Botão Home
            _buildSimpleNavIcon(
              icon: Icons.home_outlined,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RankingScreen()),
                  ),
            ),

            // Botão Perfil
            _buildSimpleNavIcon(
              icon: Icons.person_outline,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PerfilScreen()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSimpleNavIcon({
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return IconButton(
    icon: Icon(icon, color: Colors.white),
    iconSize: 25, // Tamanho fixo (ajuste conforme necessário)
    padding: EdgeInsets.symmetric(
      horizontal: 25,
      vertical: 10,
    ), // Espaçamento interno
    constraints: BoxConstraints(), // Remove restrições de tamanho padrão
    onPressed: onPressed,
  );
}

//Classe para criar os dados mockados

class _ProjetoCard extends StatelessWidget {
  final Projeto projeto;
  final VoidCallback onTap;

  const _ProjetoCard({required this.projeto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF9E9E9E),
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome do Projeto + Icone
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                   projeto.tipoProjeto == 1
                  ? 'Projeto Kaizen'
                  : projeto.tipoProjeto == 2
                      ? 'Projeto Clic'
                      : 'Projeto desconhecido',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00358E),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            // Status
            Text(
              'Status: ${_capitalize(projeto.idStatus == 1 ? 'análise e seleção' : projeto.idStatus == 2 ? 'em desenvolvimento' : 'finalizado')}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    return text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;
  }
}

// class Projeto {
//   final String nome;
//   final String status;

//   Projeto({required this.nome, required this.status});
// }
