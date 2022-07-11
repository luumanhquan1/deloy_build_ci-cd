import 'package:ccvc_mobile/config/resources/color.dart';

import 'package:ccvc_mobile/config/themes/app_theme.dart';
import 'package:ccvc_mobile/presentation/tabbar_screen/ui/tabbar_item.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BottomTabBarWidget extends StatelessWidget {
  final int selectItemIndex;
  final Function(TabBarType) onChange;

  const BottomTabBarWidget({
    Key? key,
    required this.selectItemIndex,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listItem = getTabListItem();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 19),
      clipBehavior: Clip.antiAlias,
      decoration:  BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 15,
          )
        ],
        borderRadius:  const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: List.generate(listItem.length, (index) {
            final tab = listItem[index];

            return tab == TabBarType.empty
                ? const Expanded(child: SizedBox())
                : Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        onChange(tab);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: tabBarItem(
                          context: context,
                          item: tab,
                          isSelect: index == selectItemIndex,
                        ),
                      ),
                    ),
                  );
          }),
        ),
      ),
    );
  }

  Widget tabBarItem({
    required BuildContext context,
    required TabBarType item,
    bool isSelect = false,
  }) {
    return item.getTabBarItem(isSelect: isSelect);
  }
}
