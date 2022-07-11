import 'dart:typed_data';

import 'package:ccvc_mobile/data/helper/firebase/firebase_const.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:ccvc_mobile/utils/constants/dafault_env.dart';
import 'package:ccvc_mobile/utils/extensions/string_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:html_editor_enhanced/utils/utils.dart';

class FireStoreMethod {
  static Future<UserModel> getDataUserInfo(String id) async {
    final QuerySnapshot<dynamic> snap = await FirebaseFirestore.instance
        .collection(DefaultEnv.socialNetwork)
        .doc(DefaultEnv.develop)
        .collection(DefaultEnv.users)
        .doc(id)
        .collection(DefaultEnv.profile)
        .get();

    final UserModel userInfo = UserModel.fromJson(
      snap.docs.first.data(),
    );
    return userInfo;
  }

  static Future<void> updateUser(
    String userId,
      UserModel model,
  ) async {
    try {
      final QuerySnapshot<dynamic> snap = await FirebaseFirestore.instance
          .collection(DefaultEnv.socialNetwork)
          .doc(DefaultEnv.develop)
          .collection(DefaultEnv.users)
          .doc(userId)
          .collection(DefaultEnv.profile)
          .get();

      await FirebaseFirestore.instance
          .collection(DefaultEnv.socialNetwork)
          .doc(DefaultEnv.develop)
          .collection(DefaultEnv.users)
          .doc(userId)
          .collection(DefaultEnv.profile)
          .doc(snap.docs.first.id)
          .update(model.toJson(model));
    } catch (e) {
      print(e);
    }
  }

  static Future<void> saveInformationUser({
    required String id,
    required UserModel user,
  }) async {
    await firestore
        .collection(DefaultEnv.socialNetwork)
        .doc(DefaultEnv.develop)
        .collection(DefaultEnv.users)
        .doc(id)
        .collection(DefaultEnv.profile)
        .doc(getRandString(15).removeChar)
        .set(
          user.toJson(user),
        );
  }

  static Future<void> uploadImageToStorage(String id, Uint8List file) async {
    try {
      final Reference ref = storage.ref().child(id).child('avatarUser');


      await ref.putData(file);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> removeImage(String id) async {
    try {
      final Reference ref = storage.ref().child(id);
      await ref.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<String> downImage(String id) async {
    String downUrlImage = '';
    try {
      downUrlImage =
          await storage.ref().child('$id/avatarUser').getDownloadURL();
    } catch (e) {
      print(e.toString());
    }
    return downUrlImage;
  }
}
