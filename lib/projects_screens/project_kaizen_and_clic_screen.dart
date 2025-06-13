import 'package:europro/widgets/projects.dart';
import 'package:flutter/material.dart';

class ProjectKaizenAndClicScreen extends StatelessWidget {
  const ProjectKaizenAndClicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(), // se tiver
      appBar: AppBar(
        title: Text("Projetos de inovação"),
      ),
      body: Projects(),
    );
  }
}