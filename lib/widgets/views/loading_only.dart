import 'package:ccvc_mobile/widgets/dialog/cupertino_loading.dart';
import 'package:ccvc_mobile/widgets/views/state_layout.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoadingOnly extends StatelessWidget {
  final Stream<StateLayout> stream;
  final Widget child;

  const LoadingOnly({Key? key, required this.child, required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StateLayout>(
      stream: stream,
      builder: (context, snapshot) {
        return ModalProgressHUD(
          inAsyncCall: snapshot.data == StateLayout.showLoading,
          progressIndicator: const CupertinoLoading(),
          child: child,
        );
      },
    );
  }
}

class ModalProgressHUD extends StatefulWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget child;

  const ModalProgressHUD({
    Key? key,
    required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.progressIndicator = const CircularProgressIndicator.adaptive(),
    this.offset,
    this.dismissible = false,
    required this.child,
  }) : super(key: key);

  @override
  State<ModalProgressHUD> createState() => _ModalProgressHUDState();
}

class _ModalProgressHUDState extends State<ModalProgressHUD> {
  Size size = const Size(0, 0);
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final renderBox = context.findRenderObject() as RenderBox;
      size = renderBox.size;
      _isAsyncCall.sink.add(widget.inAsyncCall);
    });
  }

  @override
  void didUpdateWidget(covariant ModalProgressHUD oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    final renderBox = context.findRenderObject() as RenderBox;
    size = renderBox.size;
    _isAsyncCall.sink.add(widget.inAsyncCall);
  }

  final BehaviorSubject<bool> _isAsyncCall = BehaviorSubject();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _isAsyncCall.close();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          widget.child,
          StreamBuilder<bool>(
              stream: _isAsyncCall.stream,
              builder: (context, snapshot) {
                return Visibility(
                  visible: widget.inAsyncCall,
                  child: Positioned(
                      top: size.height / 2 - 50,
                      right: size.width / 2 - 50,
                      child: Center(child: widget.progressIndicator)),
                );
              }),
          StreamBuilder<bool>(
              stream: _isAsyncCall.stream,
              builder: (context, snapshot) {
                return Visibility(
                  visible: widget.inAsyncCall,
                  child: Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
