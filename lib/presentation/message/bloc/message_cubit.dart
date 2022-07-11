import 'dart:io';

import 'package:ccvc_mobile/config/base/base_cubit.dart';
import 'package:ccvc_mobile/config/default_env.dart';
import 'package:ccvc_mobile/data/services/message_service.dart';
import 'package:ccvc_mobile/domain/locals/hive_local.dart';
import 'package:ccvc_mobile/domain/locals/prefs_service.dart';
import 'package:ccvc_mobile/domain/model/message_model/message_sms_model.dart';
import 'package:ccvc_mobile/domain/model/message_model/room_chat_model.dart';

import 'package:ccvc_mobile/presentation/tabbar_screen/bloc/main_state.dart';
import 'package:ccvc_mobile/utils/extensions/string_extension.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../../data/helper/firebase/firebase_const.dart';

class MessageCubit extends BaseCubit<MainState> {
  MessageCubit() : super(MainStateInitial()){
    showContent();
  }
  final String idUser = PrefsService.getUserId();
  String idRoomChat = '';
  final BehaviorSubject<String> _roomChat =  BehaviorSubject<String>();

  late PeopleChat peopleChat;
  Stream<String> get roomChat => _roomChat.stream;
void initDate(String id,PeopleChat peopleChat){
  idRoomChat = id;
  this.peopleChat = peopleChat;
  _roomChat.sink.add(id);
}
  Future<void> sendSms(String content, {SmsType smsType = SmsType.Sms}) async {
  if(idRoomChat.isEmpty){
    idRoomChat = await createRoomChatDefault(peopleChat);
    MessageService.sendSms(
      idRoomChat,
      MessageSmsModel(
        daXem: [idUser],
        messageId: const Uuid().v1(),
        id: idRoomChat,
        senderId: idUser,
        content: content,
        loaiTinNhan: smsType.getInt(),
      ),
    );
  }else {
    MessageService.sendSms(
      idRoomChat,
      MessageSmsModel(
        daXem: [idUser],
        messageId: const Uuid().v1(),
        id: idRoomChat,
        senderId: idUser,
        content: content,
        loaiTinNhan: smsType.getInt(),
      ),
    );
    MessageService.updateRoomChatUser(idUser, idRoomChat);
    MessageService.updateRoomChatUser(peopleChat.userId, idRoomChat);

  }
  }

  Future<void> sendImage(File file) async {
    final Reference ref = storage
        .ref()
        .child(DefaultEnv.messCollection)
        .child(idRoomChat)
        .child(file.path.convertNameFile());
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
   await sendSms(url, smsType: SmsType.Image);
  }

  Stream<List<MessageSmsModel>>? chatStream(String idRoom) {
    return MessageService.smsRealTime(idRoom);
  }

  Future<void> getRoomChat(String idUserChat) async {
    showLoading();
    final data = await MessageService.findRoomChat(idUserChat);
    showContent();
    for (var element in data) {
      final peopleChatId = element.peopleChats.map((e) => e.userId);
      if (peopleChatId.contains(idUserChat) &&
          peopleChatId.contains(idUser) &&
          peopleChatId.length == 2) {
        idRoomChat = element.roomId;
        _roomChat.sink.add(idRoomChat);

        return;
      }
    }
  }
  Future<String> createRoomChatDefault(PeopleChat peopleChat) async {
  final idRoomChat = Uuid().v1();
  final userCurrent = HiveLocal.getDataUser();
      final room = RoomChatModel(
          roomId: idRoomChat,
          peopleChats: [
            PeopleChat(userId: idUser,
                avatarUrl: userCurrent?.avatarUrl ?? '',
                nameDisplay: userCurrent?.nameDisplay ??'',
                bietDanh: '',),
            PeopleChat(userId: peopleChat.userId,
                avatarUrl: peopleChat.avatarUrl,
                nameDisplay: peopleChat.nameDisplay,
                bietDanh: '',)
          ],
          colorChart: 0);
      _roomChat.sink.add(room.roomId);
    return MessageService.createRoomChat(room);
  }
}
