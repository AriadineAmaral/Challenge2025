import 'package:europro/data/repository/remote_pontuacao_repository.dart';
import 'package:europro/domain/models/pontuacao.dart';
import 'package:europro/notification_screens/notification_screen.dart';
import 'package:europro/perfil_screens/perfil_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});
  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final pontuacaoRepo = RemotePontuacaoRepository(
    client: Supabase.instance.client,
  );

  int pontuacao = 0;
  List<Pontuacao> historicoPontuacao = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarPontuacao();
    _listPontuacao();
  }

  void _carregarPontuacao() async {
    final resultado = await pontuacaoRepo.pontuacaoColaborador();
    if (mounted) {
      setState(() {
        pontuacao = resultado;
        isLoading = false;
      });
    }
  }

  Future<void> _listPontuacao() async {
    try {
      final resultado = await pontuacaoRepo.listPontuacao();
      if (mounted) {
        setState(() {
          historicoPontuacao = resultado;
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

  List<Map<String, String>> historico(List<Pontuacao> historicoPontuacao) {
    final hoje = DateTime.now();

    historicoPontuacao.sort((a, b) => b.dataOrigem.compareTo(a.dataOrigem));

    final List<Map<String, String>> pontos = [];

    for (var pontuacao in historicoPontuacao) {
      final expirou = pontuacao.dataVencimento.isBefore(hoje);

      pontos.add({
        "pontos": "${expirou ? '-' : '+'} ${pontuacao.pontos} pts",
        "descricao":
            pontuacao.origem == 'Criação de projeto'
                ? 'Criação de projeto'
                : 'Missão concluída',
        "expira":
            expirou
                ? "Expirado em ${_formatarData(pontuacao.dataVencimento)}"
                : "Expira em ${_formatarData(pontuacao.dataVencimento)}",
      });
    }

    return pontos;
  }

  String _formatarData(DateTime data) {
    return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> historicoFormatado = historico(
      historicoPontuacao,
    );
    // final List<Map<String, String>> missoes = [
    //   {
    //     "pontos": "+ 8 pts",
    //     "descricao": "Missão concluída",
    //     "expira": "Expira em 30/10/2025",
    //   },
    //   {
    //     "pontos": "+ 15 pts",
    //     "descricao": "Missão concluída",
    //     "expira": "Expira em 17/10/2025",
    //   },
    //   {
    //     "pontos": "- 18 pts",
    //     "descricao": "Missão concluída",
    //     "expira": "Expirado em 12/07/2025",
    //   },
    //   {
    //     "pontos": "+ 20 pts",
    //     "descricao": "Missão concluída",
    //     "expira": "Expira em 5/10/2025",
    //   },
    //   {
    //     "pontos": "+ 50 pts",
    //     "descricao": "Inscrição Kaizen",
    //     "expira": "Expira em 5/09/2025",
    //   },
    //   {
    //     "pontos": "- 5 pts",
    //     "descricao": "Missão concluída",
    //     "expira": "Expira em 25/08/2025",
    //   },
    //   {
    //     "pontos": "+ 100 pts",
    //     "descricao": "Inscrição Clic",
    //     "expira": "Expira em 15/07/2025",
    //   },
    //   {
    //     "pontos": "- 12 pts",
    //     "descricao": "Missão concluída",
    //     "expira": "Expirado em 8/07/2025",
    //   },
    // ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Image.asset('images/logoEuroPro.png', height: 40),
      ),
      backgroundColor: Colors.white,
      drawer: TitleAndDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ArrowBack + Título
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    'Minha pontuação',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 48,
                ), // Para compensar o espaço do ícone de voltar
              ],
            ),

            const SizedBox(height: 16),

            // Pontuação total
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF00358E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Text(
                    '$pontuacao',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Histórico de pontuação - Título
            const Text(
              "Histórico de pontuação",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            // Lista de missões com scroll
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF9E9E9E),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: historicoFormatado.length,
                    itemBuilder: (context, index) {
                      final missao = historicoFormatado[index];
                      final isNegative = missao["pontos"]!.contains('-');

                      return Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${missao["pontos"]} ${missao["descricao"]}',
                                style: TextStyle(
                                  color:
                                      isNegative
                                          ? Colors.red
                                          : const Color(0xFF00358E),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                missao["expira"]!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
}
