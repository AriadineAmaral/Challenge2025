import 'package:europro/data/repository/remote_colaborador_repository.dart';
import 'package:europro/data/repository/remote_missao_repository.dart';
import 'package:europro/domain/models/colaborador.dart';
import 'package:europro/mission_screens/missions_screen.dart';
import 'package:europro/widgets/button.dart';
import 'package:europro/widgets/footer.dart';
import 'package:europro/widgets/projects.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final colaboradorRepo = RemoteColaboradorRepository(
    client: Supabase.instance.client,
  );

  final missoesRepo = RemoteMissaoRepository(client: Supabase.instance.client);

  int missoesConcluidas = 0;
  int missoesDisponivel = 0;

  List<Colaborador> colaboradores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _findColaboradores();
    _carregarMissoesConcluidas();
    _carregarMissoesDisponiveis();
  }

  void _carregarMissoesConcluidas() async {
    final resultado = await missoesRepo.countMissaoColaborador();
    if (mounted) {
      setState(() {
        missoesConcluidas = resultado;
        isLoading = false;
      });
    }
  }

  void _carregarMissoesDisponiveis() async {
    final resultado = await missoesRepo.countMissaoDisponivel();
    if (mounted) {
      setState(() {
        missoesDisponivel = resultado;
        isLoading = false;
      });
    }
  }

  Future<void> _findColaboradores() async {
    try {
      final resultado = await colaboradorRepo.listRankingColaborador();
      if (mounted) {
        setState(() {
          colaboradores = resultado;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _getMedal(int index) {
    switch (index) {
      case 0:
        return Icon(Icons.emoji_events, color: Colors.amber, size: 24);
      case 1:
        return Icon(Icons.emoji_events, color: Colors.grey, size: 24);
      case 2:
        return Icon(Icons.emoji_events, color: Colors.brown, size: 24);
      default:
        return SizedBox(width: 24);
    }
  }

  @override
  Widget build(BuildContext context) {
    double progresso =
        (missoesDisponivel > 0) ? missoesConcluidas / missoesDisponivel : 0.0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: Colors.black,
        scrolledUnderElevation: 0,
        title: Image.asset('images/logoEuroPro.png', height: 30),
      ),
      drawer: TitleAndDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Título centralizado
              Center(
                child: Text(
                  "Colaboradores em destaque",
                  style: GoogleFonts.akatab(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Cabeçalho responsivo
              Divider(thickness: 2),
              // Lista de colaboradores
              // Lista de colaboradores com rolagem própria
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Colaborador',
                            style: GoogleFonts.akatab(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'Pontuação',
                              style: GoogleFonts.akatab(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(),

                  // Lista de Colaboradores
                  Container(
                    height: 300,
                    child: ListView.builder(
                      itemCount: colaboradores.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 10.0,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    colaboradores[index].fotoUrl != null
                                        ? NetworkImage(
                                          '${colaboradores[index].fotoUrl!}?v=${DateTime.now().millisecondsSinceEpoch}',
                                        )
                                        : null,
                                backgroundColor: Colors.grey[300],
                                child:
                                    colaboradores[index].fotoUrl == null
                                        ? Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        )
                                        : null,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  colaboradores[index].nome,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.kufam(),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _getMedal(index),
                                    SizedBox(width: 4),
                                    Text(
                                      "${colaboradores[index].pontuacao}",
                                      style: GoogleFonts.kufam(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),
              // Missões do mês
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF00358E),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "Missões do mês",
                            style: GoogleFonts.akatab(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MissionScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Ver missões",
                                style: GoogleFonts.kufam(color: Colors.white),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progresso, // entre 0.0 e 1.0
                      backgroundColor: Color(0x4D0000FF),
                      color: Colors.yellowAccent,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Concluídas $missoesConcluidas/$missoesDisponivel",
                      style: GoogleFonts.akatab(color: Colors.white),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // NOVAEURO
              Center(
                child: Container(
                  padding: EdgeInsets.all(16),
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
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: "#INOVAEURO",
                              style: GoogleFonts.akatab(
                                color: Color(0xFF00358E),
                              ),
                            ),
                            TextSpan(
                              text: " Transforme ideias em recompensas!",
                              style: GoogleFonts.akatab(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.kufam(fontSize: 16),
                          children: [
                            TextSpan(
                              text: "Suas ideias podem valer muito! ",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  "Participe dos programas de inovação, concorra a brindes e ganhe prêmios em dinheiro.",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Button(
                        text: 'Conheça nossos projetos',
                        backgroundColor: Colors.yellow,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Projects(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
