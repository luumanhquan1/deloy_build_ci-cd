import 'dart:developer';

import 'package:ccvc_mobile/config/base/base_cubit.dart';
import 'package:ccvc_mobile/data/services/message_service.dart';
import 'package:ccvc_mobile/domain/locals/prefs_service.dart';

import 'package:ccvc_mobile/domain/model/message_model/room_chat_model.dart';
import 'package:ccvc_mobile/presentation/main_message/bloc/main_message_state.dart';

import 'package:rxdart/rxdart.dart';

class MainMessageCubit extends BaseCubit<MainMessageState> {
  MainMessageCubit() : super(MainMessageStateIntial()) {}

  final BehaviorSubject<List<RoomChatModel>> _getRoomChat =
      BehaviorSubject<List<RoomChatModel>>();

  Stream<List<RoomChatModel>> get getRoomChat => _getRoomChat.stream;
  final idUser = PrefsService.getUserId();
  void fetchRoom() {
    showLoading();
    MessageService.getRoomChat(idUser)?.listen((event) {
      showContent();
      _getRoomChat.sink.add(event);

    });
  }
}
