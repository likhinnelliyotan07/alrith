import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../arlith_core.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.myProfile, style: AppTextStyles.h2(context)),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 50.r, color: Colors.white),
                  ),
                  SizedBox(height: 24.h),
                  _ProfileItem(label: AppStrings.profileName, value: user.fullName),
                  _ProfileItem(label: AppStrings.profileEmail, value: user.email),
                  _ProfileItem(label: AppStrings.profilePhone, value: user.phone ?? 'Not provided'),
                  _ProfileItem(label: AppStrings.profileRole, value: user.role.name.toUpperCase()),
                  SizedBox(height: 40.h),
                  ArlithButton(
                    text: AppStrings.logout,
                    color: AppColors.error,
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                    },
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyLarge(context).copyWith(fontWeight: FontWeight.bold)),
          Text(value, style: AppTextStyles.bodyMedium(context)),
        ],
      ),
    );
  }
}
