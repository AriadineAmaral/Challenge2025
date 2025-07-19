import 'package:europro/data/repository/remote_notificacao_repository.dart';
import 'package:europro/domain/models/notificacao.dart';
import 'package:europro/perfil_screens/perfil_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notificaocesRepo = RemoteNotificacaoRepository(
    client: Supabase.instance.client,
  );

  List<Notificacao> notificacoes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _listNotificacoes();
  }

  void _listNotificacoes() async {
    final resultado = await notificaocesRepo.listNotificacoes();
    if (mounted) {
      setState(() {
        notificacoes = resultado;
        isLoading = false;
      });
    }
  }

  // Função para remover notificação
  void _removerNotificacao(int index) {
    setState(() {
      notificacoes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Notificações',
            style: GoogleFonts.akatab(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF00358E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RankingScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          // Usamos ListView.builder para lista dinâmica
          itemCount: notificacoes.length,
          itemBuilder: (context, index) {
            return _NotificacaoItem(
              texto: notificacoes[index].conteudo,
              data:
                  DateFormat(
                    'dd/MM/yyyy',
                  ).format(notificacoes[index].data).toString(),
              onRemover: () async {
                 notificaocesRepo.deleteNotificacao(
                  notificacoes[index].idNotificacao,
                );
                _removerNotificacao(index);
              },
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
        color: const Color(0xFF007BFF),
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
                style: GoogleFonts.kufam(
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
              style: GoogleFonts.kufam(color: Colors.white70, fontSize: 12),
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
