
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'skeleton_widget.dart';

class ContainerSkeletonWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;

  const ContainerSkeletonWidget({Key? key, this.height, this.width, this.borderRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 60.w,
      height: height ?? 86.h,
      child: SkeletonWidget(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              shape: BoxShape.rectangle,
              color: Colors.white),
        ),
      ),
    );
  }
}
