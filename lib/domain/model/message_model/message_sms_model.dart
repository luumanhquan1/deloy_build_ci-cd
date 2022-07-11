import 'dart:developer';

import 'package:ccvc_mobile/config/app_config.dart';
import 'package:ccvc_mobile/domain/locals/prefs_service.dart';
import 'package:uuid/uuid.dart';

enum SmsType { Sms, Image }

extension smsTypeExtension on SmsType {
  int getInt() {
    switch (this) {
      case SmsType.Sms:
        return 0;
      case SmsType.Image:
        return 1;
    }
  }
}

class MessageSmsModel {
  String? id;
  String? senderId;
  String? content;
  int? loaiTinNhan;
  String? messageId;
  List<String>? daXem;
  SmsType smsType = SmsType.Sms;
  bool isDaXem = false;
  MessageSmsModel(
      {this.id,
      this.senderId,
      this.content,
      this.loaiTinNhan,
      this.messageId,
      this.daXem = const []}) {
    smsType = fromEnum(loaiTinNhan ?? 0);
  }
  bool isMe() {
    final idUser = PrefsService.getUserId();
    if (senderId == idUser) {
      return true;
    }
    return false;
  }

  SmsType fromEnum(int loaiTinNhan) {
    switch (loaiTinNhan) {
      case 0:
        return SmsType.Sms;
      case 1:
        return SmsType.Image;
    }
    return SmsType.Sms;
  }

  Map<String, dynamic> toJson() {
    final idUser = PrefsService.getUserId();
    final map = <String, dynamic>{};
    map['message_id'] = messageId;
    map['message_type_id'] = loaiTinNhan;
    map['create_at'] = DateTime.now().millisecondsSinceEpoch;
    map['sender_id'] = idUser;
    map['content'] = content;
    map['channel_id'] = id;
    map['da_xem'] = daXem;
    return map;
  }

  MessageSmsModel.fromJson(Map<String, dynamic> json) {
    id = json['message_id'];
    senderId = json['sender_id'];
    content = json['content'];
    loaiTinNhan = json['message_type_id'];
    if (json['da_xem'] is List) {
      (json['da_xem'] as List).forEach((element) {
        if(daXem == null){
          daXem = [element];
        }else {
          daXem!.add(element);
        }
      });
    }
    smsType = fromEnum(loaiTinNhan ?? 0);
  }
}
