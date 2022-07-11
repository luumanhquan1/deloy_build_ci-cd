import 'package:ccvc_mobile/config/themes/app_theme.dart';
import 'package:ccvc_mobile/presentation/change_password/ui/change_password_screen.dart';
import 'package:ccvc_mobile/presentation/home_screen/ui/home_screen.dart';
import 'package:ccvc_mobile/presentation/main_message/main_message_screen.dart';
import 'package:ccvc_mobile/presentation/update_user/ui/update_user_screen.dart';
import 'package:ccvc_mobile/presentation/message/message_screen.dart';
import 'package:ccvc_mobile/presentation/personal/ui/personal_screen.dart';

import 'package:ccvc_mobile/utils/constants/image_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TabBarType { home, likeTab, empty, message, profile }

List<TabBarType> getTabListItem() {
  return [
    TabBarType.home,
    TabBarType.likeTab,
    TabBarType.empty,
    TabBarType.message,
    TabBarType.profile,
  ];
}

class TabBarItem {
  Widget icon;
  String text;
  TabBarItem({required this.icon, required this.text});
}

extension TabbarEnum on TabBarType {
  int get index {
    switch (this) {
      case TabBarType.home:
        return 0;
      case TabBarType.likeTab:
        return 1;
      case TabBarType.message:
        return 2;
      case TabBarType.profile:
        return 3;
      default:
        return 1;
    }
  }

  Widget getScreen() {
    switch (this) {
      case TabBarType.home:
        return  HomeScreen();

      case TabBarType.likeTab:
        return Scaffold(
          backgroundColor: Colors.red,
          body: ChangePasswordScreen(),
        );
      case TabBarType.message:
        return const MainMessageScreen();
      case TabBarType.profile:
        return PersonalScreen();
      case TabBarType.empty:
        return const SizedBox();
    }
  }

  Widget getTabBarItem({bool isSelect = false}) {
    switch (this) {
      case TabBarType.home:
        return SvgPicture.asset(
          ImageAssets.icHome,
          color: isSelect
              ? AppTheme.getInstance().colorField()
              : AppTheme.getInstance().buttonUnfocus(),
          height: 20,
        );
      case TabBarType.likeTab:
        return SvgPicture.asset(
          ImageAssets.icTym,
          color: isSelect
              ? AppTheme.getInstance().colorField()
              : AppTheme.getInstance().buttonUnfocus(),
          height: 20,
        );
      case TabBarType.message:
        return SvgPicture.asset(
          ImageAssets.icMessage,
          height:20,
          color: isSelect
              ? AppTheme.getInstance().colorField()
              : AppTheme.getInstance().buttonUnfocus(),
        );
      case TabBarType.profile:
        return SvgPicture.asset(
          ImageAssets.icProfile,
          height: 20,
          color: isSelect
              ? AppTheme.getInstance().colorField()
              : AppTheme.getInstance().buttonUnfocus(),
        );

      case TabBarType.empty:
        return SvgPicture.asset(
          '',
          height: 20,
          color: isSelect
              ? AppTheme.getInstance().colorField()
              : AppTheme.getInstance().buttonUnfocus(),
        );
    }
  }
}

class TabScreen {
  Widget widget;
  TabBarType type;

  TabScreen({required this.widget, required this.type});
}
