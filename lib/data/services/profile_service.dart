import 'dart:developer';

import 'package:ccvc_mobile/config/default_env.dart';
import 'package:ccvc_mobile/config/firebase_config.dart';
import 'package:ccvc_mobile/domain/locals/prefs_service.dart';
import 'package:ccvc_mobile/domain/model/profile_model.dart/friend_model.dart';
import 'package:ccvc_mobile/domain/model/profile_model.dart/friend_request_model.dart';

import '../../domain/model/login/user_info.dart';

class ProfileService {
  static Future<List<UserInfoModel>> listFriends(String id) async {
    final listIdFriend = await ProfileService.getIdsRelationShipUser();
    final listsIdFriendRequest = await ProfileService.getIdsFriendRequestUser();
    final idUser = PrefsService.getUserId();
    final List<UserInfoModel> data = [];
    final result = await FirebaseSetup.fireStore
        .collection(DefaultEnv.usersCollection)
        .doc(id)
        .collection(DefaultEnv.relationshipsCollection)
        .get();
    for (var element in result.docs) {
      final vl = FriendModel.fromJson(element.data());
      if (vl.userId2 != idUser) {
        final user = await getUserChat(vl.userId2);
        if (user != null) {
          user.peopleType = _peopleType(user.userId ?? '',listsIdFriendRequest,listIdFriend);
          data.add(user);
        }
      }
    }
    return data;
  }

 static PeopleType? _peopleType(
      String id, List<String> listsIdFriendRequest, List<String> listIdFriend) {

    if (listsIdFriendRequest.contains(id.trim())) {
      return PeopleType.FriendRequest;
    }
    if (listIdFriend.contains(id)) {
      return PeopleType.Friend;
    }
  }

  static Future<UserInfoModel?> getUserChat(String id) async {
    UserInfoModel? userProfile;
    final result = await FirebaseSetup.fireStore
        .collection(DefaultEnv.usersCollection)
        .doc(id)
        .collection(DefaultEnv.profileCollection)
        .get();

    for (final element in result.docs) {
      userProfile = UserInfoModel.fromJson(element.data());
    }
    return userProfile;
  }

  static Future<List<String>> getIdsRelationShipUser() async {
    final idUser = PrefsService.getUserId();
    final List<String> data = [];
    final result = await FirebaseSetup.fireStore
        .collection(DefaultEnv.usersCollection)
        .doc(idUser)
        .collection(DefaultEnv.relationshipsCollection)
        .get();
    for (var element in result.docs) {
      final vl = FriendModel.fromJson(element.data());
      data.add(vl.userId2);
    }
    return data;
  }

  static Future<List<String>> getIdsFriendRequestUser() async {
    final idUser = PrefsService.getUserId();
    final List<String> data = [];
    final result = await FirebaseSetup.fireStore
        .collection(DefaultEnv.usersCollection)
        .doc(idUser)
        .collection(DefaultEnv.friendRequestCollection)
        .get();
    for (var element in result.docs) {
      final vl = FriendRequestModel.fromJson(element.data());
      data.add(vl.receiverId);
    }
    return data;
  }
}
