import 'package:ccvc_mobile/config/resources/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageAssets {
  ///Svg path
  static const String icHeaderMenuBlue = '$baseImg/background_menu_blue.png';
  static const String icProfile = '$baseImg/ic_profile.svg';
  static const String icMessage = '$baseImg/ic_message.svg';
  static const String icTym = '$baseImg/ic_tym.svg';
  static const String icHome = '$baseImg/ic_home.svg';
  static const String icAdd = '$baseImg/ic_add.svg';
  static const String icBackgroundMessage = '$baseImg/background_message.svg';

  static const String icSearch = '$baseImg/ic_search.svg';
  static const String icSendSms = '$baseImg/ic_send_sms.svg';
  static const String icClearLogin = '$baseImg/ic_clear_login.svg';
  static const String imgAcount = '$baseImg/ic_acount.svg';
  static const String imgLoginPng = '$baseImg/img_login.png';
  static const String imgViewHide = '$baseImg/ic_view_hide.svg';
  static const String imgView = '$baseImg/ic_view.svg';
  static const String imgPassword = '$baseImg/ic_password.svg';
  static const String imgChangePassword = '$baseImg/img_change_password.png';
  static const String icConfirm = '$baseImg/ic_confirm.svg';
  static const String avatarDefault = '$baseImg/avatar_default.png';



  static const String imgEmptyAvata = 'https://i.stack.imgur.com/l60Hf.png';


  static SvgPicture svgAssets(
    String name, {
    Color? color,
    double? width,
    double? height,
    BoxFit? fit,
    BlendMode? blendMode,
  }) {
    final size = _svgImageSize[name];
    var w = width;
    var h = height;
    if (size != null) {
      w = width ?? size[0];
      h = height ?? size[1];
    }
    return SvgPicture.asset(
      name,
      colorBlendMode: blendMode ?? BlendMode.srcIn,
      color: color,
      width: w,
      height: h,
      fit: fit ?? BoxFit.none,
    );
  }

  static const Map<String, List<double>> _svgImageSize = {};
}
