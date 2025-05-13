import 'package:europro/screens/access_screen.dart';
import 'package:europro/screens/login_screen.dart';
import 'package:europro/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CompleteSignUpScreen extends StatefulWidget {
  const CompleteSignUpScreen({super.key});

  @override
  State<CompleteSignUpScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<CompleteSignUpScreen> {
  bool _esconderSenha = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 45, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: 'Bem-Vindo(a)\n ao '),
                    TextSpan(
                      text: 'EuroPro',
                      style: TextStyle(color: Color(0xFF00358E)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.check_rounded, size: 80, color: Colors.green,)
                  .animate() 
                  .rotate(
                    // Animação de rotação
                    duration: 2.seconds, 
                    curve: Curves.elasticOut, 
                    begin: 0, 
                    end: 1, 
                  ),
              const SizedBox(height: 10),
              // Botão Entrar
              Button(
                text: 'Entrar',
                backgroundColor: const Color(0xFFFFF200),
                textColor: Colors.black,
                isBold: true,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AccessScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
