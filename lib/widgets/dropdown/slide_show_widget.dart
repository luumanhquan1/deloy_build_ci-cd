import 'package:flutter/material.dart';

class SlildeShowWidget extends StatefulWidget {
  final Widget child;

  const SlildeShowWidget({Key? key, required this.child}) : super(key: key);

  @override
  _SlildeShowWidgetState createState() => _SlildeShowWidgetState();
}

class _SlildeShowWidgetState extends State<SlildeShowWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _offsetFloat =
        Tween(begin: const Offset(0.0, -0.03), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _offsetFloat.addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetFloat,
      child: widget.child,
    );
  }
}
