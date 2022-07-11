import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/widgets/select_only_expands/expand_group.dart';
import 'package:flutter/material.dart';

class ExpandOnlyWidget extends StatefulWidget {
  final bool initExpand;
  final Widget header;
  final Widget child;
  final bool isShowIcon;
  final AnimationController? initController;
  const ExpandOnlyWidget({
    Key? key,
    this.initExpand = false,
    required this.child,
    required this.header,
    this.isShowIcon = true,
    this.initController,
  }) : super(key: key);

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandOnlyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  bool isExpanded = false;
  GroupProvider? groupProvider;
  final key = UniqueKey();
  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    groupProvider = GroupProvider.of(context);
    findGroupExpanded();
  }

  void findGroupExpanded() {
    if (groupProvider != null) {
      groupProvider!.validator.addAll({key: widget.initExpand});
      groupProvider!.stream.listen((event) {
        _runExpandCheck();
      });
    }
    _runExpandCheck();
  }

  void prepareAnimations() {
    expandController = widget.initController ??
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.linear,
    );
  }

  void _runExpandCheck() {
    if (groupProvider != null) {
      final expand = groupProvider!.validator[key] ?? false;
      if (expand) {
        expandController.forward();
      } else {
        expandController.reverse();
      }
    } else {
      if (isExpanded) {
        expandController.forward();
      } else {
        expandController.reverse();
      }
    }
  }

  @override
  void didUpdateWidget(ExpandOnlyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (groupProvider != null) {
              groupProvider!.expand(key);
            } else {
              isExpanded = !isExpanded;
              _runExpandCheck();
            }
          },
          child: Row(
            children: [
              Flexible(child: widget.header),
              if (widget.isShowIcon)
                AnimatedBuilder(
                  animation: expandController,
                  builder: (context, _) {
                    return expandController.value == 0
                        ? const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: AqiColor,
                          )
                        : const Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: AqiColor,
                          );
                  },
                )
              else
                const SizedBox()
            ],
          ),
        ),
        SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: animation,
          child: widget.child,
        ),
      ],
    );
  }
}
