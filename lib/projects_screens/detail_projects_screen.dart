import 'package:europro/data/repository/remote_projeto_repository.dart';
import 'package:europro/domain/models/projeto.dart';
import 'package:europro/projects_screens/my_projects_screen.dart';
import 'package:europro/widgets/footer.dart';
import 'package:europro/widgets/header.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailProjects extends StatefulWidget {
  final Projeto projeto;

  const DetailProjects({Key? key, required this.projeto}) : super(key: key);

  @override
  State<DetailProjects> createState() => _MyProjectsState();
}

class _MyProjectsState extends State<DetailProjects> {
  final projetoRepo = RemoteProjetoRepository(client: Supabase.instance.client);

  @override
  void initState() {
    super.initState();
    carregarArquivos(); // Aqui você carrega os arquivos ao abrir a tela
  }

  String _formataData(DateTime data) {
    return DateFormat('dd/MM/yyyy').format(data);
  }

  Future<void> carregarArquivos() async {
    try {
      final resultado = await projetoRepo.buscarArquivosDoProjeto(
        widget.projeto.idProjeto,
      );
      setState(() {
        arquivos = resultado;
      });
    } catch (e) {
      print('Erro ao carregar arquivos: $e');
    }
  }

  List<Projeto> projetos = [];
  bool isLoading = true;

  List<Map<String, dynamic>> arquivos = [];

  @override
  Widget build(BuildContext context) {
    final projeto = widget.projeto;
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
      ),
      drawer: TitleAndDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Header(
                titulo: 'Meus projetos',
                destinoAoVoltar: MyProjects(),
                backgroundColor: Colors.transparent,
                textColor: Colors.black,
                height: 30,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Color(0xFFF8F9FA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Melhor alinhamento interno
                  children: [
                    Center(
                      // Nome do projeto centralizado
                      child: Text(
                        projeto.tipoProjeto == 1
                            ? 'Projeto Kaizen'
                            : projeto.tipoProjeto == 2
                            ? 'Projeto Clic'
                            : 'Projeto desconhecido',
                        style: GoogleFonts.akatab(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF00358E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Título:',
                      style: GoogleFonts.akatab(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      projeto.titulo,
                      style: GoogleFonts.kufam(fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Descrição:',
                      style: GoogleFonts.akatab(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      projeto.descricao,
                      style: GoogleFonts.kufam(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Data de envio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Enviado em: ${DateFormat('dd/MM/yyyy').format(projeto.dataInicio)}',
                style: GoogleFonts.kufam(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Arquivos anexados:',
                style: GoogleFonts.akatab(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...arquivos.map((arquivo) {
              final nomeArquivo = arquivo['nome_arquivo'];
              final caminho = arquivo['caminho'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(nomeArquivo),
                  subtitle: Text(caminho),
                  trailing: Wrap(
                    spacing: 12,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () async {
                          final uri = Uri.parse(caminho);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Não foi possível abrir o arquivo',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Footer(),
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
