import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../constants/app_strings.dart';
import '../../models/user_profile.dart';
import 'arlith_gradient_button.dart';

class UserEditDialog extends StatefulWidget {
  final UserProfile user;
  final Function(UserProfile) onSave;

  const UserEditDialog({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  State<UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends State<UserEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.editUser, style: AppTextStyles.h3(context)),
            SizedBox(height: 24.h),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppStrings.fullName,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: AppStrings.phone,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
            SizedBox(height: 32.h),
            ArlithGradientButton(
              text: AppStrings.saveChanges,
              onPressed: () {
                widget.onSave(UserProfile(
                  id: widget.user.id,
                  email: widget.user.email,
                  fullName: _nameController.text,
                  phone: _phoneController.text,
                  role: widget.user.role,
                  isApproved: widget.user.isApproved,
                  createdAt: widget.user.createdAt,
                  classIds: widget.user.classIds,
                  subjectIds: widget.user.subjectIds,
                  assignedStudentIds: widget.user.assignedStudentIds,
                ));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
