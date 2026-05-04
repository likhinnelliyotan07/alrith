import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../../models/user_profile.dart';
import '../../models/user_role.dart';

class UserCard extends StatelessWidget {
  final UserProfile user;
  final VoidCallback? onApprove;
  final VoidCallback? onAssignTeacher;
  final VoidCallback? onAssignParent;
  final VoidCallback? onAssignClass;
  final VoidCallback? onAssignSubjects;
  final VoidCallback? onEdit;
  final bool showApproval;

  const UserCard({
    super.key,
    required this.user,
    this.onApprove,
    this.onAssignTeacher,
    this.onAssignParent,
    this.onAssignClass,
    this.onAssignSubjects,
    this.onEdit,
    this.showApproval = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              user.fullName[0].toUpperCase(),
              style: AppTextStyles.h3(context).copyWith(color: AppColors.primary),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullName, style: AppTextStyles.bodyLarge(context).copyWith(fontWeight: FontWeight.bold)),
                Text(user.email, style: AppTextStyles.bodyMedium(context)),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: _getRoleColor(user.role).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    user.role.toString().split('.').last.toUpperCase(),
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: _getRoleColor(user.role),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (showApproval && !user.isApproved)
                Tooltip(
                  message: 'Approve Teacher',
                  child: IconButton(
                    icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
                    onPressed: onApprove,
                  ),
                ),
              if (user.role == UserRole.candidate) ...[
                if (onAssignTeacher != null)
                  Tooltip(
                    message: 'Assign Teacher',
                    child: IconButton(
                      icon: const Icon(Icons.school_outlined, color: AppColors.primary),
                      onPressed: onAssignTeacher,
                    ),
                  ),
                if (onAssignParent != null)
                  Tooltip(
                    message: 'Assign Parent',
                    child: IconButton(
                      icon: const Icon(Icons.family_restroom_outlined, color: AppColors.secondary),
                      onPressed: onAssignParent,
                    ),
                  ),
                if (onAssignClass != null)
                  Tooltip(
                    message: 'Assign Class',
                    child: IconButton(
                      icon: const Icon(Icons.class_outlined, color: AppColors.accent),
                      onPressed: onAssignClass,
                    ),
                  ),
                if (onAssignSubjects != null)
                  Tooltip(
                    message: 'Assign Subjects',
                    child: IconButton(
                      icon: const Icon(Icons.book_outlined, color: AppColors.success),
                      onPressed: onAssignSubjects,
                    ),
                  ),
              ],
              if (user.role == UserRole.teacher) ...[
                if (onAssignSubjects != null)
                  Tooltip(
                    message: 'Assign Subjects',
                    child: IconButton(
                      icon: const Icon(Icons.menu_book_outlined, color: AppColors.primary),
                      onPressed: onAssignSubjects,
                    ),
                  ),
              ],
              if (onEdit != null)
                Tooltip(
                  message: 'Edit Profile',
                  child: IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                    onPressed: onEdit,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppColors.error;
      case UserRole.teacher:
        return AppColors.primary;
      case UserRole.parent:
        return AppColors.secondary;
      default:
        return AppColors.textSecondaryLight;
    }
  }
}
