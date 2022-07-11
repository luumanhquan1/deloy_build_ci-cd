import 'package:flutter/material.dart';

class ProviderWidget<T> extends InheritedWidget {
  final T cubit;

  const ProviderWidget({
    Key? key,
    required this.cubit,
    required Widget child,
  }) : super(key: key, child: child);

  static ProviderWidget<T> of<T>(BuildContext context) {
    final ProviderWidget<T>? result =
        context.dependOnInheritedWidgetOfExactType<ProviderWidget<T>>();
    assert(result != null, 'No element');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
