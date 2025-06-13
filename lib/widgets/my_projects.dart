import 'package:europro/widgets/detail_projects.dart';
import 'package:flutter/material.dart';

class MyProjects extends StatefulWidget {
  const MyProjects({Key? key}) : super(key: key);

  @override
  State<MyProjects> createState() => _MeusProjetosScreenState();
}

class _MeusProjetosScreenState extends State<MyProjects> {
  // Lista de projetos (será populada quando enviar da outra tela)
  final List<Projeto> _projetos = [
    Projeto(
      nome: 'Projeto Kaizen',
      status: 'análise e seleção',
      dataEnvio: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Projeto(
      nome: 'Projeto Clic',
      status: 'desenvolvimento',
      dataEnvio: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Projeto(
      nome: 'Projeto Kaizen',
      status: 'finalizado',
      dataEnvio: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Projeto(
      nome: 'Projeto Kaizen',
      status: 'finalizado',
      dataEnvio: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: const Text(
          'EuroPro',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com botão voltar e título
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Meus projetos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Lista de projetos
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _projetos.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final projeto = _projetos[index];
                return _ProjetoCard(
                  projeto: projeto,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailProjects(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjetoCard extends StatelessWidget {
  final Projeto projeto;
  final VoidCallback onTap;

  const _ProjetoCard({required this.projeto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  projeto.nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  // Adicionado Flexible no status
                  child: Text(
                    'Status: ${_capitalize(projeto.status)}',
                    style: TextStyle(
                      color: _getStatusColor(projeto.status),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Garante que nunca terá overflow
                  ),
                ),
                const SizedBox(width: 8), // Espaço reduzido
                Flexible(
                  // Adicionado Flexible na data
                  child: Text(
                    'Enviado em ${_formatDate(projeto.dataEnvio)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'análise e seleção':
        return Colors.orange;
      case 'desenvolvimento':
        return Colors.blue;
      case 'finalizado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Modelo de dados para os projetos
class Projeto {
  final String nome;
  final String status;
  final DateTime dataEnvio;

  Projeto({required this.nome, required this.status, required this.dataEnvio});
}
