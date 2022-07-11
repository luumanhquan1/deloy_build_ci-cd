import 'package:ccvc_mobile/config/themes/theme_color.dart';
import 'package:ccvc_mobile/widgets/skeleton/container_skeleton_widget.dart';
import 'package:ccvc_mobile/widgets/skeleton/line_skeleton_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PostItemSkeleton extends StatelessWidget {
  const PostItemSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.sp, top: 16.sp, bottom: 16.sp),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 40.sp,
                  width: 40.sp,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ThemeColor.paleGrey,
                  ),
                ),
              ),
              // SizedBox(width: 12.sp,),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LineSkeletonWidget(width: 200.sp,),
                    SizedBox(
                      height: 3.sp,
                    ),
                    LineSkeletonWidget(width: 100.sp,),
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: SizedBox())
            ],
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 35.sp),
        //   child: Text(
        //     widget.postModel.content ?? '',
        //     //      'abcs',
        //     style: caption(color: ThemeColor.black),
        //   ),
        // ),
        // SizedBox(
        //   height: 12.sp,
        // ),
        Center(
            child: ContainerSkeletonWidget(

              height: 200.sp,
              width: 200.sp,
            )
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 16.sp),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child:Padding(
                    padding:  EdgeInsets.only(right: 5.sp),
                    child: ContainerSkeletonWidget(
                      height: 30.sp,
                    ),
                  )),
              Expanded(
                  child:Padding(
                    padding:  EdgeInsets.only(left: 5.sp),
                    child: ContainerSkeletonWidget(
                      height: 30.sp,
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }
}

