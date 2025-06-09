// title_drawer_widget.dart
import 'package:flutter/material.dart';

class TitleAndDrawer extends StatelessWidget {
  const TitleAndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 280,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 160, // Altura equivalente ao DrawerHeader
                  child: Stack(
                    children: [
                      // Conteúdo centralizado
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Color(0xFF00358E),
                              backgroundImage: AssetImage(
                                '',
                              ), // coloque seu caminho correto
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Seu Nome',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Seu Email',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Ícone no canto superior esquerdo
                      Positioned(
                        left: 16,
                        top: 16,
                        child: IconButton(
                          icon: Icon(Icons.menu, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
                // Restante dos itens do drawer...
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Meu Perfil'),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Alterar dados cadastrais'),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.track_changes),
                    title: Text('Missões'),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.emoji_events),
                    title: Text('Minha pontuação'),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.snippet_folder_rounded),
                    title: Text('Meus projetos'),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Novo projeto'),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    leading: Icon(Icons.leaderboard),
                    title: Text('Ranking de colaboradores'),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Desconectar'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
