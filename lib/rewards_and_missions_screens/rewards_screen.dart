import 'package:europro/data/repository/remote_pontuacao_repository.dart';
import 'package:europro/domain/models/pontuacao.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:europro/widgets/footer.dart';
import 'package:europro/widgets/header.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: Colors.white,
      drawer: TitleAndDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Header(
              titulo: 'Minha pontuação',
              destinoAoVoltar: RankingScreen(),
              backgroundColor: Colors.transparent,
              textColor: Colors.black,
              height: 30,
            ),
          ),

            const SizedBox(height: 16),

            // Pontuação total
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF00358E),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, color: Colors.white, size: 50),
                  SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '$pontuacao',
                      style: GoogleFonts.kufam(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Histórico de pontuação - Título
            Text(
              "Histórico de pontuação",
              style: GoogleFonts.akatab(
                fontSize: 20,
                fontWeight: FontWeight.w700,
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
                  borderRadius: BorderRadius.circular(5),
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
                                style: GoogleFonts.kufam(
                                  color:
                                      isNegative
                                          ? Colors.red
                                          : const Color(0xFF007BFF),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                missao["expira"]!,
                                style: GoogleFonts.kufam(
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
      bottomNavigationBar: Footer(),
    );
  }
}
