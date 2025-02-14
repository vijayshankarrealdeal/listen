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
                        child: sortedData.isEmpty
                            ? const Center(
                                child: Text("No messages yet. Start chatting!"),
                              )
                            : ListView.builder(
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
                                          builder: (ctx) =>
                                              CupertinoAlertDialog(
                                            title: const Text("Edit"),
                                            content: CupertinoTextField(
                                              maxLines: 5,
                                              onChanged: (s) {},
                                              controller: TextEditingController(
                                                  text: sortedData[index]
                                                      .message),
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
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    hintText:
                                        'Start the chat', // Optional: Add a hint
                                  ),
                                )),
                                CupertinoButton(
                                  padding: const EdgeInsets.only(right: 8,left: 8),
                                  onPressed: () => formSubmit.sendToDatabase(
                                    db,
                                    uids,
                                    chatRoomId,
                                  ),
                                  child: const Icon(CupertinoIcons.location,size: 38),
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
