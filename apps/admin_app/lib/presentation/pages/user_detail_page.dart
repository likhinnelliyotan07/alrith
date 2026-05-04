import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arlith_core/arlith_core.dart';

class UserDetailPage extends StatefulWidget {
  final UserProfile user;

  const UserDetailPage({super.key, required this.user});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  List<String> _assignedStudentIds = [];
  List<String> _selectedClassIds = [];
  List<String> _selectedSubjectIds = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _assignedStudentIds = List.from(widget.user.assignedStudentIds ?? []);
    _selectedClassIds = List.from(widget.user.classIds ?? []);
    _selectedSubjectIds = List.from(widget.user.subjectIds ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.editUser, style: AppTextStyles.h2(context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.getDynamicPrimaryGradient(context),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'Basic Information'),
              SizedBox(height: 16.h),
              _buildTextField(context, AppStrings.fullName, _nameController),
              SizedBox(height: 16.h),
              _buildTextField(context, AppStrings.email, _emailController),
              SizedBox(height: 16.h),
              _buildTextField(context, AppStrings.phone, _phoneController),
              SizedBox(height: 32.h),
              
              if (widget.user.role == UserRole.parent || widget.user.role == UserRole.teacher) ...[
                _buildSectionHeader(context, 'Assigned Students'),
                SizedBox(height: 16.h),
                _buildStudentAssignmentList(context),
                SizedBox(height: 16.h),
                _buildAddButton(context, 'Assign New Student', _showStudentPicker),
                SizedBox(height: 32.h),
              ],

              if (widget.user.role == UserRole.candidate) ...[
                _buildSectionHeader(context, 'Academic Info'),
                SizedBox(height: 16.h),
                _buildClassSelector(context),
                SizedBox(height: 16.h),
                _buildSubjectSelector(context),
                SizedBox(height: 32.h),
              ],

              if (widget.user.role == UserRole.teacher) ...[
                _buildSectionHeader(context, 'Teaching Portfolio'),
                SizedBox(height: 16.h),
                _buildClassSelector(context), // Teachers also assigned to classes
                SizedBox(height: 16.h),
                _buildSubjectSelector(context),
                SizedBox(height: 32.h),
              ],

              ArlithGradientButton(
                text: AppStrings.saveChanges,
                onPressed: _saveUser,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.h3(context).copyWith(color: AppColors.primary),
    );
  }

  Widget _buildTextField(BuildContext context, String label, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.bodyMedium(context),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.bodySmall(context),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildStudentAssignmentList(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UsersLoaded) {
          final assignedStudents = state.users.where((u) => _assignedStudentIds.contains(u.id)).toList();
          if (assignedStudents.isEmpty) {
            return Text('No students assigned.', style: AppTextStyles.bodySmall(context));
          }
          return Wrap(
            spacing: 8.w,
            children: assignedStudents.map((s) => Chip(
              label: Text(s.fullName, style: TextStyle(fontSize: 12.sp)),
              onDeleted: () {
                setState(() => _assignedStudentIds.remove(s.id));
              },
            )).toList(),
          );
        }
        return const ArlithShimmer.rectangular(height: 40);
      },
    );
  }

  Widget _buildClassSelector(BuildContext context) {
    return BlocBuilder<EducationBloc, EducationState>(
      builder: (context, state) {
        if (state is EducationLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.classes, style: AppTextStyles.bodySmall(context)),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                children: state.classes.map((c) {
                  final isSelected = _selectedClassIds.contains(c.id);
                  return FilterChip(
                    label: Text(c.name, style: TextStyle(fontSize: 12.sp)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedClassIds.add(c.id);
                        } else {
                          _selectedClassIds.remove(c.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          );
        }
        return const ArlithShimmer.rectangular(height: 50);
      },
    );
  }

  Widget _buildSubjectSelector(BuildContext context) {
    return BlocBuilder<EducationBloc, EducationState>(
      builder: (context, state) {
        if (state is EducationLoaded) {
          // If classes are selected, only show subjects belonging to those classes
          final subjects = _selectedClassIds.isNotEmpty 
              ? state.subjects.where((s) => s.classIds.any((cid) => _selectedClassIds.contains(cid))).toList()
              : state.subjects;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.subjects, style: AppTextStyles.bodySmall(context)),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                children: subjects.map((s) {
                  final isSelected = _selectedSubjectIds.contains(s.id);
                  return FilterChip(
                    label: Text(s.name, style: TextStyle(fontSize: 12.sp)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSubjectIds.add(s.id);
                        } else {
                          _selectedSubjectIds.remove(s.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          );
        }
        return const ArlithShimmer.rectangular(height: 100);
      },
    );
  }

  Widget _buildAddButton(BuildContext context, String label, VoidCallback onTap) {
    return ArlithGradientButton(
      text: label,
      onPressed: onTap,
    );
  }

  void _saveUser() {
    final updatedUser = UserProfile(
      id: widget.user.id,
      fullName: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      role: widget.user.role,
      isApproved: widget.user.isApproved,
      createdAt: widget.user.createdAt,
      classIds: _selectedClassIds,
      subjectIds: _selectedSubjectIds,
      assignedStudentIds: _assignedStudentIds,
    );
    
    // Pop first to avoid build scope conflicts during state change
    Navigator.pop(context);
    context.read<UserBloc>().add(UpdateUserProfileRequested(updatedUser));
  }

  void _showStudentPicker() {
    final userBloc = context.read<UserBloc>();
    final state = userBloc.state;
    if (state is UsersLoaded) {
      final candidates = state.users.where((u) => u.role == UserRole.candidate && !_assignedStudentIds.contains(u.id)).toList();
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Assign Students'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: candidates.length,
              itemBuilder: (context, index) {
                final student = candidates[index];
                return ListTile(
                  title: Text(student.fullName),
                  subtitle: Text(student.email),
                  onTap: () {
                    setState(() => _assignedStudentIds.add(student.id));
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ),
      );
    }
  }
}
