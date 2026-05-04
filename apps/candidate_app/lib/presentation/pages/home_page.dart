import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';

class CandidateHomePage extends StatelessWidget {
  const CandidateHomePage({super.key});

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
              (icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: AppStrings.navigationLearning),
              (icon: Icons.analytics_outlined, activeIcon: Icons.analytics, label: AppStrings.navigationProgress),
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
      case 0: return AppStrings.dashboardCandidate;
      case 1: return AppStrings.myCourses;
      case 2: return AppStrings.learningProgress;
      case 3: return AppStrings.myProfile;
      default: return AppStrings.appName;
    }
  }

  Widget _buildBody(BuildContext context, int currentIndex) {
    switch (currentIndex) {
      case 0: return _buildHomeView(context);
      case 1: return _buildPlaceholder(context, AppStrings.coursesContent);
      case 2: return _buildPlaceholder(context, AppStrings.progressContent);
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
              gradient: AppColors.getDynamicAccentGradient(context),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${AppStrings.hello} Student,', style: AppTextStyles.h2(context).copyWith(color: Colors.white)),
                SizedBox(height: 8.h),
                Text(AppStrings.welcomeMessage, style: AppTextStyles.bodyMedium(context).copyWith(color: Colors.white70)),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Text(AppStrings.continueLearning, style: AppTextStyles.h3(context)),
          SizedBox(height: 16.h),
          _buildCourseCard(context, 'Mathematics', 'Chapter 4: Algebra', 0.6),
          _buildCourseCard(context, 'Science', 'Chapter 2: Physics', 0.3),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, String title, String chapter, double progress) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.bodyLarge(context).copyWith(fontWeight: FontWeight.bold)),
              Text('${(progress * 100).toInt()}%', style: AppTextStyles.bodySmall(context).copyWith(color: AppColors.primary)),
            ],
          ),
          SizedBox(height: 4.h),
          Text(chapter, style: AppTextStyles.bodySmall(context).copyWith(color: AppColors.textSecondaryLight)),
          SizedBox(height: 12.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, String text) {
    return Center(child: Text(text, style: AppTextStyles.bodyLarge(context)));
  }
}
