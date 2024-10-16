import 'dart:developer';

import 'package:listen/models/message.dart';
import 'package:listen/services/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class ChatLogicExtender extends ChangeNotifier {
  TextEditingController controller = TextEditingController();

  bool getStatus() {
    if (controller.text.isEmpty) {
      return true;
    }
    return true;
  }

  void sendToDatabase(Database db,List<String> chatUserUids,String chatRoomId,) async {
    if (controller.text.isEmpty) {
      return;
    }
    try {
      db.sendMessage(
        chatUserUids,
        chatRoomId,
        ChatMessage(
          id: const Uuid().v1(),
          message: controller.text,
          useruid: db.currentUseruid,
          dt: DateTime.now(),
          
        ),
      );
      controller.clear();
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }
}
