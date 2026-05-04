import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle h1(BuildContext context) => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle h2(BuildContext context) => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle bodyLarge(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textSecondaryLight
            : AppColors.textSecondaryDark,
      );

  static TextStyle button(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle label(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textSecondaryLight
            : AppColors.textSecondaryDark,
      );
}
