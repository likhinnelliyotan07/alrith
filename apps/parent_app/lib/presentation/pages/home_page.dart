import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return DashboardScaffold(
            title: _getTitle(currentIndex),
            currentIndex: currentIndex,
            onNavTap: (index) => context.read<NavigationCubit>().setIndex(index),
            navItems: const [
              (icon: Icons.home_outlined, activeIcon: Icons.home, label: AppStrings.navigationHome),
              (icon: Icons.child_care_outlined, activeIcon: Icons.child_care, label: 'My Child'),
              (icon: Icons.payment_outlined, activeIcon: Icons.payment, label: 'Fees'),
              (icon: Icons.person_outline, activeIcon: Icons.person, label: AppStrings.navigationProfile),
            ],
            body: _buildBody(context, currentIndex),
          );
        },
      ),
    );
  }

  String _getTitle(int currentIndex) {
    switch (currentIndex) {
      case 0: return AppStrings.dashboardParent;
      case 1: return 'Child Progress';
      case 2: return 'Fee Management';
      case 3: return AppStrings.myProfile;
      default: return AppStrings.appName;
    }
  }

  Widget _buildBody(BuildContext context, int currentIndex) {
    switch (currentIndex) {
      case 0: return _buildHomeView(context);
      case 1: return _buildPlaceholder(context, 'Child Progress Content');
      case 2: return _buildPlaceholder(context, 'Fees Content');
      case 3: return const ProfilePage();
      default: return const SizedBox();
    }
  }

  Widget _buildHomeView(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello Parent,', style: AppTextStyles.h2(context).copyWith(color: Colors.white)),
                SizedBox(height: 8.h),
                Text(AppStrings.parentHomeMessage, style: AppTextStyles.bodyMedium(context).copyWith(color: Colors.white70)),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Text('Recent Notifications', style: AppTextStyles.h3(context)),
          SizedBox(height: 16.h),
          _buildNotificationCard(context, 'New Grade Posted', 'Mathematics Chapter 3 test result is out.', '10 min ago'),
          _buildNotificationCard(context, 'Fee Reminder', 'Monthly tuition fee is due on 10th May.', '2 hours ago'),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, String title, String subtitle, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.bodyLarge(context).copyWith(fontWeight: FontWeight.bold)),
              Text(time, style: AppTextStyles.bodySmall(context).copyWith(color: AppColors.textSecondaryLight)),
            ],
          ),
          SizedBox(height: 4.h),
          Text(subtitle, style: AppTextStyles.bodyMedium(context)),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, String text) {
    return Center(child: Text(text, style: AppTextStyles.bodyLarge(context)));
  }
}
