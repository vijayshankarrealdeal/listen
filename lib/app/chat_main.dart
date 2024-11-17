import 'package:flutter/cupertino.dart';
import 'package:listen/app/chat_screen.dart';
import 'package:listen/models/call_logs.dart';
import 'package:listen/models/chat_user.dart';
import 'package:listen/modules/chat_calls_screen_logic.dart';
import 'package:listen/services/db.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:listen/services/navbar_logic.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    final inactivedb = Provider.of<Database>(context, listen: false);

    return Consumer<NavbarLogic>(builder: (context, navBar, _) {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async {
          navBar.change(0);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Chat"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChangeNotifierProvider(
              create: (ctx) => ChatCallsScreenLogic(),
              child:
                  Consumer<ChatCallsScreenLogic>(builder: (context, screen, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton(
                        style: ButtonStyle(
                            elevation: WidgetStateProperty.all(5.0),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Custom border radius
                              ),
                            )),
                        onSelectionChanged: (value) {
                          screen.changeChangeIndex(value.first);
                        },
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: 0,
                            label: Text('Chat History'),
                          ),
                          ButtonSegment(
                            value: 1,
                            label: Text('Call History'),
                          ),
                        ],
                        selected: <int>{screen.indexSelected},
                        multiSelectionEnabled: false,
                      ),
                    ),
                    screen.indexSelected == 0
                        ? Expanded(
                            child: StreamBuilder<List<ChatUser>>(
                                stream: inactivedb.getChatUsers(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data!.isEmpty
                                        ? const Center(
                                            child: Text("No Chat History"))
                                        : ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (ctx, idx) {
                                              return ListTile(
                                                onTap: () => Navigator.push(
                                                  ctx, // Pass the context directly here
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatDetail(
                                                      notUsername: snapshot
                                                          .data![idx].users
                                                          .where((x) =>
                                                              x.uid.compareTo(
                                                                  inactivedb
                                                                      .currentUseruid) !=
                                                              0)
                                                          .first
                                                          .name,
                                                      chatRoomId: snapshot
                                                          .data![idx]
                                                          .chatRoom
                                                          .chatRoomId,
                                                      uids: snapshot.data![idx]
                                                          .chatRoom.uids,
                                                    ),
                                                  ), // Correct parameter passing
                                                ),
                                                leading: CircleAvatar(
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          snapshot
                                                              .data![idx].users
                                                              .where((x) =>
                                                                  x.uid.compareTo(
                                                                      inactivedb
                                                                          .currentUseruid) !=
                                                                  0)
                                                              .first
                                                              .displayProfile),
                                                ),
                                                title: Text(snapshot
                                                    .data![idx].users
                                                    .where((x) =>
                                                        x.uid.compareTo(inactivedb
                                                            .currentUseruid) !=
                                                        0)
                                                    .first
                                                    .name),
                                                trailing: Text(timeago.format(
                                                    snapshot.data![idx].chatRoom
                                                        .lastTime
                                                        .toDate())),
                                                subtitle: Text(
                                                  snapshot.data![idx].chatRoom
                                                      .lastMessage,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall!
                                                      .copyWith(
                                                          color: CupertinoColors
                                                              .inactiveGray),
                                                ),
                                              );
                                            },
                                          );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                }),
                          )
                        : Expanded(
                            child: StreamBuilder<List<CallLogs>>(
                                stream: inactivedb.getCallLogs(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data!.isEmpty
                                        ? const Center(
                                            child: Text("No Chat History"))
                                        : ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (ctx, idx) {
                                              return ListTile(
                                                onTap: () => Navigator.push(
                                                  ctx, // Pass the context directly here
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CallHistory(
                                                            logs: snapshot
                                                                .data![idx]),
                                                  ), // Correct parameter passing
                                                ),
                                                leading: CircleAvatar(
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          snapshot
                                                              .data![idx]
                                                              .user
                                                              .displayProfile),
                                                ),
                                                title: Text(snapshot
                                                    .data![idx].user.name),
                                                subtitle: Text(timeago.format(
                                                    snapshot.data![idx].callTime
                                                        .first
                                                        .toDate())),
                                                trailing: Text(snapshot
                                                    .data![idx].callCount
                                                    .toString()),
                                              );
                                            },
                                          );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                }),
                          ),
                  ],
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}

class CallHistory extends StatelessWidget {
  final CallLogs logs;
  const CallHistory({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Call History"),
        actions: [
          ZegoSendCallInvitationButton(
            onPressed: (a, b, c) {
              db.addTocallLogs("${logs.user.uid}-${db.currentUseruid}",
                  [db.currentUseruid, logs.user.uid]);
            },
            borderRadius: 1,
            iconSize: const Size(30, 30),
            isVideoCall: true,
            resourceID: "zego_call",
            invitees: [
              ZegoUIKitUser(
                id: logs.user.uid,
                name: logs.user.name,
              ),
            ],
          ),
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage:
                      CachedNetworkImageProvider(logs.user.displayProfile),
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Text(logs.user.name),
                    Text(timeago.format(logs.callTime.first.toDate())),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: logs.callTime
                  .map((e) => Text(e.toDate().toString().substring(0, 19)))
                  .toList(),
            )
          ]),
    );
  }
}
