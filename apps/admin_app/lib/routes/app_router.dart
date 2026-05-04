import 'package:flutter/material.dart';
import 'package:arlith_core/arlith_core.dart';
import 'package:go_router/go_router.dart';
import '../presentation/pages/admin_home_page.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthWrapper(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(
          role: 'Admin',
          onLoginSuccess: () => context.go('/home'),
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          final phone = state.extra as String?;
          return SignupPage(
            role: 'Admin',
            onSignupSuccess: () => context.go('/home'),
            initialPhone: phone,
          );
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const AdminHomePage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          if (state.user.role != UserRole.admin && state.user.role != UserRole.superAdmin) {
            return const Scaffold(
              body: Center(child: Text('Unauthorized: Only Admins can access this app.')),
            );
          }
          return const AdminHomePage();
        }
        return LoginPage(role: 'Admin', onLoginSuccess: () => context.go('/home'));
      },
    );
  }
}
