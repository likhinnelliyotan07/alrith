import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/app_colors.dart';

class ArlithShimmer extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ArlithShimmer.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ArlithShimmer.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.light 
          ? Colors.grey[300]! 
          : Colors.grey[800]!,
      highlightColor: Theme.of(context).brightness == Brightness.light 
          ? Colors.grey[100]! 
          : Colors.grey[700]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400]!,
          shape: shapeBorder is RoundedRectangleBorder 
              ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)) 
              : shapeBorder,
        ),
      ),
    );
  }
}
