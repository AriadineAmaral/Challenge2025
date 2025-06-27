import 'package:flutter/material.dart';

class ProjectKaizenClicControllers {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  

  void dispose() {
    tituloController.dispose();
    descricaoController.dispose();
    
  }
}