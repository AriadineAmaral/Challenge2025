import 'package:europro/data/repository/remote_missao_repository.dart';
import 'package:europro/domain/models/colaborador_missao.dart';
import 'package:europro/domain/models/missao.dart';
import 'package:europro/notification_screens/notification_screen.dart';
import 'package:europro/perfil_screens/perfil_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    _findMissoes();
    _findColaboradorMissoes();
  }

  Future<void> _findMissoes() async {
    try {
      final resultado = await missaoRepo.listMissoes();
      if (mounted) {
        setState(() {
          missoes = resultado;
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

  Future<void> _findColaboradorMissoes() async {
    try {
      final resultado = await missaoRepo.listColaboradorMissoes();
      if (mounted) {
        setState(() {
          colaboradorMissoes = resultado;
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

  bool isMissaoConcluida(
    List<ColaboradorMissao> colaboradorMissoes,
    int idMissao,
  ) {
    return colaboradorMissoes.any((c) => c.idMissao == idMissao);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        title: Image.asset('images/logoEuroPro.png', height: 30),
      ),
      drawer: TitleAndDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),

            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF00358E),
                // Fundo azul
                borderRadius: BorderRadius.circular(
                  8,
                ), // Bordas arredondadas (opcional)
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ), // Ícone branco
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RankingScreen()));
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Missões do mês',
                        style:GoogleFonts.akatab(
                          color: Colors.white, // Texto branco
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Espaço para equilibrar
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: missoes.length,
              itemBuilder: (context, index) {
                final isConcluida = isMissaoConcluida(colaboradorMissoes, missoes[index].idMissao);
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: _MissaoItem(
  title: missoes[index].titulo,
  points: 'Ganhe ${missoes[index].pontos} pontos',
  buttonLabel: isConcluida ? 'concluída' : 'começar',
  buttonColor: isConcluida ? const Color(0xFF979797) : const Color(0xFF00358E),
  onButtonPressed: isConcluida
      ? null 
      : () async {
          await missaoRepo.concluirMissao(missoes[index].idMissao, missoes[index].pontos);
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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'ver minha pontuação',
                style: GoogleFonts.akatab(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
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
              minimumSize: const Size(100, 40), // <- Deixa o botão mais "gordo"
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
