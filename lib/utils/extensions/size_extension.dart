import 'package:ccvc_mobile/config/app_config.dart';
import 'package:ccvc_mobile/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';

extension SizeInt on int {
  int textScale({int space = 2}) {
    return APP_DEVICE == DeviceType.MOBILE ? this : this + space;
  }
}

extension SizeDouble on double {
  double textScale({double space = 2}) {
    return APP_DEVICE == DeviceType.MOBILE ? this : this + space;
  }
}

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late EdgeInsets keyBoardHeight;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    keyBoardHeight = _mediaQueryData.viewInsets;
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}
