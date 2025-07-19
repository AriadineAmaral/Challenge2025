import 'package:flutter/material.dart';

class PerfilScreenController {
  final TextEditingController emailAtualController = TextEditingController();
  final TextEditingController novoEmailController = TextEditingController();
  final TextEditingController senhaAtualController = TextEditingController();
  final TextEditingController novaSenhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();

  void dispose() {
    emailAtualController.dispose();
    novaSenhaController.dispose();
    senhaAtualController.dispose();
    confirmarSenhaController.dispose();
    novoEmailController.dispose();
  }
}
