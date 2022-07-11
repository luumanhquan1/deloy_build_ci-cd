import 'dart:ui';

import 'package:ccvc_mobile/config/app_config.dart';
import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/utils/constants/app_constants.dart';
import 'package:ccvc_mobile/utils/extensions/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Widget? leadingIcon;
  final String title;
  final Color? backGroundColor;
  final List<Widget>? actions;

  BaseAppBar({
    Key? key,
    required this.title,
    this.leadingIcon,
    this.actions,
    this.backGroundColor,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
      backgroundColor:
          APP_DEVICE == DeviceType.MOBILE ? backgroundColorApp : bgQLVBTablet,
      bottomOpacity: 0.0,
      elevation: APP_DEVICE == DeviceType.MOBILE ? 0.3 : 0.7,
      shadowColor: bgDropDown,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: titleAppbar(fontSize: 18.0.textScale(space: 6.0)),
      ),
      centerTitle: true,
      leading: leadingIcon,
      actions: actions,
    );
  }
}
