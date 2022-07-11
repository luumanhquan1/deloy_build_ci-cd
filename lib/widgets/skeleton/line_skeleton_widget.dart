import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'skeleton_widget.dart';

class LineSkeletonWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const LineSkeletonWidget({Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonWidget(
      child: Container(
        width: width ?? 80.0.w,
        height: height ?? 8.0.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          color: Colors.white,
        ),
      ),
    );
  }
}