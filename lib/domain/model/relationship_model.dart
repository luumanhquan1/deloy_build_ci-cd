import 'package:ccvc_mobile/domain/model/comment_model.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:dartx/dartx.dart';

class RelationshipModel {
  String? relationshipId;
  UserModel? user1;
  UserModel? user2;
  int? createAt;
  int? updateAt;
  int? type;

  RelationshipModel(
      {this.user2,
        this.relationshipId,
        this.user1,
        this.type,
        this.createAt,
        this.updateAt,
        }); // factory PostModel.fromJson(Map<String, dynamic> json) =>

  RelationshipModel.fromJson(Map<String, dynamic> json) {
    relationshipId = json['relationship_id'] as String?;
    type = json['type'] as int?;
    createAt = json['create_at'] as int?;
    updateAt = json['update_at'] as int?;
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
    'user_id1': this.user1?.userId ?? '',
    'user_id2': this.user2?.userId ?? '',
    'type': this.type,
    'create_at': this.createAt,
    'update_at': this.updateAt,
  };

}
