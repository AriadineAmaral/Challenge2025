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
    _loadAllData();
    // _carregarPontuacao();
    // _listPontuacao();
  }

  Future<void> _loadAllData() async {
    setState(() => isLoading = true);
    try {
      await Future.wait([_carregarPontuacao(), _listPontuacao()]);
    } catch (e) {
      // Trate erros se quiser
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _carregarPontuacao() async {
    final resultado = await pontuacaoRepo.pontuacaoColaborador();
    pontuacao = resultado;
  }

  Future<void> _listPontuacao() async {
    try {
      final resultado = await pontuacaoRepo.listPontuacao();
      historicoPontuacao = resultado;
    } catch (e) {
      throw Exception(e);
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

    final bool isLargeScreen = MediaQuery.of(context).size.width >= 1072;

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
        automaticallyImplyLeading: !isLargeScreen, // Remove ícone do drawer
      ),
      drawer: isLargeScreen ? null : TitleAndDrawer(),
      body: Stack(
        children: [
          if (isLargeScreen) SizedBox(width: 250, child: TitleAndDrawer()),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
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
                          Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: 50,
                          ),
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
                              final isNegative = missao["pontos"]!.contains(
                                '-',
                              );

                              return Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
            ),
          ),
          if (isLoading)
            Container(
              color: const Color.fromRGBO(255, 255, 255, 0.7),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF00358E)),
              ),
            ),
        ],
      ),
      bottomNavigationBar: isLargeScreen ? null : Footer(),
    );
  }
}
