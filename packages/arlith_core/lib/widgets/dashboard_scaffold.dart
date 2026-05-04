import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class DashboardScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<({IconData icon, IconData activeIcon, String label})> navItems;
  final int currentIndex;
  final Function(int) onNavTap;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const DashboardScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.navItems,
    required this.currentIndex,
    required this.onNavTap,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(title, style: AppTextStyles.h2(context)),
        actions: actions,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation ?? FloatingActionButtonLocation.endFloat,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              AppColors.primary.withOpacity(0.1),
              AppColors.secondary.withOpacity(0.1),
            ],
            stops: const [0.1, 0.5, 0.9],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          child: body,
        ),
      ),
      bottomNavigationBar: _buildStylishNav(context),
    );
  }

  Widget _buildStylishNav(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24.w),
      height: 72.h,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(35.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final item = navItems[index];
            final isSelected = currentIndex == index;
            
            return GestureDetector(
              onTap: () => onNavTap(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected ? Colors.white : AppColors.textSecondaryLight.withOpacity(0.5),
                      size: 24.sp,
                    ),
                    if (isSelected) ...[
                      SizedBox(width: 8.w),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
