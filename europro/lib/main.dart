// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(EuroProApp());
}

class EuroProApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EuroPro',
      home: EuroProLoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
