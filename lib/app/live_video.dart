import 'dart:developer';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listen/app/chat_screen.dart';
import 'package:listen/models/chat_model.dart';
import 'package:listen/routes/user_page.dart';
import 'package:listen/models/temp_data.dart';
import 'package:listen/services/db.dart';
import 'package:listen/services/navbar_logic.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class LiveVideo extends StatelessWidget {
  const LiveVideo({super.key});

  @override
  Widget build(BuildContext context) {
    final inactiveDb = Provider.of<Database>(context, listen: false);
    final data = TempData();
    List<Psychologist> userdataList = data.psychologistList
        .where((i) => i.uid.compareTo(inactiveDb.currentUseruid) != 0)
        .toList();
    return Consumer<NavbarLogic>(builder: (context, navBar, _) {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async {
          navBar.change(0);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Talk to psysolgist"),
          ),
          body: ListView.separated(
            separatorBuilder: (ctx, idx) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                child: Divider(
                  color:
                      Colors.green.shade200, // Change color as per your design
                  thickness: 0.5,
                ),
              );
            },
            itemCount: userdataList.length,
            itemBuilder: (ctx, idx) {
              Psychologist userdata = userdataList[idx];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPage(
                          user: null,
                          psychologist: userdata,
                        ),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 44,
                                backgroundImage: CachedNetworkImageProvider(
                                    userdata.displayProfile),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                      "${userdata.ratingsReviews.averageRating.toString()} "),
                                  AnimatedRatingStars(
                                    initialRating:
                                        userdata.ratingsReviews.averageRating,
                                    onChanged: (double rating) {},
                                    filledColor: CupertinoColors.activeGreen,
                                    emptyColor: Colors.grey,
                                    filledIcon: Icons.star,
                                    halfFilledIcon: Icons.star_half,
                                    emptyIcon: Icons.star_border,
                                    displayRatingValue: true,
                                    interactiveTooltips: true,
                                    customFilledIcon: Icons.star,
                                    customHalfFilledIcon: Icons.star_half,
                                    customEmptyIcon: Icons.star_border,
                                    starSize: 10.0,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    animationCurve: Curves.easeInOut,
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 15),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userdata.name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                "Specialization",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: Colors.grey),
                              ),
                              Text(
                                userdata.specialization,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: ExpandableText(
                                  userdata.psychologistTitle,
                                  maxLines: 2,
                                  expandText: "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                              Text(
                                "${userdata.yearsOfExperience.toString()} Year Of Experience",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Languages Spoken",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: Colors.grey),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: userdata.languagesSpoken
                                    .map((x) => Text(
                                          "$x ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(color: Colors.black),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: ZegoSendCallInvitationButton(
                                  onPressed: (a, b, c) {
                                    inactiveDb.addTocallLogs(
                                        "${userdata.uid}-${inactiveDb.currentUseruid}",
                                        [
                                          inactiveDb.currentUseruid,
                                          userdata.uid
                                        ]);
                                  },
                                  verticalLayout: false,
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                  borderRadius: 0,
                                  buttonSize: const Size(35, 35),
                                  iconSize: const Size(35, 35),
                                  isVideoCall: true,
                                  resourceID: "zego_call",
                                  invitees: [
                                    ZegoUIKitUser(
                                      id: userdata.uid,
                                      name: userdata.name,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.chat_bubble_2,
                                    size: 35, color: Colors.green.shade600),
                                onPressed: () {
                                  try {
                                    inactiveDb.addUserToChat(ChatRoom(
                                        chatRoomId:
                                            "${userdata.uid}-${inactiveDb.currentUseruid}",
                                        uids: [
                                          inactiveDb.currentUseruid,
                                          userdata.uid,
                                        ],
                                        lastMessage: "",
                                        lastTime: Timestamp.now(),
                                        fmcToken: '',
                                        uidSendTo: userdata.uid));
                                    Navigator.push(
                                        (ctx),
                                        MaterialPageRoute(
                                          builder: (ctx) => ChatDetail(
                                              chatRoomId:
                                                  "${userdata.uid}-${inactiveDb.currentUseruid}",
                                              uids: [
                                                inactiveDb.currentUseruid,
                                                userdata.uid,
                                              ],
                                              notUsername: userdata.name),
                                        ));
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
