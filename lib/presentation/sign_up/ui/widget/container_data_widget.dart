import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:flutter/material.dart';

class ContainerDataWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const ContainerDataWidget({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textNormalCustom(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: titleColor,
          ),
        ),
        spaceH10,
        child,
        spaceH16,
      ],
    );
  }
}
