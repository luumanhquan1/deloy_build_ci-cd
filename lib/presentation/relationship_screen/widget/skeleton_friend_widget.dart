import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../widgets/skeleton/container_skeleton_widget.dart';
import '../../../widgets/skeleton/line_skeleton_widget.dart';


class SkeletonFriendWidget extends StatelessWidget {

  const SkeletonFriendWidget(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children:const [
          ContainerSkeletonWidget(width: 62,height: 62,borderRadius: 62,),
          const SizedBox(
            width: 12,
          ),
          LineSkeletonWidget(width: 100,height: 10,)
        ],
      ),
    );
  }
}
