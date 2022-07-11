import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerSlide {
  static void navigatorSlide({
    required BuildContext context,
    required Widget screen,
    bool isLeft = true,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, animation, ___) {
          final Offset begin;
          if (isLeft) {
            begin = const Offset(-1.0, 0.0);
          } else {
            begin = const Offset(1.0, 0.0);
          }
          const end = Offset.zero;
          final tween = Tween(end: end, begin: begin);
          final offsetAnimation = animation.drive(tween);

          if(isLeft) {
            return Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: Colors.black12,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: screen,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      child: Container(color: Colors.black12),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          );
          } else {
            return Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        child: Container(color: Colors.black12),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Colors.black12,
                        child: SlideTransition(
                          position: offsetAnimation,
                          child: screen,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
        },
        opaque: false,
      ),
    ).then((value) {
    });
  }
}
