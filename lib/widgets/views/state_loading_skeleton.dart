import 'dart:developer';

import 'package:ccvc_mobile/widgets/views/state_layout.dart';
import 'package:flutter/material.dart';

class StateLoadingSkeleton extends StatelessWidget {
  final Stream<StateLayout> stream;
  final Widget child;
  final Widget skeleton;
  final int countSkeleton;
  final double paddingSkeleton;
  const StateLoadingSkeleton(
      {Key? key,
      required this.stream,
      required this.child,
      required this.skeleton,
      this.countSkeleton = 10,
      this.paddingSkeleton = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StateLayout>(
      stream: stream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? StateLayout.showLoading;
        return data == StateLayout.showLoading
            ? SingleChildScrollView(
              child: Column(
                  children: List.generate(countSkeleton, (index) => Padding(
                    padding: EdgeInsets.only(bottom: paddingSkeleton),
                    child: skeleton,
                  )),
                ),
            )
            : child;
      },
    );
  }
}
