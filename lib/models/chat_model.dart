import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String chatRoomId;
  final List<String> uids;
  final String lastMessage;
  final Timestamp lastTime;
  String fmcToken = "";
  final String uidSendTo;

  // Constructor
  ChatRoom({
    required this.chatRoomId,
    required this.uids,
    required this.lastMessage,
    required this.lastTime,
    required this.fmcToken,
    required this.uidSendTo,
  });

  // Factory constructor to create a ChatRoom from a JSON object
  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
        chatRoomId: json['chat_room_id'] as String,
        uids: List.from(json['uids']).map((e) => e.toString()).toList(),
        lastMessage: json['lastMessage'] ?? "",
        lastTime: json['last_window_open'] as Timestamp,
        fmcToken: json['fmcToken'] ?? "",
        uidSendTo: json['uid_send_to'] ?? "");
  }

  // Method to convert a ChatRoom instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'chat_room_id': chatRoomId,
      'uids': uids,
      'lastMessage': lastMessage,
      'last_window_open': lastTime,
      'fmcToken': fmcToken,
      'uid_send_to': uidSendTo
    };
  }
}
