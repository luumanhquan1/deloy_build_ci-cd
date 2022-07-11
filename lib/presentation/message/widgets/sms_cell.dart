import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/domain/model/message_model/message_sms_model.dart';
import 'package:ccvc_mobile/presentation/message/message_sms_extension.dart';
import 'package:flutter/material.dart';

class SmsCell extends StatelessWidget {
  final MessageSmsModel smsModel;
  const SmsCell({Key? key, required this.smsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = smsModel.isMe();
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child:  smsModel.smsType.getSmsWidget(context,smsModel),
    );
  }
}
