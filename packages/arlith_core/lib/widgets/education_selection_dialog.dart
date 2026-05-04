import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../models/education_models.dart';
import 'arlith_gradient_button.dart';

class EducationSelectionDialog extends StatefulWidget {
  final String title;
  final List<dynamic> items; // List of SchoolClass or Subject
  final List<String> selectedIds;
  final bool multiple;
  final Function(List<dynamic>) onSelected;

  const EducationSelectionDialog({
    super.key,
    required this.title,
    required this.items,
    this.selectedIds = const [],
    this.multiple = false,
    required this.onSelected,
  });

  @override
  State<EducationSelectionDialog> createState() => _EducationSelectionDialogState();
}

class _EducationSelectionDialogState extends State<EducationSelectionDialog> {
  late List<String> _currentSelectedIds;

  @override
  void initState() {
    super.initState();
    _currentSelectedIds = List.from(widget.selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
      child: Container(
        padding: EdgeInsets.all(24.w),
        constraints: BoxConstraints(maxHeight: 0.7.sh),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title, style: AppTextStyles.h3(context)),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final id = item.id;
                  final isSelected = _currentSelectedIds.contains(id);

                  return CheckboxListTile(
                    value: isSelected,
                    title: Text(item.name),
                    onChanged: (val) {
                      setState(() {
                        if (widget.multiple) {
                          if (val == true) {
                            _currentSelectedIds.add(id);
                          } else {
                            _currentSelectedIds.remove(id);
                          }
                        } else {
                          _currentSelectedIds = [id];
                        }
                      });
                    },
                    activeColor: AppColors.primary,
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),
            ArlithGradientButton(
              text: 'Confirm',
              onPressed: () {
                final selectedItems = widget.items
                    .where((item) => _currentSelectedIds.contains(item.id))
                    .toList();
                widget.onSelected(selectedItems);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
