import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:arlith_core/services/supabase_service.dart';
import 'package:arlith_core/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:arlith_core/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:arlith_core/features/auth/domain/repositories/auth_repository.dart';
import 'package:arlith_core/features/user/domain/repositories/user_repository.dart';
import 'package:arlith_core/features/user/data/repositories/user_repository_impl.dart';
import 'package:arlith_core/features/education/domain/repositories/education_repository.dart';
import 'package:arlith_core/features/education/data/repositories/education_repository_impl.dart';
import 'package:arlith_core/core/theme/theme_cubit.dart';
import 'package:arlith_core/core/navigation/navigation_cubit.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureInjection() async {
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
  
  getIt.registerLazySingleton<EducationRepository>(
    () => EducationRepositoryImpl(getIt<SupabaseClient>()),
  );

  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerFactory<NavigationCubit>(() => NavigationCubit());
}
