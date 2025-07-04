import 'package:europro/data/repository/remote_projeto_repository.dart';
import 'package:europro/domain/models/projeto.dart';
import 'package:europro/notification_screens/notification_screen.dart';
import 'package:europro/perfil_screens/perfil_screen.dart';
import 'package:europro/projects_screens/my_projects_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailProjects extends StatefulWidget {
  final Projeto projeto;

  const DetailProjects({Key? key, required this.projeto}) : super(key: key);

  @override
  State<DetailProjects> createState() => _MyProjectsState();
}

class _MyProjectsState extends State<DetailProjects> {
  final projetoRepo = RemoteProjetoRepository(client: Supabase.instance.client);

  String _formataData(DateTime data) {
    return DateFormat('dd/MM/yyyy').format(data);
  }

  List<Projeto> projetos = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final projeto = widget.projeto;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: Colors.black,
        scrolledUnderElevation: 0,
        title: Image.asset('images/logoEuroPro.png', height: 30),
        centerTitle: true,
      ),
      drawer: TitleAndDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyProjects()))
                  },
                  padding: EdgeInsets.only(left: 14),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 32),
                    child: Text(
                      'Meus projetos',
                      style: GoogleFonts.akatab(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
             const SizedBox(height: 36),
            Card(
              color: Colors.white, // <- fundo branco
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Melhor alinhamento interno
                  children: [
                    Center(
                      // Nome do projeto centralizado
                      child: Text(
                        projeto.tipoProjeto == 1
                            ? 'Projeto Kaizen'
                            : projeto.tipoProjeto == 2
                            ? 'Projeto Clic'
                            : 'Projeto desconhecido',
                        style: GoogleFonts.akatab(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00358E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Título:',
                      style: GoogleFonts.akatab(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(projeto.titulo, style: GoogleFonts.kufam(fontSize: 16)),
                    const SizedBox(height: 24),

                    Text(
                      'Descrição:',
                      style: GoogleFonts.akatab(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      projeto.descricao,
                      style: GoogleFonts.kufam(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Data de envio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Enviado em: ${DateFormat('dd/MM/yyyy').format(projeto.dataInicio)}',
                style: GoogleFonts.kufam(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
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
