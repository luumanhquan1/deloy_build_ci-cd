import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/utils/extensions/size_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarDefaultClose extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Color colorTitle;

  final String title;

  AppBarDefaultClose(
    this.title,
    this.colorTitle, {
    Key? key,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
      centerTitle: true,
      title: FittedBox(
        child: Text(
          title,
          maxLines: 1,
          style: textNormalCustom(
            fontSize: 14.0.textScale(),
          ).copyWith(color: colorTitle, fontSize: 24),
        ),
      ),
      elevation: 0.5,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.close,
          color: Color(0xffA2AEBD),
        ),
      ),
      actions: [
        Container(),
      ],
    );
  }
}
