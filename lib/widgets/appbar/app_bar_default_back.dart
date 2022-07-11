import 'dart:ui';
import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class AppBarDefaultBack extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  AppBarDefaultBack(
    this.title, {
    Key? key,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
      backgroundColor: Colors.transparent,
      bottomOpacity: 0.0,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: textNormalCustom(color: colorBlack, fontSize: 18),
      ),
      centerTitle: true,
      leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back_ios,color: Colors.black,)),
    );
  }
}
