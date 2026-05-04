import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.dashboardTeacher, style: AppTextStyles.h2(context)),
        actions: [
          IconButton(
            icon: Icon(Icons.person, size: 24.r),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_ind, size: 100.r, color: AppColors.secondary),
            SizedBox(height: 24.h),
            Text(
              AppStrings.teacherHomeMessage,
              style: AppTextStyles.bodyLarge(context),
            ),
          ],
        ),
      ),
    );
  }
}
