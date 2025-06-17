import 'package:europro/notification_screens/notification_screen.dart';
import 'package:europro/projects_screens/my_projects_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:europro/rewards_and_missions_screens/rewards_screen.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Image.asset('images/logoEuroPro.png', height: 40),
      ),
      drawer: TitleAndDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 7, right: 16),
              child: Row(
                children: [
                  IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
                  Spacer(),
                ],
              ),
            ),
            SizedBox(height: 10),
            CircleAvatar(radius: 50, backgroundColor: Colors.grey[300]),
            SizedBox(height: 8),
            Text(
              'editar foto',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Maria Fernandes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'maria.fernandes@gmail.com',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildProfileButton(Icons.email_outlined, 'alterar\nemail', () {
                    _showAlterarEmailDialog(context);
                  }),
                  _buildProfileButton(Icons.lock_reset_outlined, 'redefinir\nsenha', () {
                    _showRedefinirSenhaDialog(context);
                  }),
                  _buildProfileButton(
                    Icons.emoji_events_outlined,
                    'minha\npontuação',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RewardsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildProfileButton(Icons.assignment_outlined, 'meus\nprojetos', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyProjects()),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.logout, color: Colors.black),
                label: Text(
                  'desconectar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
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

  Widget _buildProfileButton(IconData icon, String text, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF00358E),
        padding: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 50),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  //funcionalidade do botão de email
  void _showAlterarEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ), // Margem para telas pequenas
          contentPadding: EdgeInsets.all(16),
          titlePadding: EdgeInsets.only(left: 16, right: 8, top: 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Alterar email de cadastro', style: TextStyle(fontSize: 16)),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email atual',
                    hintText: 'Informe o seu email atual',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Novo email',
                    hintText: 'Informe o novo email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'alterar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //funcionalidade do botão de senha
  void _showRedefinirSenhaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          contentPadding: EdgeInsets.all(16),
          titlePadding: EdgeInsets.only(left: 16, right: 8, top: 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Redefinir a senha', style: TextStyle(fontSize: 16)),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Senha atual',
                    hintText: 'Informe a sua senha atual',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nova senha',
                    hintText: 'Informe a sua nova senha',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Confirme a nova senha',
                    hintText: 'Confirme a nova senha',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'redefinir',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
