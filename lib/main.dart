// lib/main.dart
import 'package:europro/login_screens/initial_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(EuroProApp());
}

class EuroProApp extends StatelessWidget {
  const EuroProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InitialScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
