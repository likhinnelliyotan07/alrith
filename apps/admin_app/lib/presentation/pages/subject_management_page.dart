import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';
import 'module_management_page.dart';

class SubjectManagementPage extends StatelessWidget {
  final SchoolClass schoolClass;

  const SubjectManagementPage({super.key, required this.schoolClass});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${schoolClass.name} Subjects', style: AppTextStyles.h2(context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.getDynamicPrimaryGradient(context),
        ),
        child: BlocBuilder<EducationBloc, EducationState>(
          builder: (context, state) {
            if (state is EducationLoading) return _buildShimmerList();
            if (state is EducationLoaded) {
              final subjects = state.subjects.where((s) => s.classIds.contains(schoolClass.id)).toList();
              if (subjects.isEmpty) {
                return _buildEmptyState(context);
              }
              return ListView.builder(
                padding: EdgeInsets.all(20.w),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return _buildSubjectCard(context, subject);
                },
              );
            }
            if (state is EducationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error, size: 48.sp),
                    SizedBox(height: 16.h),
                    Text(state.message, style: AppTextStyles.bodyMedium(context)),
                    TextButton(
                      onPressed: () => context.read<EducationBloc>().add(LoadEducationData()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSubjectDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Subject subject) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.book_outlined, color: AppColors.primary, size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject.name, style: AppTextStyles.h3(context)),
                    Text(
                      '${AppStrings.status}: ${subject.isActive ? AppStrings.active : AppStrings.inactive}',
                      style: AppTextStyles.bodySmall(context).copyWith(
                        color: subject.isActive ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: subject.isActive,
                onChanged: (val) {
                  context.read<EducationBloc>().add(UpdateSubjectEvent(
                    Subject(
                      id: subject.id,
                      name: subject.name,
                      classIds: subject.classIds,
                      teacherId: subject.teacherId,
                      isActive: val,
                    ),
                  ));
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                context,
                Icons.person_add_outlined,
                AppStrings.assignToTeacher,
                () => _showAssignTeacherDialog(context, subject),
              ),
              _buildActionButton(
                context,
                Icons.view_module_outlined,
                AppStrings.modules,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ModuleManagementPage(subject: subject, schoolClass: schoolClass),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20.sp),
          SizedBox(height: 4.h),
          Text(label, style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10.sp)),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        height: 120.h,
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24.r),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(AppStrings.noSubjectsFound, style: AppTextStyles.bodyLarge(context)),
    );
  }

  void _showAddSubjectDialog(BuildContext context) {
    final controller = TextEditingController();
    final bloc = context.read<EducationBloc>();
    final state = bloc.state;
    
    List<String> existingSubjectNames = [];
    if (state is EducationLoaded) {
      existingSubjectNames = state.subjects.map((s) => s.name).toSet().toList();
    }

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(AppStrings.addSubject, style: AppTextStyles.h3(context)),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (existingSubjectNames.isNotEmpty) ...[
                    Text('Choose from existing:', style: AppTextStyles.bodySmall(context).copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: existingSubjectNames.map((name) => ChoiceChip(
                        label: Text(name),
                        selected: controller.text == name,
                        onSelected: (selected) {
                          setDialogState(() {
                            controller.text = selected ? name : '';
                          });
                        },
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: controller.text == name ? AppColors.primary : AppColors.textPrimaryLight,
                          fontSize: 12.sp,
                        ),
                      )).toList(),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text('OR', style: AppTextStyles.bodySmall(context).copyWith(color: Colors.grey)),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    SizedBox(height: 24.h),
                  ],
                  Text('Create new subject:', style: AppTextStyles.bodySmall(context).copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: controller,
                    onChanged: (val) => setDialogState(() {}),
                    decoration: InputDecoration(
                      labelText: AppStrings.subjectName,
                      hintText: 'e.g. Advanced Calculus',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      prefixIcon: const Icon(Icons.add_circle_outline),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text(AppStrings.cancel)),
            ArlithGradientButton(
              text: AppStrings.add,
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  final newSubject = Subject(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: controller.text,
                    classIds: [schoolClass.id],
                  );
                  Navigator.pop(dialogContext);
                  bloc.add(AddSubjectEvent(newSubject));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignTeacherDialog(BuildContext context, Subject subject) {
    // Logic to select teacher from all teachers
  }
}
