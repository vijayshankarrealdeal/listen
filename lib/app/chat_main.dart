import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:listen/app/chat_screen.dart';
import 'package:listen/models/chat_user.dart';
import 'package:listen/modules/chat_calls_screen_logic.dart';
import 'package:listen/services/db.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    final inactivedb = Provider.of<Database>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ChangeNotifierProvider(
          create: (ctx) => ChatCallsScreenLogic(),
          child: Consumer<ChatCallsScreenLogic>(builder: (context, screen, _) {

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton(
                    style: ButtonStyle(
                        elevation: WidgetStateProperty.all(5.0),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
                                                          x.uid.compareTo(inactivedb
                                                              .currentUseruid) !=
                                                          0)
                                                      .first
                                                      .name,
                                                  chatRoomId: snapshot
                                                      .data![idx]
                                                      .chatRoom
                                                      .chatRoomId,
                                                  uids: snapshot
                                                      .data![idx].chatRoom.uids,
                                                ),
                                              ), // Correct parameter passing
                                            ),
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      snapshot.data![idx].users
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
                    : const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("No Calls logs")],
                        ),
                      ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
