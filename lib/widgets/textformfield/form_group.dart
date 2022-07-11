
import 'package:flutter/material.dart';

class FormGroup extends StatefulWidget {
  final Widget child;
  const FormGroup({Key? key, required this.child})
      : super(key: key);

  @override
  FormGroupState createState() => FormGroupState();
}

class FormGroupState extends State<FormGroup> {
  final Map<GlobalKey<FormState>, bool> _validator = {};

  bool checkValidator() {
    final result=  _validator.values.contains(false);
    if(result ==true){
      return false;
    }
    return true;
  }
  bool validator() {
    for(var vl in _validator.keys){
      _validator[vl] =  vl.currentState!.validate();
    }
    final result=  _validator.values.contains(false);
    if(result ==true){
      return false;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return FormProvider(validator: _validator, child: widget.child);
  }
}

class FormProvider extends InheritedWidget {
  final Map<GlobalKey<FormState>, bool> validator;
  const FormProvider({
    Key? key,
    required this.validator,
    required Widget child,
  }) : super(key: key, child: child);

  static FormProvider? of(BuildContext context) {
    final FormProvider? result =
        context.dependOnInheritedWidgetOfExactType<FormProvider>();
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
