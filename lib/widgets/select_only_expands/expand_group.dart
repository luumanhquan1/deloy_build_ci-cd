import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ExpandGroup extends StatefulWidget {
  final Widget child;
  const ExpandGroup({Key? key, required this.child}) : super(key: key);

  @override
  _ExpandGroupState createState() => _ExpandGroupState();
}

class _ExpandGroupState extends State<ExpandGroup> {
  final Map<UniqueKey, bool> validator = {};
  final _expand = BehaviorSubject<bool>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _expand.close();
  }

  @override
  Widget build(BuildContext context) {
    return GroupProvider(
      stream: _expand.stream,
      onChange: () {
        _expand.sink.add(true);
      },
      validator: validator,
      child: widget.child,
    );
  }
}

class GroupProvider extends InheritedWidget {
  final Map<UniqueKey, bool> validator;
  final Stream<bool> stream;
  final Function() onChange;
  const GroupProvider({
    Key? key,
    required this.validator,
    required this.stream,
    required Widget child,
    required this.onChange,
  }) : super(key: key, child: child);
  void expand(UniqueKey keyExpand) {
    validator.forEach((key, value) {
      if (value == true && key != keyExpand) {
        validator[key] = false;
      }
    });

      validator[keyExpand] = !(validator[keyExpand] ?? false);

    onChange();
  }

  static GroupProvider? of(BuildContext context) {
    final GroupProvider? result =
        context.dependOnInheritedWidgetOfExactType<GroupProvider>();
    if (result == null) {
      return null;
    }
    return result;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
