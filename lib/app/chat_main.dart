import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
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
                                                subtitle: Text("${timeago.format(
                                                    snapshot.data![idx].callTime
                                                        .first
                                                        .toDate())},  ${snapshot
                                                        .data![idx].callCount
                                                        .toString()} calls"),
                                                trailing: ZegoSendCallInvitationButton(
                                                  buttonSize:
                                                      const Size(35, 35),
                                                  onPressed: (a, b, c) {
                                                    inactivedb.addTocallLogs(
                                                        "${snapshot.data![idx].user.uid}-${inactivedb.currentUseruid}",
                                                        [
                                                          inactivedb
                                                              .currentUseruid,
                                                          snapshot
                                                              .data![idx]
                                                              .user
                                                              .uid
                                                        ]);
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  borderRadius: 1,
                                                  iconSize:
                                                      const Size(35, 35),
                                                  isVideoCall: true,
                                                  resourceID: "zego_call",
                                                  invitees: [
                                                    ZegoUIKitUser(
                                                      id: snapshot
                                                          .data![idx]
                                                          .user
                                                          .uid,
                                                      name: snapshot
                                                          .data![idx]
                                                          .user
                                                          .name,
                                                    ),
                                                  ],
                                                ),

                                                // Row(
                                                //   children: [
                                                //     Expanded(
                                                //       child:
                                                //     ),
                                                //     Text(snapshot
                                                //         .data![idx].callCount
                                                //         .toString()),
                                                //   ],
                                                // ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: CachedNetworkImageProvider(
                            logs.user.displayProfile),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            logs.user.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.black),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formatDate(logs.callTime.first.toDate().toString()),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ZegoSendCallInvitationButton(
                    onPressed: (a, b, c) {
                      db.addTocallLogs("${logs.user.uid}-${db.currentUseruid}",
                          [db.currentUseruid, logs.user.uid]);
                    },
                    padding: EdgeInsets.zero,
                    borderRadius: 1,
                    iconSize: const Size(45, 45),
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
              Divider(color: Colors.green.shade100),
              Expanded(
                child: ListView(
                  children: logs.callTime
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.phone,
                                    color: CupertinoColors.activeGreen),
                                const SizedBox(width: 10),
                                Text(
                                    extractTime(
                                        e.toDate().toString().substring(0, 19)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.grey)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              )
            ]),
      ),
    );
  }

  String extractTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('hh:mm a').format(dateTime); // Format to HH:mm
  }

  String formatDate(String dateString) {
    DateTime inputDate = DateTime.parse(dateString);
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (inputDate.year == today.year &&
        inputDate.month == today.month &&
        inputDate.day == today.day) {
      return 'Today';
    } else if (inputDate.year == yesterday.year &&
        inputDate.month == yesterday.month &&
        inputDate.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMMM').format(inputDate); // Example: 20 Oct
    }
  }
}
