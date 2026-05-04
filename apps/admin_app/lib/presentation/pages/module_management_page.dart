import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';
import 'content_management_page.dart';

class ModuleManagementPage extends StatefulWidget {
  final Subject subject;
  final SchoolClass schoolClass;

  const ModuleManagementPage({super.key, required this.subject, required this.schoolClass});

  @override
  State<ModuleManagementPage> createState() => _ModuleManagementPageState();
}

class _ModuleManagementPageState extends State<ModuleManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<EducationBloc>().add(LoadModulesEvent(widget.subject.id, widget.schoolClass.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject.name} Modules', style: AppTextStyles.h2(context)),
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
              if (state.modules.isEmpty) return _buildEmptyState(context);
              return ListView.builder(
                padding: EdgeInsets.all(20.w),
                itemCount: state.modules.length,
                itemBuilder: (context, index) {
                  final module = state.modules[index];
                  return _buildModuleCard(context, module);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddModuleDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, LearningModule module) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(Icons.layers_outlined, color: AppColors.secondary, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(module.name, style: AppTextStyles.h3(context)),
                Text(
                  '${AppStrings.created}: ${module.createdAt.day}/${module.createdAt.month}/${module.createdAt.year}',
                  style: AppTextStyles.bodySmall(context).copyWith(color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: 16.sp, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ContentManagementPage(module: module),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        height: 80.h,
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(AppStrings.noModulesFound, style: AppTextStyles.bodyLarge(context)),
    );
  }

  void _showAddModuleDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.addModule),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: AppStrings.moduleName),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text(AppStrings.cancel)),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final module = LearningModule(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  subjectId: widget.subject.id,
                  classId: widget.schoolClass.id,
                  name: controller.text,
                  createdAt: DateTime.now(),
                );
                
                Navigator.pop(dialogContext);
                context.read<EducationBloc>().add(AddModuleEvent(module));
              }
            },
            child: const Text(AppStrings.add),
          ),
        ],
      ),
    );
  }
}
