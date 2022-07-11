import 'dart:async';
import 'dart:developer';

import 'package:ccvc_mobile/config/app_config.dart';
import 'package:ccvc_mobile/config/default_env.dart';
import 'package:ccvc_mobile/config/firebase_config.dart';
import 'package:ccvc_mobile/domain/locals/prefs_service.dart';
import 'package:ccvc_mobile/domain/model/message_model/message_sms_model.dart';
import 'package:ccvc_mobile/domain/model/message_model/message_user.dart';
import 'package:ccvc_mobile/domain/model/message_model/room_chat_model.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class MessageService {
  static Map<String, RoomChatModel> _idRoomChat = {};
  static Stream<List<RoomChatModel>>? getRoomChat(String idUser) {
    return FirebaseSetup.fireStore
        .collection(DefaultEnv.usersCollection)
        .doc(idUser)
        .collection(DefaultEnv.messCollection)
        .orderBy("update_at", descending: true)
        .snapshots()
        .transform(
      StreamTransformer.fromHandlers(
        handleData: (docSnap, sink) async {
          final data = <RoomChatModel>[];
          await Future.forEach(docSnap.docs,
              (QueryDocumentSnapshot<Map<String, dynamic>> element) async {
            if (!_idRoomChat.keys.contains(element.id)) {
              final profileRoom = await FirebaseSetup.fireStore
                  .collection(DefaultEnv.messCollection)
                  .doc(element.id)
                  .get();
              final jsonProfileRoom = profileRoom.data();
              if (jsonProfileRoom != null) {
                final listPeople = await _getChatRoomUser(
                    jsonProfileRoom['people_chat'] as List<dynamic>, idUser);
                final room = RoomChatModel(
                    roomId: element.id,
                    peopleChats: listPeople,
                    colorChart: jsonProfileRoom['color_chart']);
                data.add(room);
                _idRoomChat.addAll({element.id: room});
              }
            } else {
              if (_idRoomChat[element.id] != null) {
                data.add(_idRoomChat[element.id]!);
              }
            }
          });
          sink.add(data);
        },
      ),
    );
  }

  static Future<UserModel> getUserChat(String id) async {
    late UserModel userProfile;
    final result = await FirebaseSetup.fireStore
        .collection(DefaultEnv.usersCollection)
        .doc(id)
        .collection(DefaultEnv.profileCollection)
        .get();
    for (final element in result.docs) {
      log('${element.data()}');
      userProfile = UserModel.fromJson(element.data());
    }
    return userProfile;
  }

  static Future<List<PeopleChat>> _getChatRoomUser(
      List<dynamic> data, String idUser) async {
    final pepole = <PeopleChat>[];
    for (final element in data) {
      final id = element['user_id'];
      if (id != idUser) {
        final userInfo = await getUserChat(id.toString());
        pepole.add(
          PeopleChat(
            userId: id,
            avatarUrl: userInfo.avatarUrl ?? '',
            nameDisplay: userInfo.nameDisplay ?? '',
            bietDanh: element['biet_danh'],
          ),
        );
      }
    }
    return pepole;
  }

  static Stream<List<MessageSmsModel>>? smsRealTime(String idRoom) {
    final String idUser = PrefsService.getUserId();
    try {
      return FirebaseSetup.fireStore
          .collection(DefaultEnv.messCollection)
          .doc(idRoom)
          .collection(idRoom)
          .orderBy('create_at', descending: false)
          .snapshots()
          .transform(
        StreamTransformer.fromHandlers(
          handleData: (docSnap, sink) {
            final data = <MessageSmsModel>[];
            docSnap.docs.forEach((element) {
              final json = element.data();
              final result = MessageSmsModel.fromJson(json);
              if (result.senderId != idUser &&
                  result.daXem?.contains(idUser) == false) {
                _updateDaXemSms(idRoom, element.id, idUser);
              }
              data.add(result);
            });
            sink.add(data);
          },
        ),
      );
    } catch (e) {}
  }

  static Stream<List<MessageSmsModel>>? smsRealTimeMain(String idRoom) {
    final String idUser = PrefsService.getUserId();
    try {
      return FirebaseSetup.fireStore
          .collection(DefaultEnv.messCollection)
          .doc(idRoom)
          .collection(idRoom)
          .orderBy('create_at', descending: true)
          .limit(6)
          .snapshots()
          .transform(
        StreamTransformer.fromHandlers(
          handleData: (docSnap, sink) {
            final data = <MessageSmsModel>[];
            docSnap.docs.forEach((element) {
              final json = element.data();
              final result = MessageSmsModel.fromJson(json);
              if (result.senderId != idUser &&
                  result.daXem?.contains(idUser) == false) {
                result.isDaXem = false;
                data.add(result);
              }
            });
            if (data.isEmpty) {
              if (docSnap.docs.isNotEmpty) {
                final doc = docSnap.docs.first;
                final result = MessageSmsModel.fromJson(doc.data());
                result.isDaXem = true;
                data.add(result);
              }
            }
            sink.add(data);
          },
        ),
      );
    } catch (e) {}
  }

  static void sendSms(String idRoom, MessageSmsModel messageSmsModel) {
    final doc = FirebaseSetup.fireStore
        .collection(DefaultEnv.messCollection)
        .doc(idRoom)
        .collection(idRoom)
        .doc(messageSmsModel.messageId);
    doc.set(messageSmsModel.toJson());
  }

  static Future<List<RoomChatModel>> findRoomChat(String idUser) async {
    final result = <RoomChatModel>[];
    final listRoom = await FirebaseSetup.fireStore
        .collection(DefaultEnv.messCollection)
        .get();
    await Future.forEach(listRoom.docs,
        (QueryDocumentSnapshot<Map<String, dynamic>> item) async {
      final data = await FirebaseSetup.fireStore
          .collection(DefaultEnv.messCollection)
          .doc(item.id)
          .get();
      final room = RoomChatModel.fromJson(data.data() ?? {});
      result.add(room);
    });

    return result;
  }

  static Future<String> createRoomChat(RoomChatModel roomChatModel) async {
    await FirebaseSetup.fireStore
        .collection(DefaultEnv.messCollection)
        .doc(roomChatModel.roomId)
        .set(roomChatModel.toJson());
    roomChatModel.peopleChats.forEach((element) {
      _addUserRoomChat(element.userId, roomChatModel.roomId);
    });
    return roomChatModel.roomId;
  }

  static void _addUserRoomChat(String id, String idRoom) {
    FirebaseSetup.fireStore
        .collection(DefaultEnv.usersCollection)
        .doc(id)
        .collection(DefaultEnv.messCollection)
        .doc(idRoom)
        .set(MessageUser(
                id: idRoom,
                createAt: DateTime.now().millisecondsSinceEpoch,
                updateAt: DateTime.now().millisecondsSinceEpoch)
            .toJson());
  }

  static void updateRoomChatUser(String idUser, String idRoom) {
    FirebaseSetup.fireStore
        .collection(DefaultEnv.usersCollection)
        .doc(idUser)
        .collection(DefaultEnv.messCollection)
        .doc(idRoom)
        .update({'update_at': DateTime.now().millisecondsSinceEpoch});
  }

  static void _updateDaXemSms(String idRoom, String idSms, String idUser) {
    FirebaseSetup.fireStore
        .collection(DefaultEnv.messCollection)
        .doc(idRoom)
        .collection(idRoom)
        .doc(idSms)
        .update({
      'da_xem': FieldValue.arrayUnion([idUser])
    });
  }
}
