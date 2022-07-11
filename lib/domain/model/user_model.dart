import 'package:hive/hive.dart';

part 'user_model.g.dart';


@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String? avatarUrl;
  @HiveField(1)
  String? userId;
  @HiveField(2)
  String? email;
  @HiveField(3)
  int? birthday;
  @HiveField(4)
  bool? gender;
  @HiveField(5)
  String? nameDisplay;
  @HiveField(6)
  bool? onlineFlag;
  @HiveField(7)
  int? createAt;
  @HiveField(8)
  int? updateAt;

  UserModel({
    this.avatarUrl,
    this.userId,
    this.email,
    this.birthday,
    this.gender,
    this.nameDisplay,
    this.onlineFlag,
    this.createAt,
    this.updateAt,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    nameDisplay = json['name_display'] as String?;
    gender = json['gender'] as bool?;
    onlineFlag = json['online_flag'] as bool?;
    email = json['email'] as String?;
    createAt = json['create_at'] as int?;
    updateAt = json['update_at'] as int?;
    avatarUrl = json['avatar_url'] as String?;
    userId = json['user_id'] as String?;
    birthday = json['birthday'] as int?;
  }

  Map<String, dynamic> toJson(UserModel instance) => <String, dynamic>{
        'email': instance.email,
        'user_id': instance.userId,
        'avatar_url': instance.avatarUrl,
        'gender': instance.gender,
        'name_display': instance.nameDisplay,
        'create_at': instance.createAt,
        'update_at': instance.updateAt,
        'online_flag': instance.onlineFlag,
        'birthday': instance.birthday
      };

  UserModel.empty();

  @override
  String toString() {
    return 'UserModel{avatarUrl: $avatarUrl, userId: $userId, email: $email, birthday: $birthday, gender: $gender, nameDisplay: $nameDisplay, onlineFlag: $onlineFlag, createAt: $createAt, updateAt: $updateAt}';
  }
}
