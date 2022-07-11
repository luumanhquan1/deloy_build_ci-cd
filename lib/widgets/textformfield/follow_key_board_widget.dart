
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowKeyBoardWidget extends StatefulWidget {
  final Widget child;
  final Widget? bottomWidget;
  const FollowKeyBoardWidget({
    Key? key,
    this.bottomWidget,
    required this.child,
  }) : super(key: key);

  @override
  _FollowKeyBoardWidgetState createState() => _FollowKeyBoardWidgetState();
}

class _FollowKeyBoardWidgetState extends State<FollowKeyBoardWidget> {
  EdgeInsets _viewInsert = EdgeInsets.zero;

  double mouseRegion = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    _viewInsert = mediaQuery.viewPadding.copyWith(
      bottom: mediaQuery.viewInsets.bottom,
    );
    return MouseRegion(
      onHover: (data) {
        mouseRegion = mediaQuery.size.height - data.position.dy;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: widget.child),
              ],
            ),
          ),
          SizedBox(
            height: viewInsertPadding(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: widget.bottomWidget ?? const SizedBox(),
          )
        ],
      ),
    );
  }

  double viewInsertPadding() {
    if (_viewInsert.bottom > mouseRegion) {
      return (_viewInsert.bottom - mouseRegion) + 45.h;
    }
    return 0;
  }
}
