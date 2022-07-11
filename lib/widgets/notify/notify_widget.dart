import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/utils/extensions/size_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';

class NotifyWidget extends StatelessWidget {
  final String image;
  final String content;
  final String textButtom;

  const NotifyWidget({
    Key? key,
    required this.image,
    required this.content,
    required this.textButtom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(image),
            SizedBox(
              height: 25.0.textScale(),
            ),
            Text(
              content,
              style: textNormalCustom(
                color: textTitle,
                fontSize: 18.0.textScale(),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 30.0.textScale(),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context,true);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 56.5.textScale(),
                  vertical: 12.0.textScale(),
                ),
                decoration: BoxDecoration(
                  color: bgButtonDropDown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.0.textScale()),
                ),
                child: Text(
                  textButtom,
                  style: textNormalCustom(
                    color: labelColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0.textScale(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
