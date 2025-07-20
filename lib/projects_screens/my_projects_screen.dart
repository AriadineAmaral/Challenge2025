import 'package:europro/data/repository/remote_projeto_repository.dart';
import 'package:europro/domain/models/projeto.dart';
import 'package:europro/projects_screens/detail_projects_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:europro/widgets/footer.dart';
import 'package:europro/widgets/header.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    backgroundColor: Colors.white,
      
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Color(0xFFF8F9FA),
        elevation: 5,
        shadowColor: Colors.black,
        scrolledUnderElevation: 2,
        title: Image.asset('images/logoEuroPro.png', height: 30),
      ),
      drawer: TitleAndDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Header(
              titulo: 'Meus projetos',
              destinoAoVoltar: RankingScreen(),
              backgroundColor: Colors.transparent,
              textColor: Colors.black,
              height: 30,
            ),
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
      bottomNavigationBar: Footer(),
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
                  style: GoogleFonts.akatab(
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
              style: GoogleFonts.kufam(fontSize: 14),
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
