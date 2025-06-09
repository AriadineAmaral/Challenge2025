import 'package:flutter/material.dart';
import 'package:europro/widgets/title_and_drawer.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final List<Map<String, dynamic>> colaboradores = [
    {
      "nome": "Ana Júlia Souza",
      "pontuacao": "249 pts",
      "imagem": "assets/ana.png",
    },
    {
      "nome": "Maria Fernandes",
      "pontuacao": "193 pts",
      "imagem": "assets/maria.png",
    },
    {
      "nome": "Marcos Vinicius Almeida",
      "pontuacao": "152 pts",
      "imagem": "assets/marcos.png",
    },
    {
      "nome": "Ricardo Oliveira",
      "pontuacao": "135 pts",
      "imagem": "assets/ricardo.png",
    },
    {
      "nome": "João Pedro Santos",
      "pontuacao": "117 pts",
      "imagem": "assets/joao.png",
    },
    {
      "nome": "Larissa Rodrigues",
      "pontuacao": "102 pts",
      "imagem": "assets/larissa.png",
    },
  ];

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
    int missoesConcluidas = 3;
    int totalMissoes = 5;
    double progresso = missoesConcluidas / totalMissoes;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Image.asset(
          'images/logoEuroPro.png',
          height: 40, // Ajuste conforme necessário
        ), 
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              // Cabeçalho responsivo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Colaborador",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Pontuação",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 2),
              // Lista de colaboradores
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: colaboradores.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                            colaboradores[index]["imagem"] ??
                                'assets/placeholder.png',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            colaboradores[index]["nome"] ??
                                "Nome não disponível",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        _getMedal(index),
                        SizedBox(width: 12),
                        Text("${colaboradores[index]["pontuacao"] ?? "0"}"),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 24),
              // Missões do mês
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF00358E),
                  borderRadius: BorderRadius.circular(12),
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
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Ação ao clicar no botão
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Ver missões"),
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
                      backgroundColor: Colors.white.withOpacity(0.3),
                      color: Colors.yellowAccent,
                      minHeight: 10,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Concluídas $missoesConcluidas/$totalMissoes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // NOVAEURO
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF00358E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#INOVAEURO Transforme ideias em recompensas!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Suas ideias podem valer muito! Participe dos programas de inovação, concorra a brindes e ganhe prêmios em dinheiro.",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Implementar navegação
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF00358E),
                        minimumSize: Size(double.infinity, 48),
                      ),
                      child: Text("Conheça nossos projetos"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
