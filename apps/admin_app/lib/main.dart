import 'package:flutter/material.dart';
import 'package:arlith_core/arlith_core.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(getIt<AuthRepository>())..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => UserBloc(getIt<UserRepository>())..add(LoadAllUsers()),
        ),
        BlocProvider(
          create: (context) => EducationBloc(getIt<EducationRepository>())..add(LoadEducationData()),
        ),
        BlocProvider(
          create: (context) => getIt<ThemeCubit>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                title: AppStrings.appName,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                routerConfig: AppRouter.router,
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
