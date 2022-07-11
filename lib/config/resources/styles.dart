import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
const spaceH14 = SizedBox(height: 14);
const spaceH15 = SizedBox(height: 15);
const spaceH16 = SizedBox(height: 16);
const spaceH20 = SizedBox(height: 20);
const spaceH24 = SizedBox(height: 24);
const spaceH26 = SizedBox(height: 26);
const spaceH25 = SizedBox(height: 25);
const spaceH28 = SizedBox(height: 28);
const spaceH30 = SizedBox(height: 30);
const spaceH32 = SizedBox(height: 20);
const spaceH35 = SizedBox(height: 35);
const spaceH36 = SizedBox(height: 36);
const spaceH38 = SizedBox(height: 38);
const spaceH40 = SizedBox(height: 40);
const spaceH46 = SizedBox(height: 46);
const spaceH48 = SizedBox(height: 48);
const spaceH50 = SizedBox(height: 50);
const spaceH60 = SizedBox(height: 60);
const spaceH70 = SizedBox(height: 70);
const spaceH156 = SizedBox(height: 156);

///W
const spaceW2 = SizedBox(width: 2);
const spaceW3 = SizedBox(width: 3);
const spaceW4 = SizedBox(width: 4);
const spaceW5 = SizedBox(width: 5);
const spaceW6 = SizedBox(width: 6);
const spaceW8 = SizedBox(width: 8);
const spaceW10 = SizedBox(width: 10);
const spaceW12 = SizedBox(width: 12);
const spaceW13 = SizedBox(width: 13);
const spaceW15 = SizedBox(width: 15);
const spaceW16 = SizedBox(width: 16);
const spaceW18 = SizedBox(width: 18);
const spaceW20 = SizedBox(width: 20);
const spaceW25 = SizedBox(width: 25);
const spaceW28 = SizedBox(width: 28);
const spaceW30 = SizedBox(width: 30);
const spaceW56 = SizedBox(width: 56);
const spaceW60 = SizedBox(width: 60);
const spaceW78 = SizedBox(width: 78);
const spaceW100 = SizedBox(width: 100);

TextStyle textNormal(Color? color, double? fontSize) {
  return GoogleFonts.poppins(
    color: color ?? Colors.white,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: fontSize ?? 14,
  );
}

TextStyle tokenDetailAmount({
  Color color = Colors.white,
  double fontSize = 24,
  FontWeight weight = FontWeight.w400,
}) {
  return GoogleFonts.poppins(
    color: color,
    fontWeight: weight,
    fontStyle: FontStyle.normal,
    fontSize: fontSize,
  );
}

TextStyle textDetailHDSD({
  Color color = Colors.white,
  double fontSize = 24,
  FontWeight weight = FontWeight.w400,
  double textHeight = 1.9,
}) {
  return GoogleFonts.poppins(
    color: color,
    fontWeight: weight,
    fontStyle: FontStyle.normal,
    fontSize: fontSize,
  ).copyWith(height: textHeight);
}

TextStyle titleText({Color color = Colors.white, double fontSize = 20}) {
  return GoogleFonts.poppins(
    color: color,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: fontSize,
  );
}

TextStyle textNormalCustom({
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return GoogleFonts.poppins(
    color: color ?? Colors.white,
    fontWeight: fontWeight ?? FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: fontSize ?? 14,
  );
}


TextStyle titleAppbar({Color color = titleColor, double fontSize = 18}) {
  return GoogleFonts.poppins(

    color: color,
    fontWeight: FontWeight.bold,
    fontSize: fontSize,
    fontStyle: FontStyle.normal,
  );
}

TextStyle heading2({Color color = titleColor}) {
  return GoogleFonts.poppins(
    color: color,
    fontWeight: FontWeight.bold,
    fontSize: 25.sp,
    fontStyle: FontStyle.normal,
  );
}

TextStyle username({Color color = titleColor}) {
  return GoogleFonts.poppins(
    color: ThemeColor.black,
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
    fontStyle: FontStyle.normal,
  );
}

TextStyle detail({Color color = titleColor}) {
  return GoogleFonts.poppins(
    color: color,
    fontWeight: FontWeight.w400,
    fontSize: 12.8.sp,
    fontStyle: FontStyle.normal,
  );
}

  TextStyle caption({Color color = titleColor}) {
    return GoogleFonts.poppins(
      color: color,
      fontWeight: FontWeight.normal,
      fontSize: 16.sp,
      fontStyle: FontStyle.normal,
    );
  }

TextStyle button({Color color = titleColor}) {
  return GoogleFonts.roboto(
    color: color,
    fontWeight: FontWeight.normal,
    fontSize: 18.sp,
    fontStyle: FontStyle.normal,
  );
}