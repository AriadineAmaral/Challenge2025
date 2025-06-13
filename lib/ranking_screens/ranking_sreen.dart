import 'package:europro/data/repository/remote_colaborador_repository.dart';
import 'package:europro/domain/models/colaborador.dart';
import 'package:europro/widgets/button.dart';
import 'package:europro/widgets/projects.dart';
import 'package:flutter/material.dart';
import 'package:europro/widgets/title_and_drawer.dart';
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

  List<Colaborador> colaboradores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _findColaboradores();
  }

  Future<void> _findColaboradores() async {
    try {
      final resultado = await colaboradorRepo.listRankingColaborador();
      setState(() {
        colaboradores = resultado;
        isLoading = false;
      });
    } catch (e) {
      //print("Erro ao buscar colaboradores: $e");
      setState(() {
        isLoading = false;
      });
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
          height: 40,
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
              // Lista de colaboradores com rolagem própria
              Container(
                height: 300, // Aproximadamente 6 itens visíveis
                child: ListView.builder(
                  itemCount: colaboradores.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            // backgroundImage: AssetImage(
                            //   colaboradores[index]["imagem"] ?? 'assets/placeholder.png',
                            // ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              colaboradores[index].nome,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          _getMedal(index),
                          SizedBox(width: 12),
                          Text("${colaboradores[index].pontuacao}"),
                        ],
                      ),
                    );
                  },
                ),
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
                      backgroundColor: Color(0x4D0000FF),
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
                              style: TextStyle(color: Color(0xFF00358E)),
                            ),
                            TextSpan(
                              text: " Transforme ideias em recompensas!",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Projects())
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
    );
  }
}
