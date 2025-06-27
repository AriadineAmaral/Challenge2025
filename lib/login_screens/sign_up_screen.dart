import 'package:europro/data/repository/controller/sign_up_controllers.dart';
import 'package:europro/data/repository/remote_usuario_repository.dart';
import 'package:europro/login_screens/complete_sign_up_screen.dart';
import 'package:europro/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<SignUpScreen> {
  final SignUpControllers _controllers = SignUpControllers();
  bool _esconderSenha = true;

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

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
              const SizedBox(height: 40),
              // Campo Email
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
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
              const SizedBox(height: 2),
              // Campo Senha
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Senha',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _controllers.senhaController,
                      obscureText: _esconderSenha,
                      decoration: InputDecoration(
                        hintText: 'Crie uma senha',
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

              const SizedBox(height: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confirme a senha',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _controllers.confirmarSenhaController,
                      obscureText: _esconderSenha,
                      decoration: InputDecoration(
                        hintText: 'Repita a senha',
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
              const SizedBox(height: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CPF',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _controllers.cpfController,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Digite seu CPF',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Botão Entrar
              Button(
                text: 'Criar conta',
                backgroundColor: const Color(0xFF00358E),
                textColor: Colors.white,
                isBold: true,
                onPressed: () async {
                  final email = _controllers.emailController.text.trim();
                  final senha = _controllers.senhaController.text.trim();
                  final confirmarSenha =
                      _controllers.confirmarSenhaController.text.trim();
                  final cpf =
                      _controllers.cpfController.text
                          .replaceAll(RegExp(r'\D'), '')
                          .trim();

                  if (email.isEmpty ||
                      senha.isEmpty ||
                      confirmarSenha.isEmpty ||
                      cpf.isEmpty) {
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

                  if (senha != confirmarSenha) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          '⚠️ As senhas não coincidem',
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

                    // final novoUsuario = Usuario(
                    //   idColaborador: null,
                    //   email: email,
                    //   senha: senha,
                    // );

                    //await usuarioRepo.addUsuario(novoUsuario, cpf);

                    await usuarioRepo.addUsuario(email, senha, cpf);


                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompleteSignUpScreen(),
                      ),
                    );
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
