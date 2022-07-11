import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import 'line_skeleton_widget.dart';

class DetailInfoSkeletonWidget extends StatelessWidget {
  const DetailInfoSkeletonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 12.sp,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LineSkeletonWidget(
              height: 21.sp,
              width: 138.sp,
            ),
            Container(
              width: 23.sp,
            ),
            LineSkeletonWidget(
              height: 21.sp,
              width: 40.sp,
            ),
            Container(
              width: 23.sp,
            ),
            LineSkeletonWidget(
              height: 21.sp,
              width: 80.sp,
            ),
          ],
        )
      ],
    );
  }
}
