import 'dart:developer';

import 'package:ccvc_mobile/config/firebase_config.dart';
import 'package:ccvc_mobile/data/exception/app_exception.dart';
import 'package:ccvc_mobile/domain/model/message_model/message_sms_model.dart';
import 'package:ccvc_mobile/domain/model/message_model/room_chat_model.dart';
import 'package:ccvc_mobile/presentation/message/bloc/message_cubit.dart';
import 'package:ccvc_mobile/presentation/message/widgets/header_mess_widget.dart';
import 'package:ccvc_mobile/presentation/message/widgets/send_sms_widget.dart';
import 'package:ccvc_mobile/presentation/message/widgets/sms_cell.dart';
import 'package:flutter/material.dart';

import '../../config/default_env.dart';
import '../../widgets/views/state_stream_layout.dart';

class MessageScreen extends StatefulWidget {
  final RoomChatModel? chatModel;
  final PeopleChat peopleChat;
  const MessageScreen({Key? key, this.chatModel, required this.peopleChat})
      : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  MessageCubit cubit = MessageCubit();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.chatModel != null) {
      cubit.initDate(widget.chatModel?.roomId ?? '', widget.peopleChat);
    } else {
      cubit.peopleChat = widget.peopleChat;
      cubit.getRoomChat(widget.peopleChat.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StateStreamLayout(
      retry: () {},
      error: AppException('', ''),
      stream: cubit.stateStream,
      textEmpty: '',
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              HeaderMessWidget(
                peopleChat: widget.peopleChat,
              ),
              const SizedBox(
                height: 16,
              ),
              StreamBuilder<String>(
                  stream: cubit.roomChat,
                  builder: (context, snapshot) {
                    final id = snapshot.data ?? '';
                    return Expanded(
                      child: SingleChildScrollView(
                        reverse: true,
                        child: StreamBuilder<List<MessageSmsModel>>(
                            stream: cubit.chatStream(id),
                            builder: (context, snapshot) {
                              final data = snapshot.data ?? <MessageSmsModel>[];
                              return Column(
                                children: List.generate(data.length, (index) {
                                  final result = data[index];
                                  return SmsCell(smsModel: result);
                                }),
                              );
                            }),
                      ),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SendSmsWidget(
                  hintText: 'Soạn tin nhắn...',
                  sendTap: (value) {
                    cubit.sendSms(value);
                  },
                  onSendFile: (value) {
                    cubit.sendImage(value);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
