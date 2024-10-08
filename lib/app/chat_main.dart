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

// CustomScrollView(
//   slivers: [
//     SliverAppBar(
//       largeTitle: const Text("Chats"),
//       trailing: CupertinoButton(
//         padding: EdgeInsets.zero,
//         child: const Icon(CupertinoIcons.plus),
//         onPressed: () {
//           // showCupertinoModalPopup<void>(
//           //   context: context,
//           //   builder: (BuildContext context) {
//           //     return const ActiveWidet();
//           //   },
//           // );
//         },
//       ),
//     ),
//     snap.load
//         ? const SliverFillRemaining(
//             child: Center(child: CupertinoActivityIndicator()))
//         : snap.error.isNotEmpty
//             ? SliverFillRemaining(
//                 child: Center(child: Text(snap.error)))
//             : snap.chatusers.isEmpty
//                 ? const SliverFillRemaining(
//                     child: Center(child: Text("No messages")))
//                 : SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (ctx, index) {
//                         return ListTile();
//                       },
//   NotUser userTmp = snap.chatusers[index].uids
//       .where((element) =>
//           element != inactivedb)
//       .first;
//   return CupertinoListTile(
//     onTap: () => showCupertinoDialog(
//       context: context,
//       builder: (context) => CupertinoAlertDialog(
//         title: const Text("Delete Chat"),
//         content: const Text(
//             "Chat from both user will be removed."),
//         actions: [
//           CupertinoButton(
//               child: const Text("Delete"),
//               onPressed: () {
//                 snap.removeChat(
//                     snap.chatusers[index].id);
//                 Navigator.pop(context);
//               }),
//           CupertinoButton(
//             child: const Text("Cancel"),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     ),
//     leading: CachedNetworkImage(
//       imageUrl: userTmp.displayProfile,
//       imageBuilder: (context, imageProvider) =>
//           CircleAvatar(
//         backgroundImage: imageProvider,
//       ),
//       placeholder: (context, _) => CircleAvatar(
//         backgroundColor: CupertinoTheme.of(context)
//             .scaffoldBackgroundColor,
//       ),
//     ),
//     title: Text(
//       userTmp.name,
//       style: TextStyle(
//           color: color.textBasic(),
//           fontFamily: 'SFProDisplaySemibold',
//           fontSize: 17),
//     ),
//     subtitle: snap.chatusers[index].lastMessage
//             .contains('https://4dvku1')
//         ? const Text('')
//         : Text(
//             snap.chatusers[index].lastMessage
//                         .length >
//                     49
//                 ? '${snap.chatusers[index].lastMessage.substring(0, 50)}...'
//                 : snap.chatusers[index].lastMessage,
//             style: TextStyle(
//                 color: color.textlastMessage(),
//                 fontFamily: 'SFProDisplayRegular',
//                 fontSize: 15),
//           ),
//     onTap: () => Navigator.push(
//       context,
//       CupertinoPageRoute(
//         builder: (context) =>
//             ChangeNotifierProvider<
//                 ChatMessageLogic>(
//           create: (ctx) => ChatMessageLogic(
//               uid: inactivedb.uid,
//               chatRoom: snap.chatusers[index],
//               firstChat: false,
//               chatRoomId: snap.chatusers[index].id),
//           child: ChatDetail(
//             notUsername: userTmp.name,
//           ),
//         ),
//       ),
//     ),
//   );
// },
//                       childCount: snap.chatusers.length,
//                     ),
//                   )
//   ],
// );
//   if (snap.error.isNotEmpty) {
//   return Center(
//     child: Text("Something Went Wrong\n${snap.error.toString()}"),
//   );
// } else if (snap.chatusers.isEmpty && snap.load.isEmpty) {
//   return const CupertinoActivityIndicator();
// } else {
//   return Container();
// }

// class ActiveWidet extends StatelessWidget {
//   const ActiveWidet({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final inactivedb = Provider.of<Database>(context);

