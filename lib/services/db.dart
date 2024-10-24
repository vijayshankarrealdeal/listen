import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listen/models/call_logs.dart';
import 'package:listen/models/chat_model.dart';
import 'package:listen/models/chat_user.dart';
import 'package:listen/models/daily_tips.dart';
import 'package:listen/models/message.dart';
import 'package:listen/models/user_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:palette_generator/palette_generator.dart';

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

  void addTocallLogs(String callLogId, List<String> uids) async {
    Timestamp callTime = Timestamp.now();
    String callLogTodayId =
        "$callLogId-${DateFormat('yyyy-MM-dd').format(callTime.toDate())}";
    DocumentSnapshot callLogSnapshot =
        await _ref.collection("callLogs").doc(callLogTodayId).get();

    if (callLogSnapshot.exists) {
      Map<String, dynamic> data =
          callLogSnapshot.data() as Map<String, dynamic>;
      await _ref.collection("callLogs").doc(callLogTodayId).update(
        {
          "callTime": FieldValue.arrayUnion([callTime]),
          "callCount": data['callCount'] + 1,
          "call_date": callTime,
        },
      );
    } else {
      await _ref.collection("callLogs").doc(callLogTodayId).set(
        {
          "callLogId": callLogTodayId,
          "callTime": FieldValue.arrayUnion([callTime]),
          "uids": FieldValue.arrayUnion(uids),
          "callCount": 1,
          "call_date": callTime,
        },
      );
    }
  }

  Stream<List<DailyTips>> getDailyTips() {
    return _ref.collection("daily_tips").snapshots().asyncMap((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        List<DailyTips> allTips = [];

        for (var doc in snapshot.docs) {
          List<dynamic>? tips =
              doc.data()['img_id']; // Replace 'img_id' with actual field name
          String? text = doc.data()['text']; // Assuming there's a 'text' field

          if (tips != null) {
            for (var tip in tips) {
              String imageUrl =
                  tip.toString(); // Assuming each tip is an image URL

              // Get dominant color from the image
              Color dominantColor = await _getDominantColorFromImage(imageUrl);

              // Create a DailyTips object and add it to the list
              allTips.add(
                DailyTips(
                    imageUrl: imageUrl, color: dominantColor, text: text ?? ''),
              );
            }
          }
        }

        return allTips; // Return the list of all tips
      }

      return <DailyTips>[]; // Return an empty list if no documents found
    });
  }

  Future<Color> _getDominantColorFromImage(
      String imageUrl) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
    );
    return paletteGenerator.dominantColor?.color ??
        Colors.grey; // Fallback to grey if no color found
  }

  Stream<List<CallLogs>> getCallLogs() {
    return _ref
        .collection("callLogs")
        .orderBy("call_date")
        .where('uids', arrayContains: currentUseruid)
        .snapshots()
        .flatMap((snapshot) {
      // Map each document to a CallLogs object along with the corresponding user info
      final List<Stream<CallLogs>> callLogStreams = snapshot.docs.map((eData) {
        final List<String> uids = List<String>.from(eData.data()['uids']);
        final String otherUserUid =
            uids.firstWhere((uid) => uid != currentUseruid);

        // Fetch user data for the other user
        Stream<FUsers> userStream = getUser(otherUserUid);

        // Combine the call logs and user data into a single stream
        return userStream.map((user) {
          return CallLogs.fromJson(eData.data(), user);
        });
      }).toList();

      // Combine all the streams into one and wait for all results
      return Rx.combineLatestList(callLogStreams);
    });
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
      log("Error adding user to chat: $e");
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

  Future<List<FUsers>> searchPsy(String searchTerm) async {
    final snapshotData = await _ref
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: searchTerm)
        .get();
    return snapshotData.docs.map((e) => FUsers.fromJson(e.data())).toList();
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
