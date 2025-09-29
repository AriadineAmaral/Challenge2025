import 'package:flutter/material.dart';

class AccessControllers {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  void dispose() {
    emailController.dispose();
    senhaController.dispose();
  }
}