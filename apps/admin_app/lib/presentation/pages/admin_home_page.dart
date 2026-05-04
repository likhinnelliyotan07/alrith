import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(getIt<UserRepository>())..add(LoadPendingTeachers()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.dashboardAdmin, style: AppTextStyles.h2(context)),
          actions: [
            IconButton(
              icon: Icon(Icons.person, size: 24.r),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                AppStrings.pendingApprovals,
                style: AppTextStyles.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is UsersLoaded) {
                    if (state.users.isEmpty) {
                      return Center(
                        child: Text(AppStrings.noPendingApprovals, style: AppTextStyles.bodyMedium(context)),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.users.length,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12.h),
                          child: ListTile(
                            title: Text(user.fullName, style: AppTextStyles.bodyLarge(context)),
                            subtitle: Text(user.email, style: AppTextStyles.bodyMedium(context)),
                            trailing: SizedBox(
                              width: 100.w,
                              child: ArlithButton(
                                text: AppStrings.approve,
                                onPressed: () {
                                  context.read<UserBloc>().add(ApproveTeacherRequested(user.id));
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (state is UserError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
