import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/utils/extensions/size_extension.dart';
import 'package:flutter/material.dart';

class ButtonCustomBottom extends StatefulWidget {
  final bool isColorBlue;
  final String title;
  final Function onPressed;
  final double? size;

  const ButtonCustomBottom({
    Key? key,
    required this.isColorBlue,
    required this.title,
    this.size,
    required this.onPressed,
  }) : super(key: key);

  @override
  _ButtonCustomBottomState createState() => _ButtonCustomBottomState();
}

class _ButtonCustomBottomState extends State<ButtonCustomBottom> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.onPressed();
            },
            child: Container(
              height: 40.0.textScale(space: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0.textScale(space: 4.0)),
                color: widget.isColorBlue ? textDefault : buttonColor2,
              ),
              child: Center(
                child: Text(
                  widget.title,
                  style: textNormalCustom(
                    fontSize: widget.size ?? 14.0.textScale(space: 4.0),
                    color:
                    widget.isColorBlue ? backgroundColorApp : textDefault,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
