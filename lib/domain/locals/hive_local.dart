import 'dart:async';

import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:hive/hive.dart';
import 'package:queue/queue.dart';

class HiveLocal {
  static const USER_INFO = 'USER_INFO';
  static late Box<UserModel> _userBox;

  static Future<void> init() async {
    Hive.registerAdapter(UserModelAdapter());

    final que = Queue(parallel: 5);

    unawaited(
      que.add(() async => _userBox = await Hive.openBox<UserModel>(USER_INFO)),
    );
    await que.onComplete;
    que.cancel();
  }

  static Future<void> removeDataUser() async {
    await _userBox.clear();
  }

  static Future<void> saveDataUser(UserModel user) async {
    await _userBox.add(user);
  }

  static Future<void> updateDataUser(UserModel user) async {
    await removeDataUser();
    await saveDataUser(user);
  }

  static UserModel? getDataUser() {
    final data = _userBox.values;
    if (data.isNotEmpty) {
      return data.first;
    }
    return null;
  }
}
