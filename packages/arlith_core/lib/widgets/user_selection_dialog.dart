import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../arlith_core.dart';

class UserSelectionDialog extends StatelessWidget {
  final String title;
  final String role;
  final Function(UserProfile) onSelected;

  const UserSelectionDialog({
    super.key,
    required this.title,
    required this.role,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(getIt<UserRepository>())..add(LoadUsersByRole(role)),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Container(
          padding: EdgeInsets.all(20.w),
          height: 500.h,
          child: Column(
            children: [
              Text(title, style: AppTextStyles.h3(context)),
              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is UsersLoaded) {
                      final users = state.users;
                      if (users.isEmpty) {
                        return Center(child: Text('No users found for this role.'));
                      }
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ListTile(
                            title: Text(user.fullName),
                            subtitle: Text(user.email),
                            onTap: () {
                              onSelected(user);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    }
                    if (state is UserError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
