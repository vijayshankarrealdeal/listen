import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:listen/models/chat_model.dart';
import 'package:listen/models/chat_user.dart';
import 'package:listen/models/message.dart';
import 'package:listen/models/user_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class Database with ChangeNotifier {
  final String currentUseruid;
  final String phoneNum;
  final FirebaseFirestore _ref = FirebaseFirestore.instance;

  bool load = false;
  bool isActive = false;

  Database({required this.currentUseruid, required this.phoneNum}) {
    log(currentUseruid);
    makeactive(true);
  }

  Future<void> addUser(FUsers user) async {
    try {
      await _ref.collection('users').doc(currentUseruid).set(user.toJson());
    } catch (e) {
      log("Failed to add user: $e");
    }
  }

  Future<void> makeactive(bool active) async {
    try {
      var userDoc = await _ref.collection('users').doc(currentUseruid).get();

      if (userDoc.exists && userDoc.data() != null) {
        String? role = userDoc.data()!['role'];
        if (role == "E") {
          await _ref
              .collection("users")
              .doc(currentUseruid)
              .update({"status": active});
          isActive = active;
        } else {
          log("User role is not 'U'.");
        }
      } else {
        log("User document does not exist or has no data.");
      }
    } catch (e) {
      log("Error in makeactive: $e");
      isActive = false;
    }
    notifyListeners(); // Call once at the end
  }

  void addUserToChat(ChatRoom chatRoom) async {
    try {
      // Check if the chat room already exists
      DocumentSnapshot chatRoomSnapshot =
          await _ref.collection("chatroom").doc(chatRoom.chatRoomId).get();

      if (chatRoomSnapshot.exists) {
        // Update existing chat room
        await _ref.collection("chatroom").doc(chatRoom.chatRoomId).update({
          "last_window_open": Timestamp.now(),
          "chat_room_id": chatRoom.chatRoomId,
          'uids': FieldValue.arrayUnion([currentUseruid, chatRoom.uids[1]]),
          "lastMessage": chatRoom.lastMessage,
          "uid_send_to": chatRoom.uids
              .where((x) => x.compareTo(currentUseruid) != 0)
              .first,
        });
      } else {
        // Create a new chat room
        await _ref.collection("chatroom").doc(chatRoom.chatRoomId).set({
          "last_window_open": Timestamp.now(),
          "chat_room_id": chatRoom.chatRoomId,
          'uids': FieldValue.arrayUnion([currentUseruid, chatRoom.uids[1]]),
          "lastMessage": chatRoom.lastMessage,
          "uid_send_to": chatRoom.uids
              .where((x) => x.compareTo(currentUseruid) != 0)
              .first,
        });
      }
    } catch (e) {
      // Handle errors here, such as logging the error
      print("Error adding user to chat: $e");
    }
  }

  void removeChat(String chatRoom) {
    _ref.collection('chatroom').doc(chatRoom).delete();
    notifyListeners();
  }

  Stream<List<ChatUser>> getChatUsers() {
    return getChat().switchMap((chatRooms) {
      if (chatRooms.isEmpty) {
        // Return an empty list if there are no chat rooms
        return Stream.value([]);
      }

      // For each chat room, get the users for all uids
      final userStreams = chatRooms.map((chatRoom) {
        if (chatRoom.uids.isEmpty) {
          // Return an empty list if there are no UIDs in the chat room
          return Stream.value(ChatUser(chatRoom: chatRoom, users: []));
        }

        final userFetchStreams = chatRoom.uids.map((uid) {
          // Fetch each user by UID
          return getUser(uid).map((fUser) {
            return fUser;
          });
        });

        // Combine all user fetch streams for the current chatRoom into one stream
        return Rx.combineLatestList(userFetchStreams).map((fUsersList) {
          print(fUsersList);
          return ChatUser(chatRoom: chatRoom, users: fUsersList);
        });
      });

      // Combine all the chat room streams into one stream
      return Rx.combineLatestList(userStreams);
    });
  }

  void sendMessage(List<String> chatUserUids, String chatRoomId,
      ChatMessage messages) async {
    String otherUserUID =
        chatUserUids.where((x) => x.compareTo(currentUseruid) != 0).first;
    String? token = await FirebaseMessaging.instance.getToken();
    await _ref
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("userChat")
        .doc(messages.id)
        .set(messages.toJson());

    await _ref.collection("chatroom").doc(chatRoomId).update({
      "lastMessage": messages.message,
      "uid_send_to": otherUserUID,
    });

    await _ref
        .collection("users")
        .doc(otherUserUID)
        .update({"fmcToken": token});
  }

  Stream<List<ChatMessage>> chatMessages(String roomId) {
    return _ref
        .collection("chatroom")
        .doc(roomId)
        .collection("userChat")
        .orderBy("dt")
        .snapshots()
        .map((event) =>
            event.docs.map((e) => ChatMessage.fromJson(e.data())).toList());
  }

  Stream<FUsers> getUser(String uid) {
    try {
      return _ref
          .collection('users')
          .where('uid', isEqualTo: uid)
          .snapshots()
          .map((event) {
        if (event.docs.isEmpty) {
          // Return an empty FUsers object if no user is found
          return FUsers.empty();
        }
        // Map the first found user document to FUsers object
        return event.docs.map((e) => FUsers.fromJson(e.data())).toList().first;
      });
    } catch (e) {
      log("Error in getUser: $e");
      // Return a stream with a default empty FUsers object in case of an error
      return Stream.value(FUsers.empty());
    }
  }

  Stream<List<ChatRoom>> getChat() {
    return _ref
        .collection('chatroom')
        .where('uids', arrayContains: currentUseruid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatRoom.fromJson(doc.data())).toList());
  }

  Stream<List<String>> getBanners() {
    return _ref.collection("banners").snapshots().map((snap) {
      return snap.docs
          .map((doc) => doc.data()['banner_url'] as String)
          .toList();
    });
  }

  Future<bool> checkActive(String otherUid) async {
    try {
      var doc = await _ref
          .collection("users")
          .doc(otherUid)
          .collection("useractive")
          .doc("checkActive")
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['status'] as bool;
      } else {
        log("Document does not exist or has no data for checkActive.");
        return false;
      }
    } catch (e) {
      log("Error in checkActive: $e");
      return false;
    }
  }
}
