import 'package:europro/data/repository/remote_projeto_repository.dart';
import 'package:europro/domain/models/projeto.dart';
import 'package:europro/notification_screens/notification_screen.dart';
import 'package:europro/perfil_screens/perfil_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailProjects extends StatefulWidget {
  final Projeto projeto;

  const DetailProjects({Key? key, required this.projeto}) : super(key: key);

  @override
  State<DetailProjects> createState() => _MyProjectsState();
}


class _MyProjectsState extends State<DetailProjects> {
  
  final projetoRepo = RemoteProjetoRepository(client: Supabase.instance.client);

  String _formataData(DateTime data) {
    return DateFormat('dd/MM/yyyy').format(data);
  }

  List<Projeto> projetos = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
   final projeto = widget.projeto;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Image.asset('images/logoEuroPro.png', height: 40),
        centerTitle: true,
      ),
      drawer: TitleAndDrawer(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cabeçalho centralizado
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Meus projetos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                  Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                // Nome do projeto centralizado
                Text(
                  projeto.tipoProjeto == 1
                      ? 'Projeto Kaizen'
                      : projeto.tipoProjeto == 2
                      ? 'Projeto Clic'
                      : 'Projeto desconhecido',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00358E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Conteúdo em cards centralizados
              
                        // Título
                        const Text(
                          'Título:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          projeto.titulo,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Descrição
                        const Text(
                          'Descrição:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          projeto.descricao,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Detalhes
                        // ...projeto['detalhes'].map<Widget>((detalhe) => Padding(
                        //   padding: const EdgeInsets.only(bottom: 16),
                        //   child: Column(
                        //     children: [
                        //       Text(
                        //         detalhe['label'],
                        //         style: const TextStyle(
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //         textAlign: TextAlign.center,
                        //       ),
                        //       const SizedBox(height: 4),
                        //       Text(
                        //         detalhe['value'],
                        //         style: const TextStyle(fontSize: 16),
                        //         textAlign: TextAlign.center,
                        //       ),
                        //     ],
                        //   ),
                        // )).toList(),
                      ],
                    ),
                  ),
                ),
                //const SizedBox(height: 24),

                // Anexos
                // Card(
                //   child: Padding(
                //     padding: const EdgeInsets.all(16.0),
                //     child: Column(
                //       children: [
                //         const Text(
                //           'Anexos:',
                //           style: TextStyle(
                //             fontSize: 16,
                //             fontWeight: FontWeight.bold,
                //           ),
                //           textAlign: TextAlign.center,
                //         ),
                //         const SizedBox(height: 16),
                //         Column(
                //           children: projeto['anexos'].map<Widget>((arquivo) => ListTile(
                //             leading: const Icon(Icons.attach_file, color: Colors.grey),
                //             title: Text(arquivo, textAlign: TextAlign.center),
                //             onTap: () {
                //               ScaffoldMessenger.of(context).showSnackBar(
                //                 SnackBar(content: Text('Visualizar $arquivo')),
                //               );
                //             },
                //           )).toList(),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                //const SizedBox(height: 24),

                // Data de envio
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Enviado em: ${DateFormat('dd/MM/yyyy').format(projeto.dataInicio)}',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
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
