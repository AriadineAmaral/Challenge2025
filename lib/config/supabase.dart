import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static init() async {
    await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL'),
      anonKey: const String.fromEnvironment('SUPABASE_KEY'),
    );
  }

  SupabaseClient get client => Supabase.instance.client;
}

