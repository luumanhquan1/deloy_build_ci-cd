import 'dart:developer';
import 'package:ccvc_mobile/config/base/base_cubit.dart';
import 'package:ccvc_mobile/config/default_env.dart';
import 'package:ccvc_mobile/data/helper/firebase/firebase_authentication.dart';
import 'package:ccvc_mobile/data/helper/firebase/firebase_store.dart';
import 'package:ccvc_mobile/domain/locals/hive_local.dart';
import 'package:ccvc_mobile/domain/locals/prefs_service.dart';
import 'package:ccvc_mobile/domain/model/post_model.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:ccvc_mobile/domain/repository/post_repository.dart';
import 'package:ccvc_mobile/domain/repository/user_repository.dart';
import 'package:ccvc_mobile/presentation/personal/bloc/personal_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';

class PersonalCubit extends BaseCubit<PersonalState> {
  PersonalCubit() : super(PersonalStateInitial()) {
    userId = PrefsService.getUserId();
    log(userId);
    getUserInfo(userId);
  }

  String userId = '';

  final BehaviorSubject<UserModel> _user =
      BehaviorSubject<UserModel>.seeded(UserModel());

  Stream<UserModel> get user => _user.stream;

  UserRepopsitory _userRepopsitory = UserRepopsitory();

  Future<void> getUserInfo(userId) async {
    showLoading();
    try {
      final result = await _userRepopsitory.getUserProfile(userId: userId);
      if (result != null) {
        log('pppp' + result.toString());
        _user.sink.add(result);
        showContent();
      } else {
        showError();
      }
    } catch (e) {
      log(e.toString());
      showError();
    }
  }

  Future<void> logOut() async {
    final UserModel userInfo = HiveLocal.getDataUser() ?? UserModel.empty();
    // await FirebaseAuthentication.logout();
    userInfo.onlineFlag = false;
    await FireStoreMethod.updateUser(userInfo.userId ?? '', userInfo);
    await PrefsService.removeUserId();
    await PrefsService.removePasswordPresent();
    await HiveLocal.removeDataUser();
  }
}
