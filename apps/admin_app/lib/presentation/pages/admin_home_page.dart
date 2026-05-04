import 'package:flutter/material.dart';
import 'package:arlith_core/arlith_core.dart';
import 'package:arlith_core/features/user/presentation/pages/profile_page.dart';
import 'tabs/approvals_tab.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/education_tab.dart';
import 'tabs/users_tab.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: const _AdminHomeScaffold(),
    );
  }
}

class _AdminHomeScaffold extends StatelessWidget {
  const _AdminHomeScaffold();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return DashboardScaffold(
          title: _getTitle(currentIndex),
          currentIndex: currentIndex,
          onNavTap: (index) => context.read<NavigationCubit>().setIndex(index),
          navItems: const [
            (icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: AppStrings.navigationHome),
            (icon: Icons.how_to_reg_outlined, activeIcon: Icons.how_to_reg, label: AppStrings.approve),
            (icon: Icons.school_outlined, activeIcon: Icons.school, label: AppStrings.classes),
            (icon: Icons.people_outline, activeIcon: Icons.people, label: AppStrings.navigationUsers),
            (icon: Icons.person_outline, activeIcon: Icons.person, label: AppStrings.navigationProfile),
          ],
          floatingActionButton: currentIndex == 2 ? _buildEducationFAB(context) : null,
          body: _buildBody(currentIndex),
        );
      },
    );
  }

  String _getTitle(int currentIndex) {
    switch (currentIndex) {
      case 0: return AppStrings.dashboardAdmin;
      case 1: return AppStrings.pendingApprovals;
      case 2: return AppStrings.classes;
      case 3: return AppStrings.allUsers;
      case 4: return AppStrings.myProfile;
      default: return AppStrings.appName;
    }
  }

  Widget _buildBody(int currentIndex) {
    switch (currentIndex) {
      case 0: return const DashboardTab();
      case 1: return const ApprovalsTab();
      case 2: return const EducationTab();
      case 3: return const UsersTab();
      case 4: return const ProfilePage();
      default: return const SizedBox();
    }
  }

  Widget _buildEducationFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {}, // Implementation moved to shared logic
      backgroundColor: AppColors.primary,
      child: Container(
        width: 60, height: 60,
        decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
