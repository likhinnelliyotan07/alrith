import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';
import '../subject_management_page.dart';

class EducationTab extends StatelessWidget {
  const EducationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EducationBloc, EducationState>(
      builder: (context, state) {
        if (state is EducationLoading) return _buildShimmerList();
        if (state is EducationLoaded) {
          if (state.classes.isEmpty && state.subjects.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView(
            padding: EdgeInsets.all(20.w),
            children: [
              _EducationSection(
                title: AppStrings.classes,
                items: state.classes,
                color: AppColors.primary,
                onChipTap: (item) {
                  final bloc = context.read<EducationBloc>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: bloc,
                        child: SubjectManagementPage(schoolClass: item as SchoolClass),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),
              _EducationSection(
                title: AppStrings.subjects,
                items: state.subjects,
                color: AppColors.secondary,
              ),
            ],
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined, size: 64.sp, color: AppColors.textSecondaryLight),
          SizedBox(height: 16.h),
          Text(AppStrings.noSubjectsFound, style: AppTextStyles.bodyLarge(context)),
          SizedBox(height: 24.h),
          ArlithGradientButton(
            text: AppStrings.addClass,
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    // Shared add dialog logic
  }
}

class _EducationSection extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final Color color;
  final Function(dynamic)? onChipTap;

  const _EducationSection({
    required this.title,
    required this.items,
    required this.color,
    this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 16.h,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2.r)),
              ),
              SizedBox(width: 8.w),
              Text(title, style: AppTextStyles.h3(context).copyWith(fontSize: 18.sp)),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: items.map((item) => _EducationChip(item: item, color: color, onTap: onChipTap)).toList(),
          ),
        ],
      ),
    );
  }
}

class _EducationChip extends StatelessWidget {
  final dynamic item;
  final Color color;
  final Function(dynamic)? onTap;

  const _EducationChip({required this.item, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(item) : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Text(
          item.name,
          style: AppTextStyles.bodySmall(context).copyWith(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
