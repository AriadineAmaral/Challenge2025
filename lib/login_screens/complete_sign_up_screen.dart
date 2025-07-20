import 'package:europro/login_screens/access_screen.dart';
import 'package:europro/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteSignUpScreen extends StatefulWidget {
  const CompleteSignUpScreen({super.key});

  @override
  State<CompleteSignUpScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<CompleteSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                  style: GoogleFonts.kronaOne(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Cadastro concluído com sucesso!'),                  
                  ],
                ),
              ),
              Icon(Icons.check_rounded, size: 80, color: Colors.green),
                  
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
