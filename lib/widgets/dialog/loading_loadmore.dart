import 'package:ccvc_mobile/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

class LoadingItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppTheme.getInstance().primaryColor(),
      ),
    );
  }
}
