import 'package:ccvc_mobile/config/base/base_cubit.dart';
import 'package:ccvc_mobile/data/helper/firebase/firebase_authentication.dart';
import 'package:ccvc_mobile/data/helper/firebase/firebase_store.dart';
import 'package:ccvc_mobile/domain/locals/hive_local.dart';
import 'package:ccvc_mobile/domain/locals/prefs_service.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_state.dart';

class LoginCubit extends BaseCubit<LoginState> {
  LoginCubit() : super(LoginStateIntial());

  bool isHideClearData = false;
  bool isCheckEye1 = true;
  bool isHideEye1 = false;
  bool passIsError = false;
  UserModel userInfo = UserModel.empty();

  Future<void> saveUser() async {
    userInfo = await FireStoreMethod.getDataUserInfo(PrefsService.getUserId());

    await HiveLocal.saveDataUser(userInfo);
  }

  Future<User?> lognIn(
    String email,
    String password,
  ) async {
    showLoading();
    final User? user = await FirebaseAuthentication.signInUsingEmailPassword(
      email: email,
      password: password,
    );

    if (user != null) {
      await PrefsService.saveUserId(user.uid);
      await PrefsService.savePasswordPresent(password);
      await saveUser();
      userInfo.onlineFlag = true;
      await HiveLocal.updateDataUser(userInfo);
      await FireStoreMethod.updateUser(userInfo.userId ?? '', userInfo);
    }
    showContent();
    return user;
  }

  void closeDialog() {
    showContent();
  }
}
