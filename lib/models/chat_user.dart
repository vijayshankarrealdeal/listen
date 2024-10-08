import 'package:listen/models/chat_model.dart';
import 'package:listen/models/user_app.dart';

class ChatUser {
  final ChatRoom chatRoom;
  final List<FUsers> users;

  ChatUser({
    required this.chatRoom,
    required this.users,
  });

  // Factory constructor for creating an instance from JSON
  factory ChatUser.fromJson(
      Map<String, dynamic> json, List<FUsers> user, ChatRoom chatRoom) {
    return ChatUser(
      chatRoom: chatRoom,
      users: user,
    );
  }
}
