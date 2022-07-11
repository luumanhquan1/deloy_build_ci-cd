import 'package:ccvc_mobile/domain/model/comment_model.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:dartx/dartx.dart';

class FriendRequestModel {
  String? requestId;
  UserModel? sender;
  UserModel? receiver;
  int? createAt;
  int? updateAt;


  FriendRequestModel({this.requestId, this.sender, this.receiver, this.createAt,
    this.updateAt});

  FriendRequestModel.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'] as String?;
    createAt = json['create_at'] as int?;
    updateAt = json['update_at'] as int?;
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
    'sender': this.sender?.userId ?? '',
    'receiver': this.receiver?.userId ?? '',
    'create_at': this.createAt,
    'update_at': this.updateAt,
  };

  @override
  String toString() {
    return 'FriendRequestModel{requestId: $requestId, sender: $sender, receiver: $receiver, createAt: $createAt, updateAt: $updateAt}';
  }
}
