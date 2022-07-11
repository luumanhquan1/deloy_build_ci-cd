class RoomChatRequest {
  final String roomId;
  final List<PeopleChatRequest> peopleChats;
  final int colorChart;

  RoomChatRequest(
      {required this.roomId,
      required this.peopleChats,
      required this.colorChart});
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['room_id'] = roomId;
    map['people_chat'] = peopleChats.map((e) => e.toJson()).toList();
    map['color_chart'] = colorChart;
    return map;
  }
}

class PeopleChatRequest {
  final String userId;
  final String avatarUrl;
  final String nameDisplay;
  final String bietDanh;
  PeopleChatRequest(
      {required this.userId,
      required this.avatarUrl,
      required this.nameDisplay,
      required this.bietDanh});
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['avatar_url'] = avatarUrl;
    map['name_display'] = nameDisplay;
    map['biet_danh'] = bietDanh;
    return map;
  }
}
