import 'dart:ui';

import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseAppBarMobile extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Widget? leadingIcon;
  final String title;
  final double? elevation;
  final List<Widget>? actions;

  BaseAppBarMobile(
      {Key? key,
      required this.title,
      this.leadingIcon,
      this.actions,
      this.elevation})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
      backgroundColor: backgroundColorApp,
      bottomOpacity: 0.0,
      elevation: elevation ?? 0.0,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: titleAppbar(),
      ),
      centerTitle: true,
      leading: leadingIcon,
      actions: actions,
    );
  }
}
