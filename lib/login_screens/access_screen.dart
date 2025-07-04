import 'package:europro/data/repository/controller/access_controllers.dart';
import 'package:europro/data/repository/remote_usuario_repository.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:europro/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  final AccessControllers _controllers = AccessControllers();
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.akatab(
                    fontSize: 36,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Bem-Vindo(a)\n ao '),
                    TextSpan(
                      text: 'EuroPro',
                      style: GoogleFonts.akatab(
                        color: Color(0xFF00358E),
                        fontSize: 36, // Mantenha o tamanho consistente
                        fontWeight:
                            FontWeight.bold, // Opcional: se quiser negrito
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Campo Email
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.kufam(
                        fontSize: 16,
                        
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controllers.emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF00358E),
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Campo Senha
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Senha',
                      style: GoogleFonts.kufam(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controllers.senhaController,
                      obscureText: _esconderSenha,
                      decoration: InputDecoration(
                        hintText: 'Senha',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _esconderSenha = !_esconderSenha;
                            });
                          },
                          icon: Icon(
                            _esconderSenha
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF00358E),
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Link "Esqueceu sua senha?"
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Esqueceu sua senha?',
                    style: GoogleFonts.kufam(color: Color(0xFF00358E)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Botão Entrar
              Button(
                text:'Entrar',
                backgroundColor: const Color(0xFFFFF200),
                textColor: Colors.black,
                isBold: true,
                onPressed: () async {
                  final email = _controllers.emailController.text.trim();
                  final senha = _controllers.senhaController.text.trim();

                  if (email.isEmpty || senha.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          '⚠️ Por favor, preencha todos os campos',
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Color(0xFFFFF200),
                      ),
                    );
                    return;
                  }
                  try {
                    final usuarioRepo = RemoteUsuarioRepository(
                      client: Supabase.instance.client,
                    );

                    bool result = await usuarioRepo.findLoginUsuario(
                      email,
                      senha,
                    );

                    if (result) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RankingScreen(),
                        ),
                      );
                    }
                  } catch (e) {
                    String mensagemErro = e.toString().replaceAll(
                      'Exception: ',
                      '',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          mensagemErro,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
