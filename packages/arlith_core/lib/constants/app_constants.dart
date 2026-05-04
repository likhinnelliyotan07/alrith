import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get supabaseUrl => dotenv.get('SUPABASE_URL', fallback: 'https://fsgrrmnlcnjdfwgvsvqz.supabase.co');
  static String get supabaseAnonKey => dotenv.get('SUPABASE_ANON_KEY', fallback: '');

  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
}
