import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:flutter/material.dart';

class FlutterSwitchWidget extends StatefulWidget {
  const FlutterSwitchWidget({
    Key? key,
    required this.value,
    required this.onToggle,
    this.activeColor = numberOfCalenders,
    this.inactiveColor = textBodyTime,
    this.toggleColor = backgroundColorApp,
    this.activeToggleColor,
    this.inactiveToggleColor,
    this.width = 70.0,
    this.height = 35.0,
    this.toggleSize = 25.0,
    this.valueFontSize = 16.0,
    this.borderRadius = 20.0,
    this.padding = 4.0,
    this.showOnOff = true,
    this.switchBorder,
    this.activeSwitchBorder,
    this.inactiveSwitchBorder,
    this.toggleBorder,
    this.activeToggleBorder,
    this.inactiveToggleBorder,
    this.activeIcon,
    this.inactiveIcon,
    this.duration = const Duration(milliseconds: 200),
    this.disabled = false,
  })  : assert(
          (switchBorder == null || activeSwitchBorder == null) &&
              (switchBorder == null || inactiveSwitchBorder == null),
        ),
        assert(
          (toggleBorder == null || activeToggleBorder == null) &&
              (toggleBorder == null || inactiveToggleBorder == null),
        ),
        super(key: key);

  final bool value;
  final ValueChanged<bool> onToggle;

  final bool showOnOff;

  final Color activeColor;
  final Color inactiveColor;

  final Color toggleColor;

  final Color? activeToggleColor;

  final Color? inactiveToggleColor;

  final double width;

  final double height;

  final double toggleSize;

  final double valueFontSize;

  final double borderRadius;

  final double padding;

  final BoxBorder? switchBorder;

  final BoxBorder? activeSwitchBorder;

  final BoxBorder? inactiveSwitchBorder;

  final BoxBorder? toggleBorder;

  final BoxBorder? activeToggleBorder;

  final BoxBorder? inactiveToggleBorder;

  final Widget? activeIcon;

  final Widget? inactiveIcon;

  final Duration duration;

  final bool disabled;

  @override
  _FlutterSwitchState createState() => _FlutterSwitchState();
}

class _FlutterSwitchState extends State<FlutterSwitchWidget>
    with SingleTickerProviderStateMixin {
  late final Animation _toggleAnimation;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
      duration: widget.duration,
    );
    _toggleAnimation = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FlutterSwitchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value == widget.value) {
      return;
    }

    if (widget.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color _toggleColor = backgroundColorApp;
    Color _switchColor = backgroundColorApp;
    Border? _switchBorder;
    Border? _toggleBorder;

    if (widget.value) {
      _toggleColor = widget.activeToggleColor ?? widget.toggleColor;
      _switchColor = widget.activeColor;
      _switchBorder = widget.activeSwitchBorder as Border? ??
          widget.switchBorder as Border?;
      _toggleBorder = widget.activeToggleBorder as Border? ??
          widget.toggleBorder as Border?;
    } else {
      _toggleColor = widget.inactiveToggleColor ?? widget.toggleColor;
      _switchColor = widget.inactiveColor;
      _switchBorder = widget.inactiveSwitchBorder as Border? ??
          widget.switchBorder as Border?;
      _toggleBorder = widget.inactiveToggleBorder as Border? ??
          widget.toggleBorder as Border?;
    }

    // double _textSpace = widgets.width - widgets.toggleSize;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Align(
          child: GestureDetector(
            onTap: () {
              if (!widget.disabled) {
                if (widget.value) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
                widget.onToggle(!widget.value);
              }
            },
            child: Opacity(
              opacity: widget.disabled ? 0.6 : 1,
              child: Container(
                width: widget.width,
                height: widget.height,
                padding: EdgeInsets.all(widget.padding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  color: _switchColor,
                  border: _switchBorder,
                ),
                child: Stack(
                  children: <Widget>[
                    AnimatedOpacity(
                      opacity: widget.value ? 1.0 : 0.0,
                      duration: widget.duration,
                      child: Container(
                        // width: _textSpace,
                        // padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        alignment: Alignment.centerLeft,
                        child: _activeText,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedOpacity(
                        opacity: !widget.value ? 1.0 : 0.0,
                        duration: widget.duration,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: _inactiveText,
                        ),
                      ),
                    ),
                    Align(
                      alignment: _toggleAnimation.value,
                      child: Container(
                        width: widget.toggleSize,
                        height: widget.toggleSize,
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _toggleColor,
                          border: _toggleBorder,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget? get _activeText {
    if (widget.showOnOff) {
      return widget.activeIcon;
    }
  }

  Widget? get _inactiveText {
    if (widget.showOnOff) {
      return widget.inactiveIcon;
    }
  }
}
