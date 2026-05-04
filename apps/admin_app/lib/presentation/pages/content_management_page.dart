import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';

class ContentManagementPage extends StatefulWidget {
  final LearningModule module;

  const ContentManagementPage({super.key, required this.module});

  @override
  State<ContentManagementPage> createState() => _ContentManagementPageState();
}

class _ContentManagementPageState extends State<ContentManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<EducationBloc>().add(LoadClassContentEvent(widget.module.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.module.name} ${AppStrings.classContent}', style: AppTextStyles.h2(context)),
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
              if (state.contents.isEmpty) return _buildEmptyState(context);
              return ListView.builder(
                padding: EdgeInsets.all(20.w),
                itemCount: state.contents.length,
                itemBuilder: (context, index) {
                  final content = state.contents[index];
                  return _buildContentCard(context, content);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContentPage(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, ClassContent content) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined, color: AppColors.primary, size: 24.sp),
              SizedBox(width: 12.w),
              Expanded(child: Text(content.title, style: AppTextStyles.h3(context))),
              Text(content.duration, style: AppTextStyles.bodySmall(context).copyWith(color: AppColors.textSecondaryLight)),
            ],
          ),
          SizedBox(height: 12.h),
          Text(content.description, style: AppTextStyles.bodyMedium(context)),
          if (content.videoUrl != null || content.pdfUrl != null) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                if (content.videoUrl != null)
                  _buildMediaBadge(context, Icons.play_circle_outline, AppStrings.video, AppColors.primary),
                if (content.pdfUrl != null)
                  _buildMediaBadge(context, Icons.picture_as_pdf_outlined, AppStrings.pdf, AppColors.secondary),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaBadge(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          SizedBox(width: 4.w),
          Text(label, style: AppTextStyles.bodySmall(context).copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        height: 140.h,
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
      child: Text(AppStrings.noContentFound, style: AppTextStyles.bodyLarge(context)),
    );
  }

  void _showAddContentPage(BuildContext context) {
    // Show form to add class content with title, description, videoUrl, pdfUrl, etc.
  }
}
