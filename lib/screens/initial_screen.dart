import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:europro/screens/login_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _startExitAnimation = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(3.seconds, () async {
      // Adicionei async para melhor manutenção
      // Fase 1: Inicia animação de saída
      if (!mounted) return;
      setState(() => _startExitAnimation = true);

      // Fase 2: Navegação após animação
      await Future.delayed(1200.ms); // Espera explícita

      if (!mounted) return; // Verificação redundante (segurança extra)

      // Navegação ultra-segura com tratamento de erros
      try {
        await Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: 400.ms,
            pageBuilder: (_, __, ___) => const EuroProLoginScreen(),
            transitionsBuilder:
                (_, animation, __, child) => FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutQuad, // Suaviza o fade
                  ),
                  child: child,
                ),
          ),
        );
      } catch (e) {
        debugPrint('Erro na navegação: $e'); // Log seguro
      }
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF00358E),
    body: Stack(
      children: [
        // Conteúdo principal centralizado
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SizedBox(
                width: 250,
                height: 100,
                child: Stack(
                  children: [
                    _buildLogoSlice(0.3, 600.ms)
                        .animate(target: _startExitAnimation ? 1 : 0)
                        .then(delay: 200.ms)
                        .slideX(end: -2.0, duration: 800.ms, curve: Curves.easeInBack)
                        .fadeOut(duration: 500.ms)
                        .blurXY(end: 10.0),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Imagem no rodapé (garantido)
        if (_startExitAnimation)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Image.asset(
                'images/logoEuroFarma.png',
                width: 200,
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  width: 200,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 40),
                ),
              )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.5, end: 0.0),
            ),
          ),
      ],
    ),
  );
}

  Widget _buildLogoSlice(double widthFactor, Duration delay) {
    return Positioned.fill(
      child: ClipRect(
        child: Align(
          alignment: Alignment.centerRight,
          widthFactor: widthFactor,
          child: Image.asset(
                'images/logoEuroProWhite.png',
                width: 250,
                fit: BoxFit.contain,
              )
              .animate(delay: delay)
              .slideX(begin: 1.5, end: 0.0, duration: 500.ms)
              .fadeIn(duration: 600.ms),
        ),
      ),
    );
  }
}
