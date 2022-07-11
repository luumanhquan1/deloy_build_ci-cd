import 'package:hive/hive.dart';
part 'user_info.g.dart';

enum PeopleType { Friend, FriendRequest, NoFriend }

@HiveType(typeId: 0)
class UserInfoModel {
  @HiveField(0)
  String? userId;
  @HiveField(1)
  String? avatarUrl;
  @HiveField(2)
  String? email;
  @HiveField(3)
  int? birthday;
  @HiveField(4)
  bool? gender;
  @HiveField(5)
  String? nameDisplay;
  @HiveField(6)
  int? createAt;
  @HiveField(7)
  int? updateAt;
  PeopleType? peopleType;

  UserInfoModel({
    required this.userId,
    required this.avatarUrl,
    required this.email,
    required this.birthday,
    required this.gender,
    required this.nameDisplay,
    required this.createAt,
    required this.updateAt,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'];
    avatarUrl = json['avatar_url'];
    gender = json['gender'];
    userId = json['user_id'];
    nameDisplay = json['name_display'];
    updateAt = json['update_at'];

    createAt = json['create_at'];
    email = json['email'];
  }

  Map<String, dynamic> toJson(UserInfoModel instance) => <String, dynamic>{
        'email': instance.email,
        'user_id': instance.userId,
        'avatar_url': instance.avatarUrl,
        'gender': instance.gender,
        'name_display': instance.nameDisplay,
        'create_at': instance.createAt,
        'update_at': instance.updateAt,
        'birthday': instance.birthday
      };
  UserInfoModel.empty();
}
