import 'package:flutter/material.dart';

void openScreen(BuildContext context, String screenName, {dynamic args}) {
  Navigator.of(context).pushNamed(screenName, arguments: args);
  // Get.toNamed(screenName, arguments: args);
}

void openScreenWithData(BuildContext context, String screenName, Object args) {
  Navigator.of(context).pushNamed(screenName, arguments: args);
}

void openScreenWithDataForResult(
  BuildContext context,
  String screenName,
  Object args,
  Function action,
) {
  Navigator.of(context).pushNamed(screenName, arguments: args).then((result) {
    if (result != null) {
      action(result);
    }
  });
}

void replaceScreen(BuildContext context, String screenName) {
  Navigator.of(context).pushReplacementNamed(screenName);
}

void openScreenAndRemoveUtil(
  BuildContext context,
  String screenName, {
  dynamic args,
}) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    screenName,
    (Route<dynamic> route) => false,
    arguments: args,
  );
}

void popUntilName(BuildContext context, String screenName) {
  Navigator.of(context).popUntil(ModalRoute.withName(screenName));
}

void popToFirst(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}

void closeScreen(BuildContext context, {dynamic args}) {
  Navigator.of(context).pop(args);
}

void closeScreenWithData(BuildContext context, Object? args) {
  Navigator.of(context).pop(args);
}

void goTo(BuildContext context, Widget screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}
