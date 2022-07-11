import 'package:ccvc_mobile/domain/model/comment_model.dart';
import 'package:ccvc_mobile/domain/model/user_model.dart';
import 'package:dartx/dartx.dart';

class PostModel {
  String? postId;
  UserModel? author;
  int? type;
  String? content;
  int? createAt;
  String? imageUrl;
  int? updateAt;
  List<String>? likes;
  List<CommentModel>? comments;

  PostModel(
      {this.postId,
      this.author,
      this.type,
      this.content,
      this.createAt,
      this.imageUrl,
      this.updateAt,
      this.likes,
      this.comments}); // factory PostModel.fromJson(Map<String, dynamic> json) =>

  PostModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'] as String?;
    type = json['type'] as int?;
    content = json['content'] as String?;
    createAt = json['create_at'] as int?;
    updateAt = json['update_at'] as int?;
    imageUrl = json['image_url'] as String?;
    if (json['likes'] != null) {
      likes = [];
      json['likes'].forEach((v) {
        likes!.add(v);
      });
    }
  }
  Map<String, dynamic> toJson(PostModel instance) => <String, dynamic>{
        'post_id': instance.postId,
        'user_id': instance.author?.userId ?? '',
        'image_url': instance.imageUrl,
        'type': instance.type,
        'content': instance.content,
        'create_at': instance.createAt,
        'update_at': instance.updateAt,
      };

  @override
  String toString() {
    return 'PostModel{postId: $postId, author: $author, type: $type, content: $content, createAt: $createAt, imageUrl: $imageUrl, updateAt: $updateAt, likes: $likes}';
  }

}
