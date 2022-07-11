import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:ccvc_mobile/generated/l10n.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

class CommentModel {
  String? postId;
  UserModel? author;
  String? commentId;
  String? data;
  int? createAt;

  CommentModel(
      {this.postId,
      this.author,
      this.commentId,
      this.data,
      this.createAt});

  CommentModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'] as String?;
    data = json['data'] as String?;
    createAt = json['create_at'] as int?;
    commentId = json['comment_id'] as String?;
  }
  Map<String, dynamic> ToJson() =>
      <String, dynamic>{
        'user_id': this.author?.userId,
        'data': this.data,
        'create_at': this.createAt,
      };

  @override
  String toString() {
    return 'CommentModel{postId: $postId, author: $author, commentId: $commentId, data: $data, createAt: $createAt}';
  }
}
