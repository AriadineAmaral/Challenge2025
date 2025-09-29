import 'package:europro/projects_screens/project_clic_sreen.dart';
import 'package:europro/projects_screens/project_kaizen_screen.dart';
import 'package:europro/widgets/button.dart';
import 'package:europro/widgets/footer.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Projects extends StatelessWidget {
  const Projects({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(12.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          // Card Projeto Kaizen
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.yellow, width: 3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Text(
                                    "Projeto Kaizen",
                                    style: GoogleFonts.akatab(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF00358E),
                                      decoration: TextDecoration.none,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 12),
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.kufam(fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text:
                                              "O Projeto Kaizen busca melhorias contínuas em processos, tarefas e organização. "
                                              "Pense em como otimizar seu fluxo de trabalho, eliminar desperdícios, simplificar atividades "
                                              "e tornar tudo mais eficiente."
                                              "Pequenas mudanças que, somadas, geram grandes resultados para você e para a Eurofarma.\n\n",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        TextSpan(
                                          text:
                                              "Com as suas ideias, você acumula pontos para trocar por prêmios quando quiser!",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Button(
                                    text: 'INCREVA-SE NO KAIZEN',
                                    backgroundColor: Colors.yellow,
                                    textColor: Colors.black,
                                    isBold: true,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const ProjectKaizen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),

                          // Card Ideia Clic
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.yellow, width: 3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Text(
                                    "Ideia Clic",
                                    style: GoogleFonts.akatab(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF00358E),
                                      decoration: TextDecoration.none,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 12),
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.kufam(fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text:
                                              "O Clic busca ideias com foco em resultados tangíveis para a Eurofarma. "
                                              "Se você tem uma solução que pode aumentar a produtividade, gerar retorno financeiro, "
                                              "reduzir custos ou promover a sustentabilidade, este é o lugar certo."
                                              "Pense em novas tecnologias, processos inovadores, otimização de recursos e estratégias "
                                              "que impulsionem o crescimento da empresa.\n\n",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        TextSpan(
                                          text:
                                              "Com os resultados positivos da sua ideia, além de acumular pontos, "
                                              "você pode receber um prêmio de até R\$120.000,00",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Button(
                                    text: 'INCREVA-SE NO CLIC',
                                    backgroundColor: Colors.yellow,
                                    textColor: Colors.black,
                                    isBold: true,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const ProjectClic(),
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isLargeScreen ? null : Footer(),
    );
  }
}
