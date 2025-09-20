// title_drawer_widget.dart
import 'package:europro/chatbot_screen/eurobot_screen.dart';
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
import 'package:europro/data/repository/remote_perfil_repository.dart';


class TitleAndDrawer extends StatefulWidget {
  const TitleAndDrawer({super.key});

  @override
  State<TitleAndDrawer> createState() => _TitleAndDrawerState();
}

class _TitleAndDrawerState extends State<TitleAndDrawer> {
  final RemotePerfilRepository perfilRepo = RemotePerfilRepository(client: Supabase.instance.client);

  String? nome;
  String? email;
  String? fotoUrl;
  bool carregando = true;
  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
  setState(() {
    carregando = true;
  });

  try {
    final perfil = await perfilRepo.perfilUsuario();


    String? fotoUrl;

    if (perfil.id != '') {
      final colaborador = await Supabase.instance.client
          .from('colaboradores')
          .select('foto_url')
          .eq('id_colaborador', perfil.id)
          .maybeSingle();

      if (colaborador != null && colaborador['foto_url'] != null) {
        fotoUrl =
            '${colaborador['foto_url']}?v=${DateTime.now().millisecondsSinceEpoch}';
      }
    }

    setState(() {
      nome = perfil.nome;
      email = perfil.email;
      this.fotoUrl = fotoUrl ?? '';
      carregando = false;
    });
  } catch (e) {
    print('Erro ao carregar dados do perfil no drawer: $e');
    setState(() {
      carregando = false;
    });
  }
}

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
                  height: 160,
                  child:
                      carregando
                          ? Center(child: CircularProgressIndicator())
                          : Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Color(0xFF00358E),
                                      backgroundImage:
                                          (fotoUrl != null &&
                                                  fotoUrl!.isNotEmpty)
                                              ? NetworkImage(fotoUrl!)
                                              : null,
                                      child:
                                          (fotoUrl == null || fotoUrl!.isEmpty)
                                              ? Icon(
                                                Icons.person,
                                                size: 40,
                                                color: Colors.white,
                                              )
                                              : null,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      nome ?? '',
                                      style: GoogleFonts.kufam(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      email ?? '',
                                      style: GoogleFonts.kufam(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                    title: Text('Meu Perfil', style: GoogleFonts.akatab()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PerfilScreen()),
                      );
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 2.0),
                //   child: ListTile(
                //     leading: Icon(Icons.settings),
                //     title: Text(
                //       'Alterar dados cadastrais',
                //       style: GoogleFonts.akatab(),
                //     ),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => PerfilScreen()),
                //       );
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.track_changes),
                    title: Text('Missões', style: GoogleFonts.akatab()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MissionScreen(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.emoji_events),
                    title: Text('Minha pontuação', style: GoogleFonts.akatab()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RewardsScreen(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.snippet_folder_rounded),
                    title: Text('Meus projetos', style: GoogleFonts.akatab()),
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
                    title: Text('Novo projeto', style: GoogleFonts.akatab()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectKaizenAndClicScreen(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.leaderboard),
                    title: Text(
                      'Ranking de colaboradores',
                      style: GoogleFonts.akatab(),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RankingScreen(),
                        ),
                      );
                    },
                  ),
                ),Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.leaderboard),
                    title: Text(
                      'EuroBot',
                      style: GoogleFonts.akatab(),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Desconectar', style: GoogleFonts.akatab()),
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
