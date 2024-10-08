class ChatMessage {
  ChatMessage({
    required this.id,
    required this.message,
    required this.useruid,
    required this.dt,
  });
  late final String id;
  late final String message;
  late final String useruid;
  late final DateTime dt;
  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dt = DateTime.fromMillisecondsSinceEpoch(json['dt']);
    message = json['message'];
    useruid = json['useruid'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['dt'] = DateTime.now().millisecondsSinceEpoch;
    data['message'] = message;
    data['useruid'] = useruid;
    return data;
  }
}
