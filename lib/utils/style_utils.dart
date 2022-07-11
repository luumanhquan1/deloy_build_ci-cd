import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

const emptyView = SizedBox(width: 0, height: 0);

/// height and width space
const spaceH2 = SizedBox(height: 2);
const spaceH3 = SizedBox(height: 3);
const spaceH4 = SizedBox(height: 4);
const spaceH5 = SizedBox(height: 5);
const spaceH6 = SizedBox(height: 6);
const spaceH8 = SizedBox(height: 8);
const spaceH10 = SizedBox(height: 10);
const spaceH12 = SizedBox(height: 12);
const spaceH15 = SizedBox(height: 15);
const spaceH16 = SizedBox(height: 16);
const spaceH20 = SizedBox(height: 20);
const spaceH25 = SizedBox(height: 25);
const spaceH30 = SizedBox(height: 30);
const spaceH35 = SizedBox(height: 35);
const spaceH50 = SizedBox(height: 50);
const spaceH60 = SizedBox(height: 60);
const spaceH70 = SizedBox(height: 70);

///W
const spaceW2 = SizedBox(width: 2);
const spaceW3 = SizedBox(width: 3);
const spaceW4 = SizedBox(width: 4);
const spaceW5 = SizedBox(width: 5);
const spaceW6 = SizedBox(width: 6);
const spaceW8 = SizedBox(width: 8);
const spaceW10 = SizedBox(width: 10);
const spaceW12 = SizedBox(width: 12);
const spaceW15 = SizedBox(width: 15);
const spaceW18 = SizedBox(width: 18);
const spaceW20 = SizedBox(width: 20);
const spaceW25 = SizedBox(width: 25);
const spaceW30 = SizedBox(width: 30);

TextStyle textStyle({double size = 16, double height = 1.2}) =>
    GoogleFonts.roboto(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: dfTxtColor,
      fontStyle: FontStyle.normal,
      height: height,
    );
