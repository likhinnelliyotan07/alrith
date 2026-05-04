import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';
import 'package:arlith_core/widgets/user_edit_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(getIt<UserRepository>()),
        ),
        BlocProvider(
          create: (context) => EducationBloc(getIt<EducationRepository>())..add(LoadEducationData()),
        ),
      ],
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(AppStrings.myProfile, style: AppTextStyles.h2(context)),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                AppColors.primary.withOpacity(0.08),
                AppColors.secondary.withOpacity(0.08),
              ],
            ),
          ),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                final user = state.user;
                return SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: CircleAvatar(
                          radius: 60.r,
                          backgroundColor: Theme.of(context).cardColor,
                          child: Text(
                            user.fullName[0].toUpperCase(),
                            style: AppTextStyles.h1(context).copyWith(color: AppColors.primary),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(user.fullName, style: AppTextStyles.h2(context)),
                      Text(user.email, style: AppTextStyles.bodyMedium(context)),
                      SizedBox(height: 32.h),
                      
                      _buildInfoSection(context, user),
                      
                      SizedBox(height: 32.h),
                      const Divider(),
                      SizedBox(height: 24.h),
                      
                      _buildSettingsTile(
                        context,
                        'Dark Mode',
                        Icons.dark_mode_outlined,
                        trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                          builder: (context, mode) {
                            return Switch(
                              value: mode == ThemeMode.dark,
                              onChanged: (value) => context.read<ThemeCubit>().toggleTheme(),
                              activeColor: AppColors.primary,
                            );
                          },
                        ),
                      ),
                      
                      SizedBox(height: 24.h),
                      ArlithGradientButton(
                        text: AppStrings.logout,
                        onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
                      ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
        floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated && state.user.role == UserRole.candidate) {
              return FloatingActionButton.extended(
                onPressed: () => _showEditProfileDialog(context, state.user),
                label: const Text('Edit Profile'),
                icon: const Icon(Icons.edit_outlined),
                backgroundColor: AppColors.primary,
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, UserProfile user) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildInfoRow(context, AppStrings.profileRole, user.role.toString().split('.').last.toUpperCase()),
          if (user.phone != null) _buildInfoRow(context, AppStrings.profilePhone, user.phone!),
          if (user.classIds != null && user.classIds!.isNotEmpty) 
            _buildInfoRow(context, AppStrings.classes, user.classIds!.join(', ')),
          if (user.subjectIds != null && user.subjectIds!.isNotEmpty)
            _buildInfoRow(context, 'Subjects', user.subjectIds!.length.toString()),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium(context).copyWith(color: AppColors.textSecondaryLight)),
          Text(value, style: AppTextStyles.bodyLarge(context).copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, IconData icon, {Widget? trailing}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          SizedBox(width: 16.w),
          Expanded(child: Text(title, style: AppTextStyles.bodyLarge(context))),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, UserProfile user) {
    showDialog(
      context: context,
      builder: (dialogContext) => UserEditDialog(
        user: user,
        onSave: (updatedUser) {
          context.read<UserBloc>().add(UpdateUserProfileRequested(updatedUser));
          // Re-auth or refresh profile logic might be needed here
        },
      ),
    );
  }
}
