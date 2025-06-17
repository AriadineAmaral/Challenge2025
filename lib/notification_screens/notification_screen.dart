import 'package:europro/perfil_screens/perfil_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  // Mudamos para StatefulWidget
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Lista de notificações que pode ser modificada
  final List<Map<String, String>> _notificacoes = [
    {
      'texto': 'Parabéns, você acaba de concluir mais uma missão!',
      'data': '30/04/2025',
    },
    {'texto': 'Veja as novidades da Eurofarma', 'data': '25/04/2025'},
    {
      'texto': 'Parabéns, você acaba de concluir mais uma missão!',
      'data': '17/04/2025',
    },
  ];

  // Função para remover notificação
  void _removerNotificacao(int index) {
    setState(() {
      _notificacoes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notificações',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF00358E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          // Usamos ListView.builder para lista dinâmica
          itemCount: _notificacoes.length,
          itemBuilder: (context, index) {
            return _NotificacaoItem(
              texto: _notificacoes[index]['texto']!,
              data: _notificacoes[index]['data']!,
              onRemover:
                  () => _removerNotificacao(
                    index,
                  ), // Passamos a função de remover
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: const Color(0xFF00358E),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.home_outlined, color: Colors.white),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RankingScreen()),
                  ),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
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

class _NotificacaoItem extends StatelessWidget {
  final String texto;
  final String data;
  final VoidCallback onRemover;

  const _NotificacaoItem({
    required this.texto,
    required this.data,
    required this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF00358E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          // Texto principal
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                texto,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // Data no canto inferior direito
          Positioned(
            bottom: 0,
            right: 0,
            child: Text(
              data,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),

          // Botão de fechar com efeito de toque
          Positioned(
            top: -15,
            right: -15,
            child: InkWell(
              onTap: onRemover,
              borderRadius: BorderRadius.circular(20), // Área de toque circular
              splashColor: Color(0x4DFFFFFF), // Cor do efeito
              highlightColor: Colors.transparent, // Sem cor de destaque
              child: const Padding(
                padding: EdgeInsets.all(14), // Área de toque maior
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
