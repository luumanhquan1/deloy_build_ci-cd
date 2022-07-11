import 'dart:io';

import 'package:ccvc_mobile/config/themes/app_theme.dart';
import 'package:ccvc_mobile/utils/constants/app_constants.dart';
//import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

bool isEmail(String email) {
  return RegExp(EMAIL_REGEX).hasMatch(email);
}

/// validate vietnam phone number
bool isVNPhone(String phone) {
  return RegExp(VN_PHONE).hasMatch(phone);
}

double getWithSize(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  return size.width;
}

double getHeightSize(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  return size.height;
}

// Future<String> getDeviceName() async {
//   if (Platform.isAndroid) {
//     final androidInfo = await DeviceInfoPlugin().androidInfo;
//     //Xiaomi Redmi Note 7
//     return '${androidInfo.manufacturer} ${androidInfo.model}';
//   }
//
//   if (Platform.isIOS) {
//     final iosInfo = await DeviceInfoPlugin().iosInfo;
//     //iPhone 11 Pro Max iPhone
//     return '${iosInfo.name} ${iosInfo.model}';
//   }
//   return '';
// }
//
// Future<String> getOSName() async {
//   if (Platform.isAndroid) {
//     final info = await DeviceInfoPlugin().androidInfo;
//     // Android 9 (SDK 28)
//     return 'Android ${info.version.release} (SDK ${info.version.sdkInt})';
//   }
//
//   if (Platform.isIOS) {
//     final iosInfo = await DeviceInfoPlugin().iosInfo;
//     // iOS 13.1, iPhone 11 Pro Max iPhone
//     return '${iosInfo.systemName}, ${iosInfo.systemVersion}';
//   }
//   return '';
// }

String getDevice() {
  if (Platform.isAndroid) {
    return 'android';
  } else if (Platform.isIOS) {
    return 'ios';
  }
  return 'others';
}

Future<String> getAppVersion() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

// Future<String> getDeviceId() async {
//   final deviceInfo = DeviceInfoPlugin();
//   if (Platform.isIOS) {
//     final iosDeviceInfo = await deviceInfo.iosInfo;
//     return iosDeviceInfo.identifierForVendor;
//   } else if (Platform.isAndroid) {
//     final androidDeviceInfo = await deviceInfo.androidInfo;
//     return androidDeviceInfo.androidId;
//   } else {
//     return '';
//   }
// }

void showLoading(BuildContext context, {Function? close}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return WillPopScope(
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.getInstance().primaryColor(),
          ),
        ),
        onWillPop: () async => false,
      );
    },
  ).then(
    (value) {
      if (close != null) close(value);
    },
  );
}

void hideLoading(BuildContext context) {
  Navigator.of(context).pop();
}

String parseTimeCreate(int time){
  int now = DateTime.now().millisecondsSinceEpoch;
  if((now - time) <60000)
    return "Vừa xong";
  if((now - time) >= 60000 && (now - time)< 60000*60 )
    return '${((now - time)/60000).round()} phút trước';
  if((now - time) >= 60000*60 && (now - time)< 60000*60*24 )
    return '${((now - time)/(60000*60)).round()} giờ trước';
  return  DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(time));
}

String intToDatetime(int date) => DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(date));


