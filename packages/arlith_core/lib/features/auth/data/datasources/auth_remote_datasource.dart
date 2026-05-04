import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../models/user_profile.dart';

abstract class AuthRemoteDataSource {
  Future<UserProfile> login(String email, String password);
  Future<void> signInWithPhone(String phone);
  Future<UserProfile?> verifyOTP(String phone, String token);
  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
  });
  Future<void> logout();
  Future<UserProfile?> getCurrentUser();
  Stream<UserProfile?> get authStateChanges;
}

class SupabaseAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final supabase.SupabaseClient _client;

  SupabaseAuthRemoteDataSourceImpl(this._client);

  @override
  Future<UserProfile> login(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) throw Exception('Login failed');
    return _getUserProfile(response.user!.id);
  }

  @override
  Future<void> signInWithPhone(String phone) async {
    await _client.auth.signInWithOtp(phone: phone);
  }

  @override
  Future<UserProfile?> verifyOTP(String phone, String token) async {
    final response = await _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: supabase.OtpType.sms,
    );
    
    if (response.user == null) throw Exception('OTP Verification failed');
    
    try {
      return await _getUserProfile(response.user!.id);
    } catch (e) {
      // Profile not found, return null so we can redirect to signup
      return null;
    }
  }

  @override
  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
  }) async {
    // Check if user already exists in Auth but has no profile
    final currentUser = _client.auth.currentUser;
    String userId;
    
    if (currentUser != null && (currentUser.email == email || currentUser.phone == phone)) {
      userId = currentUser.id;
    } else {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'role': role, 'phone': phone},
      );
      if (response.user == null) throw Exception('Signup failed');
      userId = response.user!.id;
    }
    
    final profile = {
      'id': userId,
      'email': email,
      'full_name': fullName,
      'role': role,
      'phone': phone,
      'created_at': DateTime.now().toIso8601String(),
    };
    
    await _client.from('profiles').upsert(profile);
    return UserProfile.fromJson(profile);
  }

  @override
  Future<void> logout() => _client.auth.signOut();

  @override
  Future<UserProfile?> getCurrentUser() async {
    final session = _client.auth.currentSession;
    if (session == null) return null;
    try {
      return await _getUserProfile(session.user.id);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<UserProfile?> get authStateChanges {
    return _client.auth.onAuthStateChange.asyncMap((event) async {
      final session = event.session;
      if (session == null) return null;
      try {
        return await _getUserProfile(session.user.id);
      } catch (e) {
        return null;
      }
    });
  }

  Future<UserProfile> _getUserProfile(String id) async {
    final data = await _client.from('profiles').select().eq('id', id).single();
    return UserProfile.fromJson(data);
  }
}
