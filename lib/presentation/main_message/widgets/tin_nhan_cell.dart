import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/data/services/message_service.dart';
import 'package:ccvc_mobile/domain/model/message_model/message_sms_model.dart';
import 'package:ccvc_mobile/domain/model/message_model/room_chat_model.dart';
import 'package:flutter/material.dart';

class TinNhanCell extends StatelessWidget {
  final PeopleChat peopleChat;
  final String idRoom;
  const TinNhanCell({Key? key, required this.peopleChat, required this.idRoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = peopleChat;

    return Container(
      height: 103,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: Row(
        children: [
          Container(
            height: 62,
            width: 62,
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all()),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.teal),
              child: CachedNetworkImage(
                imageUrl: data.avatarUrl,
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.nameDisplay,
                    style: textNormalCustom(color: colorBlack, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Expanded(
                    child: StreamBuilder<List<MessageSmsModel>>(
                      stream: MessageService.smsRealTimeMain(idRoom),
                      builder: (context, snapshot) {
                        final data = snapshot.data ?? <MessageSmsModel>[];
                        String title = '';
                        if (data.isNotEmpty) {
                          if(data.first.smsType == SmsType.Image){
                            title = 'Có 1 ảnh';
                          }else {
                            title = data.first.content ?? '';
                          }
                        }
                        return Row(
                          children: [
                            countChuaXem(data
                                .where((element) => element.isDaXem == false)
                                .length),
                            const SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: Text(
                                title,
                                style: textNormal(greyHide, 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget countChuaXem(int sum) {
    String index = sum > 5 ? '5+' : '$sum';
    return sum == 0
        ? const SizedBox()
        : Container(
            height: 20,
            width: 20,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              index,
              style: textNormal(Colors.white, 12),
            ),
          );
  }
}
