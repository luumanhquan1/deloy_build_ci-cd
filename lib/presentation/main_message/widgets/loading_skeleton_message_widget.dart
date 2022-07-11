import 'package:ccvc_mobile/widgets/skeleton/container_skeleton_widget.dart';
import 'package:ccvc_mobile/widgets/skeleton/line_skeleton_widget.dart';
import 'package:flutter/material.dart';

class LoadingSkeletonMessageWidget extends StatelessWidget {
  const LoadingSkeletonMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 103,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: Row(
        children: [
          const ContainerSkeletonWidget(
            width: 62,
            height: 62,
            borderRadius: 60,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  LineSkeletonWidget(
                    width: double.infinity,
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  LineSkeletonWidget(
                    width: double.infinity,
                    height: 30,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
