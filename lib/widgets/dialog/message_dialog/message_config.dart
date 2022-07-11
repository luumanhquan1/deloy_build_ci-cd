import 'package:ccvc_mobile/utils/constants/image_asset.dart';
import 'package:ccvc_mobile/widgets/dialog/message_dialog/mess_dialog_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum MessState { error, success, customIcon }

class MessageConfig {
  static BuildContext? _context;
  static void init(BuildContext context) {
    if (_context != null) {
      return;
    }
    _context = context;
  }

  static void show({
    String title = '',
    String urlIcon = '',
    MessState messState = MessState.success,
  }) {
    final OverlayState? overlayState = Overlay.of(_context!);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return MessageDialogPopup(
          onDismiss: () {
            overlayEntry.remove();
          },
          urlIcon: _urlIcon(messState, urlIcon),
          title: title,
        );
      },
    );

    overlayState?.insert(overlayEntry);
  }

  static String _urlIcon(MessState messState, String urlIcon) {
    switch (messState) {
      case MessState.error:
        return "";
      case MessState.success:
        return "";
      case MessState.customIcon:
        return urlIcon;
    }
  }
}
