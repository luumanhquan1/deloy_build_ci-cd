import 'package:cached_network_image/cached_network_image.dart';
import 'package:ccvc_mobile/config/resources/color.dart';
import 'package:ccvc_mobile/config/resources/styles.dart';
import 'package:ccvc_mobile/domain/model/message_model/message_sms_model.dart';
import 'package:ccvc_mobile/widgets/skeleton/container_skeleton_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension SmsExtension on SmsType {
  Widget getSmsWidget(BuildContext context,MessageSmsModel model) {
    final isMe = model.isMe();
    switch (this) {
      case SmsType.Sms:
        return Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 100
          ),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.only(
                  bottomRight: const Radius.circular(20),
                  bottomLeft: const Radius.circular(20),
                  topRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                  topLeft: isMe
                      ? const Radius.circular(20)
                      : const Radius.circular(4))),
          padding: const EdgeInsets.all(16),
          child: Text(
            model.content ?? '',
            style: textNormal(greyHide, 12),
          ),
        );
      case SmsType.Image:
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          width: 250,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16))
          ),
          child: CachedNetworkImage(
            imageUrl:
           model.content ?? '',
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context,_,__){
              return const ContainerSkeletonWidget(
                width: 250,
                // height: 350,
              );
            },

          ),
        );
    }
  }
}
