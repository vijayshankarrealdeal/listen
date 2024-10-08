import 'package:listen/models/message.dart';
import 'package:listen/modules/color_mode.dart';
import 'package:listen/services/db.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatsWidget extends StatelessWidget {
  const ChatsWidget({
    super.key,
    required this.db,
    required this.editdelete,
    required this.deleteMesage,
  });

  final Database db;
  final VoidCallback editdelete;
  final VoidCallback deleteMesage;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatMessage, ColorMode>(
        builder: (context, mess, colorMode, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: mess.useruid != db.currentUseruid
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: CupertinoContextMenu(
              actions: mess.useruid == db.currentUseruid
                  ? [
                      mess.message.contains('https://4dvku1') == false
                          ? CupertinoContextMenuAction(
                              child: const Text("Edit"),
                              onPressed: () => editdelete(),
                            )
                          : const SizedBox.shrink(),
                      CupertinoContextMenuAction(
                        child: const Text("Delete"),
                        onPressed: () {
                          deleteMesage();
                          Navigator.pop(context);
                        },
                      )
                    ]
                  : [Container()],
              child: Container(
                decoration: BoxDecoration(
                  color: mess.useruid != db.currentUseruid
                      ? colorMode.chatBubbleNUser()
                      : colorMode.chatBubbleUser(),
                  borderRadius: mess.useruid != db.currentUseruid
                      ? const BorderRadius.only(
                          bottomRight: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0),
                        ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Padding(
                      padding: mess.message.contains('https://4dvku1')
                          ? const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 0)
                          : const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 7),
                      child: mess.message.contains('https://4dvku1')
                          ? CachedNetworkImage(
                              imageUrl: mess.message,
                            )
                          : Text(
                              mess.message,
                              style: TextStyle(
                                fontFamily: 'SFProTextRegular',
                                fontSize: 17,
                                color: mess.useruid != db.currentUseruid
                                    ? colorMode.chatBubbleTextNUser()
                                    : colorMode.chatBubbleTextUser(),
                              ),
                            ),
                    );
                  }),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Align(
            alignment: mess.useruid != db.currentUseruid
                ? Alignment.bottomLeft
                : Alignment.bottomRight,
            child: Text(
              timeago.format(mess.dt),
              style: CupertinoTheme.of(context)
                  .textTheme
                  .navActionTextStyle
                  .copyWith(fontSize: 10, color: colorMode.textlastMessage()),
            ),
          ),
        ],
      );
    });
  }
}
