import 'package:europro/login_screens/initial_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ikxlfarvmokiwjfqqial.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlreGxmYXJ2bW9raXdqZnFxaWFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxNzAxOTUsImV4cCI6MjA2NDc0NjE5NX0.0b4EJzlHDDTD3m9pjYAVcjLNoOqjWWQJVw2WWBUb8dg',
  );

  // print(
  //   'URL do Supabase carregada: ${const String.fromEnvironment('SUPABASE_URL')}',
  // );
  // print(
  //   'Chave do Supabase carregada: ${const String.fromEnvironment('SUPABASE_KEY')}',
  // );
  runApp(const EuroProApp());
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
