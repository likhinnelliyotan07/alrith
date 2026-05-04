import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        int teacherCount = 0;
        int studentCount = 0;
        int parentCount = 0;
        int pendingCount = 0;

        if (state is UsersLoaded) {
          teacherCount = state.users.where((u) => u.role == UserRole.teacher).length;
          studentCount = state.users.where((u) => u.role == UserRole.candidate).length;
          parentCount = state.users.where((u) => u.role == UserRole.parent).length;
          pendingCount = state.users.where((u) => u.role == UserRole.teacher && !u.isApproved).length;
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(context),
              SizedBox(height: 32.h),
              Text(AppStrings.quickStats, style: AppTextStyles.h3(context)),
              SizedBox(height: 16.h),
              Row(
                children: [
                  _StatCard(label: AppStrings.teachers, value: teacherCount.toString(), color: AppColors.primary),
                  SizedBox(width: 16.w),
                  _StatCard(label: AppStrings.students, value: studentCount.toString(), color: AppColors.secondary),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  _StatCard(label: AppStrings.parents, value: parentCount.toString(), color: AppColors.accent),
                  SizedBox(width: 16.w),
                  _StatCard(label: AppStrings.pendingApprovalsCount, value: pendingCount.toString(), color: AppColors.warning),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.getDynamicPrimaryGradient(context),
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
          Text(
            '${AppStrings.welcome} ${AppStrings.roleAdmin},',
            style: AppTextStyles.h2(context).copyWith(color: Colors.white),
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.teacherHomeMessage,
            style: AppTextStyles.bodyMedium(context).copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: color.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                value,
                style: AppTextStyles.h2(context).copyWith(color: color, fontSize: 24.sp),
              ),
            ),
            SizedBox(height: 8.h),
            Text(label, style: AppTextStyles.bodySmall(context).copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
