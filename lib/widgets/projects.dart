import 'package:europro/widgets/project_clic.dart';
import 'package:europro/widgets/project_kaizen.dart';
import 'package:flutter/material.dart';

class Projects extends StatelessWidget {
  const Projects({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // fundo branco
      body: Column(
        children: [
          // Header azul com seta e título
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ), // Espaço nas laterais
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF00358E),
                borderRadius: BorderRadius.circular(12), // Borda arredondada
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Projetos de inovação",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),
          ),
          // Conteúdo com scroll
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(2),
              child: Column(
                children: [
                  // Card Projeto Kaizen
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.yellow, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "Projeto Kaizen",
                            style: TextStyle(
                              // fontFamily: ,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00358E),
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 14),
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProjectKaizen(),
                                ),
                              );
                            },
                            child: Text(
                              "INSCREVA-SE NO KAIZEN",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Card Projeto Clic
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.yellow, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "Projeto Clic",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00358E),
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 14),
                              children: [
                                TextSpan(
                                  text:
                                      "O Projeto Clic busca ideias com foco em resultados tangíveis para a Eurofarma. "
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProjectClic(),
                                ),
                              );
                            },
                            child: Text(
                              "INSCREVA-SE NO CLIC",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
