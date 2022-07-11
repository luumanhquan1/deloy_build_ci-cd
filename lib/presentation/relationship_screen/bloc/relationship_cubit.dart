import 'dart:developer';

import 'package:ccvc_mobile/config/base/base_cubit.dart';
import 'package:ccvc_mobile/data/services/message_service.dart';
import 'package:ccvc_mobile/data/services/profile_service.dart';
import 'package:ccvc_mobile/domain/locals/prefs_service.dart';
import 'package:ccvc_mobile/domain/model/login/user_info.dart';

import 'package:ccvc_mobile/domain/model/message_model/room_chat_model.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:ccvc_mobile/presentation/main_message/bloc/main_message_state.dart';
import 'package:ccvc_mobile/presentation/relationship_screen/bloc/relationship_state.dart';

import 'package:rxdart/rxdart.dart';
class RelationShipCubit extends BaseCubit<RelationshipState> {
  RelationShipCubit() : super(RelationshipStateStateIntial());

  final BehaviorSubject<List<UserInfoModel>> _getListFriend =
      BehaviorSubject<List<UserInfoModel>>();

  Stream<List<UserInfoModel>> get getListFriend => _getListFriend.stream;
  final idUser = PrefsService.getUserId();
   List<String> listIdFriend = [];
   List<String> listsIdFriendRequest = [];
  Future<void> fetchFriends(String id) async {
    showLoading();
    final result = await ProfileService.listFriends(id);
    showContent();
    _getListFriend.sink.add(result);
  }



}
