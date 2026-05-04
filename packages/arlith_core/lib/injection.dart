import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/supabase_service.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/user/domain/repositories/user_repository.dart';
import 'features/user/data/repositories/user_repository_impl.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureInjection() async {
  // Manual registration for now to keep it simple, or use injectable_generator
  // For the sake of this demo, I'll do some manual setup if needed, 
  // but I'll set up the infrastructure for injectable.
  
  final supabaseService = SupabaseService();
  await SupabaseService.init();
  
  getIt.registerLazySingleton<SupabaseClient>(() => supabaseService.client);
  
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => SupabaseAuthRemoteDataSourceImpl(getIt<SupabaseClient>()),
  );
  
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<SupabaseClient>()),
  );
}
