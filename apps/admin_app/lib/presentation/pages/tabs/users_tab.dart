import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';
import 'package:arlith_core/widgets/user_edit_dialog.dart';
import '../user_detail_page.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) return _buildShimmerList();
          if (state is UsersLoaded) {
            return ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserCard(
                  user: user,
                  onEdit: () => _navigateToDetail(context, user),
                  onAssignTeacher: user.role == UserRole.candidate ? () => _navigateToDetail(context, user) : null,
                  onAssignClass: user.role == UserRole.candidate ? () => _navigateToDetail(context, user) : null,
                );
              },
            );
          }
          return const SizedBox();
        },

    );
  }

  void _navigateToDetail(BuildContext context, UserProfile user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserDetailPage(user: user),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: ArlithShimmer.rectangular(height: 120.h),
      ),
    );
  }

  void _showEditDialog(BuildContext context, UserProfile user) {
    showDialog(
      context: context,
      builder: (dialogContext) => UserEditDialog(
        user: user,
        onSave: (updated) {
          context.read<UserBloc>().add(UpdateUserProfileRequested(updated));
        },
      ),
    );
  }
}
