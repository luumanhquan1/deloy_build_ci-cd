class MessageUser{
  String? id;
  int? createAt;
  int? updateAt;

  MessageUser({this.id, this.createAt, this.updateAt});
  MessageUser.fromJson(Map<String,dynamic> json){
    id = json['id'] ?? '';
    createAt = json['create_at'] ?? 0;
    updateAt = json['update_at'] ?? 0;
  }
  Map<String,dynamic> toJson(){
    final data = <String,dynamic>{};
    data['id'] = id ?? '';
    data['create_at'] = createAt ?? 0;
    data['update_at'] = updateAt ?? 0;
    return data;
  }
}