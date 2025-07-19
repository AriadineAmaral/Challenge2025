import 'package:flutter/material.dart';
import 'package:europro/notification_screens/notification_screen.dart';
import 'package:europro/perfil_screens/perfil_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: const Color(0xFF00358E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSimpleNavIcon(
            icon: Icons.notifications_none,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            ),
          ),
          _buildSimpleNavIcon(
            icon: Icons.home_outlined,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RankingScreen()),
            ),
          ),
          _buildSimpleNavIcon(
            icon: Icons.person_outline,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PerfilScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleNavIcon({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      iconSize: 25,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      constraints: const BoxConstraints(),
      onPressed: onPressed,
    );
  }
}