//     return Container(
//       decoration: BoxDecoration(
//           color: CupertinoTheme.of(context).scaffoldBackgroundColor,
//           borderRadius: BorderRadius.circular(25)),
//       height: MediaQuery.of(context).size.height * 0.65,
//       child: Consumer2<GetContacts, ColorMode>(
//         builder: (context, data, color, _) {
//           return CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: CupertinoButton(
//                     child: const Icon(CupertinoIcons.clear_circled),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//               ),
//               data.contacts.isEmpty
//                   ? const SliverFillRemaining(
//                       child: Center(child: CupertinoActivityIndicator()))
//                   : SliverList(
//                       delegate: SliverChildListDelegate(data.permission
//                           ? data.contacts
//                               .where((element) => element.indb)
//                               .map(
//                                 (e) => CupertinoListTile(
//                                   trailing: Consumer<ChatMain>(
//                                       builder: (context, dataT, _) {
//                                     ChatRoom t = dataT.chatusers.firstWhere(
//                                       (element) => element.uids.contains(e.uid),
//                                       orElse: () => ChatRoom(
//                                           lastTime: DateTime.now(),
//                                           id: '',
//                                           uids: [
//                                             inactivedb.uid,
//                                             e.uid,
//                                           ],
//                                           users: [
//                                             NotUser(
//                                               displayProfile: inactivedb
//                                                   .user!.displayProfile,
//                                               name: inactivedb.user!.name,
//                                               uid: inactivedb.uid,
//                                             ),
//                                             NotUser(
//                                               displayProfile: e.profilePic,
//                                               name: e.name,
//                                               uid: e.uid,
//                                             ),
//                                           ],
//                                           lastMessage: ''),
//                                     );
//                                     return CupertinoButton(
//                                       onPressed: e.indb
//                                           ? () => Navigator.push(
//                                                 context,
//                                                 CupertinoPageRoute(
//                                                   builder: (context) =>
//                                                       ChangeNotifierProvider<
//                                                           ChatMessageLogic>(
//                                                     create: (ctx) =>
//                                                         ChatMessageLogic(
//                                                             chatRoom: t,
//                                                             uid: inactivedb.uid,
//                                                             firstChat: true,
//                                                             chatRoomId: t.id
//                                                                     .isNotEmpty
//                                                                 ? t.id
//                                                                 : const Uuid()
//                                                                     .v1()),
//                                                     child: ChatDetail(
//                                                       notUsername: e.name,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               )
//                                           : () async {
//                                               await FlutterShare.share(
//                                                   title:
//                                                       'Invite ${e.name} to share',
//                                                   text:
//                                                       "Hey Let's talk and listen music together",
//                                                   linkUrl:
//                                                       'https://flutter.dev/',
//                                                   chooserTitle: 'vsr');
//                                             },
//                                       child: e.indb
//                                           ? const Text("Message")
//                                           : Text(
//                                               "Invite",
//                                               style: TextStyle(
//                                                 color: color.invite(),
//                                               ),
//                                             ),
//                                     );
//                                   }),
//                                   // onTap: () => Navigator.push(
//                                   //   context,
//                                   //   CupertinoPageRoute(
//                                   //     builder: (context) =>
//                                   //         Provider<MyContactsModel>.value(
//                                   //       value: e,
//                                   //       child: const ContactDetails(),
//                                   //     ),
//                                   //   ),
//                                   // ),
//                                   leading: e.profilePic.isEmpty
//                                       ? CircleAvatar(
//                                           backgroundColor: e.colors,
//                                           child: Text(
//                                             e.name
//                                                 .substring(0, 1)
//                                                 .toUpperCase(),
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyLarge!
//                                                 .copyWith(color: Colors.white),
//                                           ),
//                                         )
//                                       : CachedNetworkImage(
//                                           imageUrl: e.profilePic,
//                                           imageBuilder: (context, imgUrl) =>
//                                               CircleAvatar(
//                                                 backgroundImage: imgUrl,
//                                               ),
//                                           placeholder: (ctx, _) => CircleAvatar(
//                                                 backgroundColor: CupertinoTheme
//                                                         .of(context)
//                                                     .scaffoldBackgroundColor,
//                                               )),
//                                   title: Text(
//                                     e.name,
//                                     style: TextStyle(

//                                         fontFamily: 'SFProDisplayRegular',
//                                         fontSize: 17),
//                                   ),
//                                 ),
//                               )
//                               .toList()
//                           : [
//                               Padding(
//                                 padding: const EdgeInsets.all(48.0),
//                                 child: CupertinoButton(
//                                   child: const Text("Enable Permission"),
//                                   //onPressed: () => data.reqPermission(),
//                                 ),
//                               )
//                             ]),
//                     ),
//               const SliverPadding(padding: EdgeInsets.all(28)),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
