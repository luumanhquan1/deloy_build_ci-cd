import 'dart:async';

import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageDialogPopup extends StatefulWidget {
  final Function() onDismiss;
  final String urlIcon;
  final String title;
  const MessageDialogPopup({
    Key? key,
    required this.onDismiss,
    this.urlIcon = '',
    this.title = '',
  }) : super(key: key);

  @override
  State<MessageDialogPopup> createState() => _MessageDialogPopupState();
}

class _MessageDialogPopupState extends State<MessageDialogPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(const Duration(seconds: 2));
          animationController.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          widget.onDismiss();
        }
      });
    if (mounted) {
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        animationController.reverse();
      },
      child: Scaffold(
        backgroundColor: Colors.black38,
        body: Center(
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, _) => Opacity(
              opacity: animationController.value,
              child: Transform(
                transform: Matrix4.identity()
                  ..scale(animationController.value, animationController.value),
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  padding:
                     const  EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  constraints: const BoxConstraints(minWidth: 300),
                  decoration: BoxDecoration(
                    color: backgroundColorApp,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: shadowContainerColor.withOpacity(0.05),
                        blurRadius: 10,
                        offset:
                            const Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        widget.urlIcon,
                        width: 56,
                        height: 56,
                      ),
                      spaceH32,
                      Text(
                        widget.title,
                        style:
                            textNormalCustom(fontSize: 18, color: titleColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
