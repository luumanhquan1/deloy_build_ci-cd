import 'package:cached_network_image/cached_network_image.dart';
import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/domain/model/message_model/room_chat_model.dart';
import 'package:flutter/material.dart';
class HeaderMessWidget extends StatelessWidget {
  final PeopleChat peopleChat;
  const HeaderMessWidget({Key? key,required this.peopleChat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: const BoxDecoration(
          color: Color(0xffE1F6F4),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(34),
              bottomRight: Radius.circular(34))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    imageUrl:
                    peopleChat.avatarUrl,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      peopleChat.nameDisplay,
                      style: textNormal(colorBlack, 20),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Text(
                      'Online',
                      style: textNormal(greyHide, 12),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
