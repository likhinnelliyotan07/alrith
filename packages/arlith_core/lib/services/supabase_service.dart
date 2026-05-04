import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';
import '../utils/app_logger.dart';

class SupabaseService {
  static Future<void> init() async {
    try {
      // Load environment variables from assets/.env
      await dotenv.load(fileName: ".env");
      
      await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        anonKey: AppConstants.supabaseAnonKey,
      );
      AppLogger.i('Supabase Initialized');
    } catch (e, stack) {
      AppLogger.e('Failed to initialize Supabase', e, stack);
    }
  }

  SupabaseClient get client => Supabase.instance.client;
  GoTrueClient get auth => client.auth;
}
