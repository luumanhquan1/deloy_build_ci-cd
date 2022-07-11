import 'package:cached_network_image/cached_network_image.dart';
import 'package:ccvc_mobile/domain/model/login/user_info.dart';

import 'package:ccvc_mobile/utils/constants/image_asset.dart';
import 'package:flutter/material.dart';

import '../../../config/resources/color.dart';
import '../../../config/resources/styles.dart';

class FriendCellWidget extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final PeopleType? peopleType;
  const FriendCellWidget(
      {Key? key,
      required this.name,
      required this.avatarUrl,
       this.peopleType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 62,
            width: 62,
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.teal),
              child: CachedNetworkImage(
                imageUrl: avatarUrl,
                errorWidget: (context, url, error) =>
                    Image.asset(ImageAssets.avatarDefault),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            name,
            style: textNormal(colorBlack, 16),
          ),
          const Expanded(child: SizedBox()),
          iconRight()
        ],
      ),
    );
  }

  Widget iconRight() {
    switch (peopleType) {
      case PeopleType.Friend:
        return const Icon(Icons.more_horiz);
      case PeopleType.FriendRequest:
        return button(backGround: mainTxtColor, onTap: (){}, title: 'Hủy');
      case PeopleType.NoFriend:
       return button(backGround: mainTxtColor, onTap: (){}, title: 'Thêm bạn bè');
    }
    return const SizedBox();
  }
  Widget button({required Color backGround,required Function() onTap,required String title}){
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        decoration: BoxDecoration(
          color: backGround,
          borderRadius: const BorderRadius.all(Radius.circular(4))
        ),
        child: Text(title,style: textNormalCustom(color: Colors.white),),
      ),
    );
  }
}
