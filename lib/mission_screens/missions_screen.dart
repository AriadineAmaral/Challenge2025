import 'package:europro/data/repository/remote_missao_repository.dart';
import 'package:europro/domain/models/colaborador_missao.dart';
import 'package:europro/domain/models/missao.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:europro/rewards_and_missions_screens/rewards_screen.dart';
import 'package:europro/widgets/button.dart';
import 'package:europro/widgets/footer.dart';
import 'package:europro/widgets/header.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  final missaoRepo = RemoteMissaoRepository(client: Supabase.instance.client);

  List<Missao> missoes = [];
  List<ColaboradorMissao> colaboradorMissoes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => isLoading = true);
    try {
      await Future.wait([_findMissoes(), _findColaboradorMissoes()]);
    } catch (e) {
      // Trate erros se necessário
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _findMissoes() async {
    final resultado = await missaoRepo.listMissoes();
    missoes = resultado;
  }

  Future<void> _findColaboradorMissoes() async {
    final resultado = await missaoRepo.listColaboradorMissoes();
    colaboradorMissoes = resultado;
  }

  bool isMissaoConcluida(
    List<ColaboradorMissao> colaboradorMissoes,
    int idMissao,
  ) {
    return colaboradorMissoes.any((c) => c.idMissao == idMissao);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: const Color(0xFFF8F9FA),
        elevation: 5,
        shadowColor: Colors.black,
        scrolledUnderElevation: 2,
        title: Image.asset('images/logoEuroPro.png', height: 30),
      ),
      drawer: TitleAndDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: Header(
                              titulo: 'Missões do mês',
                              destinoAoVoltar: RankingScreen(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: missoes.length,
                              itemBuilder: (context, index) {
                                final isConcluida = isMissaoConcluida(
                                  colaboradorMissoes,
                                  missoes[index].idMissao,
                                );
                                return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: _MissaoItem(
                                    title: missoes[index].titulo,
                                    points:
                                        'Ganhe ${missoes[index].pontos} pontos',
                                    buttonLabel:
                                        isConcluida ? 'concluída' : 'começar',
                                    buttonColor:
                                        isConcluida
                                            ? const Color(0xFF979797)
                                            : const Color(0xFF00358E),
                                    onButtonPressed:
                                        isConcluida
                                            ? null
                                            : () async {
                                              final missao = missoes[index];
      
                                              if (missao.link != null &&
                                                  missao.link!.isNotEmpty) {
                                                final uri = Uri.parse(
                                                  missao.link!,
                                                );
                                                if (await canLaunchUrl(uri)) {
                                                  await launchUrl(
                                                    uri,
                                                    mode:
                                                        LaunchMode
                                                            .externalApplication,
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Não foi possível abrir o link',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
      
                                              await missaoRepo.concluirMissao(
                                                missao.idMissao,
                                                missao.pontos,
                                              );
                                              await _findColaboradorMissoes();
                                              if (mounted) setState(() {});
                                            },
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Button(
                              text: 'Ver minha pontuação',
                              backgroundColor: Colors.yellow,
                              textColor: Colors.black,
                              isBold: true,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RewardsScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: const Color.fromRGBO(255, 255, 255, 0.8),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00358E),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Footer(),
    );
  }
}

class _MissaoItem extends StatelessWidget {
  final String title;
  final String points;
  final String buttonLabel;
  final Color buttonColor;
  final VoidCallback? onButtonPressed;

  const _MissaoItem({
    required this.title,
    required this.points,
    required this.buttonLabel,
    required this.buttonColor,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
        ],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.kufam(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  points,
                  style: GoogleFonts.kufam(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              minimumSize: const Size(100, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
            child: Text(
              buttonLabel,
              style: GoogleFonts.akatab(
                color: onButtonPressed == null ? Colors.black54 : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
