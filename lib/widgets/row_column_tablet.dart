import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:flutter/material.dart';

class RowColunmTabletWidget extends StatelessWidget {
  final String titleLeft;
  final String titleRight;
  final Widget widgetLeft;
  final Widget widgetRight;
  const RowColunmTabletWidget({
    Key? key,
    required this.titleLeft,
    required this.titleRight,
    required this.widgetLeft,
    required this.widgetRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 28),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: backgroundColorApp,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: borderColor.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: shadowContainerColor.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 10,
            )
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: titleLeft.isNotEmpty,
                  child: Text(
                    titleLeft,
                    style: textNormalCustom(fontSize: 18, color: titleColor),
                  ),
                ),
                widgetLeft
              ],
            ),
          ),
          const SizedBox(
            width: 28,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: titleRight.isNotEmpty,
                  child: Text(
                    titleRight,
                    style: textNormalCustom(fontSize: 18, color: titleColor),
                  ),
                ),
                widgetRight
              ],
            ),
          )
        ],
      ),
    );
  }
}
