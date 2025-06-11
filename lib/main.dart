import 'package:europro/config/dependencies.dart';
import 'package:europro/config/supabase.dart';
import 'package:europro/login_screens/initial_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  await SupabaseConfig.init();

  print('URL do Supabase carregada: ${const String.fromEnvironment('SUPABASE_URL')}');
  print('Chave do Supabase carregada: ${const String.fromEnvironment('SUPABASE_KEY')}');
  runApp(MultiProvider(providers: providersLocal, child: const EuroProApp()));
  
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
