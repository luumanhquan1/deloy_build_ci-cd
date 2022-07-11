import 'package:ccvc_mobile/main.dart';
import 'package:ccvc_mobile/presentation/login/ui/login_screen.dart';

import 'package:ccvc_mobile/presentation/tabbar_screen/ui/main_screen.dart';

import 'package:ccvc_mobile/utils/extensions/size_extension.dart';
import 'package:ccvc_mobile/widgets/dialog/message_dialog/message_config.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    SizeConfig.init(context);
    MessageConfig.init(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      initialData: AppStateCt.of(context).appState.token,
      stream: AppStateCt.of(context).appState.getToken,
      builder: (context, snapshot) {
        final data = snapshot.data ?? '';
        return screen(data);
      },
    );
  }

  Widget screen(String token) {
    if (token.isNotEmpty) {
      return const MainTabBarView();
    } else {
      return const LoginScreen();
    }
  }
}
