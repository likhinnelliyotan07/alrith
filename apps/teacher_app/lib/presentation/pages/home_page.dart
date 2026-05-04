import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

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
              (icon: Icons.book_outlined, activeIcon: Icons.book, label: 'Courses'),
              (icon: Icons.group_outlined, activeIcon: Icons.group, label: AppStrings.students),
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
      case 0: return AppStrings.dashboardTeacher;
      case 1: return AppStrings.myCourses;
      case 2: return 'My ${AppStrings.students}';
      case 3: return AppStrings.myProfile;
      default: return AppStrings.appName;
    }
  }

  Widget _buildBody(BuildContext context, int currentIndex) {
    switch (currentIndex) {
      case 0: return _buildHomeView(context);
      case 1: return _buildPlaceholder(context, 'Courses Content');
      case 2: return _buildPlaceholder(context, 'Students Content');
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
              gradient: AppColors.secondaryGradient,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello Teacher,', style: AppTextStyles.h2(context).copyWith(color: Colors.white)),
                SizedBox(height: 8.h),
                Text(AppStrings.teacherHomeMessage, style: AppTextStyles.bodyMedium(context).copyWith(color: Colors.white70)),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Text('Today\'s Schedule', style: AppTextStyles.h3(context)),
          SizedBox(height: 16.h),
          _buildScheduleItem(context, 'Mathematics 101', '09:00 AM', AppColors.primary),
          _buildScheduleItem(context, 'Physics Advanced', '11:30 AM', AppColors.accent),
          _buildScheduleItem(context, 'Staff Meeting', '02:00 PM', AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(BuildContext context, String title, String time, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLarge(context).copyWith(fontWeight: FontWeight.bold)),
                Text(time, style: AppTextStyles.bodySmall(context)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textSecondaryLight),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, String text) {
    return Center(child: Text(text, style: AppTextStyles.bodyLarge(context)));
  }
}
