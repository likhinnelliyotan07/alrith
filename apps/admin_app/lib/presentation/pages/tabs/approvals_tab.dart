import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';

class ApprovalsTab extends StatelessWidget {
  const ApprovalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) return _buildShimmerList();
        if (state is UsersLoaded) {
          final pending = state.users.where((u) => u.role == UserRole.teacher && !u.isApproved).toList();
          if (pending.isEmpty) {
            return Center(
              child: Text(AppStrings.noPendingApprovals, style: AppTextStyles.bodyLarge(context)),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(20.w),
            itemCount: pending.length,
            itemBuilder: (context, index) {
              final user = pending[index];
              return UserCard(
                user: user,
                showApproval: true,
                onApprove: () {
                  context.read<UserBloc>().add(ApproveTeacherRequested(user.id));
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: ArlithShimmer.rectangular(height: 100.h),
      ),
    );
  }
}
