// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../widgets/button.dart';

class EuroProLoginScreen extends StatelessWidget {
  const EuroProLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logoEuroPro.png',
                width: 250,
              ),
              SizedBox(height: 80),
              Button(
                text: 'Acessar conta',
                backgroundColor:const Color(0xFF00358E),
                textColor: Colors.white,
                onPressed: () {},
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Primeiro acesso?',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              SizedBox(height: 8),
              Button(
                text: 'Criar conta',
                backgroundColor:const Color(0xFFFFF200),
                textColor: Colors.black,
                isBold: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
