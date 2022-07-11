import 'package:ccvc_mobile/config/app_config.dart';
import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/utils/constants/app_constants.dart';

class AppTheme {
  static AppColor getInstance() {
    switch(APP_THEME){
      case AppMode.MAC_DINH:
         return DefaultApp();
      case AppMode.XANH:
        return BlueApp();
      case AppMode.HONG:
        return PinkApp();
      case AppMode.VANG:
       return YellowApp();
    }

  }
}
