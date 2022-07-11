import 'package:ccvc_mobile/widgets/listener/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);
}

abstract class BaseState<T extends BaseScreen> extends State<T> {
  @override
  void initState() {
    super.initState();
    _handleEventBus();
  }

  final CompositeSubscription _unAuthSubscription = CompositeSubscription();

  void _handleEventBus() {
    eventBus.on<UnAuthEvent>().listen((event) {
      //todo
    }).addTo(_unAuthSubscription);
  }

  @override
  void dispose() {
    _unAuthSubscription.clear();
    super.dispose();
  }
}
