import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/utils/extensions/size_extension.dart';
import 'package:flutter/material.dart';

class InputInfoUserWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isObligatory;
  final bool needMargin;

  const InputInfoUserWidget({
    Key? key,
    required this.title,
    required this.child,
    this.isObligatory = false,
    this.needMargin = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: needMargin ? 20 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: tokenDetailAmount(
                  fontSize: 14.0.textScale(),
                  color: titleItemEdit,
                ),
              ),
              if (isObligatory)
                const Text(
                  ' *',
                  style: TextStyle(color: canceledColor),
                )
              else
                const SizedBox()
            ],
          ),
          spaceH10,
          child
        ],
      ),
    );
  }
}
