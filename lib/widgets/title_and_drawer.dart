// title_drawer_widget.dart
import 'package:europro/login_screens/login_screen.dart';
import 'package:europro/mission_screens/missions_screen.dart';
import 'package:europro/perfil_screens/perfil_screen.dart';
import 'package:europro/projects_screens/my_projects_screen.dart';
import 'package:europro/projects_screens/project_kaizen_and_clic_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:europro/rewards_and_missions_screens/rewards_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TitleAndDrawer extends StatelessWidget {
  const TitleAndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 280,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 160, // Altura equivalente ao DrawerHeader
                  child: Stack(
                    children: [
                      // Conteúdo centralizado
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Color(0xFF00358E),
                              backgroundImage: AssetImage(
                                '',
                              ), // coloque seu caminho correto
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Seu Nome',
                              style: GoogleFonts.kufam(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Seu Email',
                              style: GoogleFonts.kufam(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Ícone no canto superior esquerdo
                      Positioned(
                        left: 16,
                        top: 16,
                        child: IconButton(
                          icon: Icon(Icons.menu, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
                // Restante dos itens do drawer...
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Meu Perfil',
                    style: GoogleFonts.akatab(),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilScreen()),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Alterar dados cadastrais',
                    style: GoogleFonts.akatab(),),
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilScreen()),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.track_changes),
                    title: Text('Missões',
                    style: GoogleFonts.akatab(),),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MissionScreen()),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.emoji_events),
                    title: Text('Minha pontuação',
                    style: GoogleFonts.akatab(),),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RewardsScreen()),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.snippet_folder_rounded),
                    title: Text('Meus projetos',
                    style: GoogleFonts.akatab(),),
                    onTap: () {
                      Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyProjects(),
                                ),
                              );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Novo projeto',
                    style: GoogleFonts.akatab(),),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectKaizenAndClicScreen()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.leaderboard),
                    title: Text('Ranking de colaboradores',
                    style: GoogleFonts.akatab(),),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RankingScreen()));
                    },
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Desconectar',
            style: GoogleFonts.akatab(),),
            onTap: () async {
              await Supabase.instance.client.auth.signOut();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => EuroProLoginScreen()),
              (route) => false,
            );
            },
          ),
        ],
      ),
    );
  }
}
