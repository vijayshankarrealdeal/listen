import 'package:listen/models/chat_user.dart';
import 'package:listen/models/message.dart';
import 'package:listen/modules/chat_logic.dart';
import 'package:listen/modules/color_mode.dart';
import 'package:listen/services/db.dart';
import 'package:listen/widgets/chat_message_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ChatDetail extends StatelessWidget {
  final String notUsername;
  final String chatRoomId;
  final List<String> uids;
  const ChatDetail(
      {super.key,
      required this.chatRoomId,
      required this.uids,
      required this.notUsername});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return Consumer<ColorMode>(builder: (context, colorMode, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            notUsername,
          ),
        ),
        body: SafeArea(
          child: StreamBuilder<List<ChatMessage>>(
              stream: db.chatMessages(chatRoomId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final sortedData =
                      List.from(snapshot.data!).reversed.toList();
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: sortedData.length,
                          itemBuilder: (ctx, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Provider<ChatMessage>.value(
                                value: sortedData[index],
                                child: ChatsWidget(
                                  deleteMesage: () {},
                                  db: db,
                                  editdelete: () => showCupertinoDialog(
                                    context: context,
                                    builder: (ctx) => CupertinoAlertDialog(
                                      title: const Text("Edit"),
                                      content: CupertinoTextField(
                                        maxLines: 5,
                                        onChanged: (s) {},
                                        controller: TextEditingController(
                                            text: sortedData[index].message),
                                      ),
                                      actions: [
                                        CupertinoButton(
                                          child: const Text("Okay"),
                                          onPressed: () {
                                            // {mess.edut(mess.messages[index].id);
                                            // Navigator.pop(context);}
                                          },
                                        ),
                                        CupertinoButton(
                                          child: const Text("Cancel"),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ChangeNotifierProvider(
                          create: (ctx) => ChatLogicExtender(),
                          child: Consumer<ChatLogicExtender>(
                              builder: (context, formSubmit, _) {
                            return Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  minLines: 1,
                                  maxLines: 6,
                                  onChanged: (s) {},
                                  controller: formSubmit.controller,
                                  // suffix: Consumer<ImagePick>(builder: (context, data, _) {
                                  //   return CupertinoButton(
                                  //     padding: EdgeInsets.zero,
                                  //     onPressed:
                                  //         //  mess.controller.text.isEmpty
                                  //         //     ?
                                  //         () async {
                                  //       // data.pickMulti(db, ImageSource.gallery);
                                  //       // for (var element in data.sendImage) {
                                  //       //   mess.sendMessage(
                                  //       //     ChatMessage(
                                  //       //       id: const Uuid().v1(),
                                  //       //       message: element,
                                  //       //       useruid: db.uid,
                                  //       //       dt: DateTime.now(),
                                  //       //     ),
                                  //       //     db,
                                  //       //   );
                                  //     },

                                  //     // : () {
                                  //     //     //send memoji
                                  //     //   },
                                  //     child:
                                  //         // mess.controller.text.isEmpty
                                  //         //     ?
                                  //         const Icon(CupertinoIcons.app),
                                  //     // :
                                  //     // const FaIcon(
                                  //     //     FontAwesomeIcons.faceGrin,
                                  //     //     size: 20,
                                  //     //   ),
                                  //   );
                                  // }),
                                  autofocus: false,
                                )),
                                CupertinoButton(
                                  onPressed: () => formSubmit.sendToDatabase(
                                    db,
                                    uids,
                                    chatRoomId,
                                  ),
                                  child: const Icon(CupertinoIcons.location),
                                )
                              ],
                            );
                          }),
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      );
    });
  }
}
