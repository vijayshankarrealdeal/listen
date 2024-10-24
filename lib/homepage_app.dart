import 'package:listen/app/about.dart';
//import 'package:listen/app/calls.dart';
import 'package:listen/app/chat_main.dart';
import 'package:listen/app/dashboard.dart';
import 'package:listen/app/live_video.dart';
import 'package:listen/modules/ytd_players.dart';
import 'package:listen/services/navbar_logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    List<Widget> uiFrames(Widget player) => [
          Dashboard(player: player),
          const LiveVideo(),
          const Chat(),
          //Calls(),
          const Wallet()
        ];
    return ChangeNotifierProvider<YtdPlayers>(
      create: (ctx) => YtdPlayers(),
      child: Consumer2<NavbarLogic, YtdPlayers>(
          builder: (context, navbar, ytd, _) {
        return YoutubePlayerBuilder(
            player: ytd.players(),
            builder: (context, player) {
              return Scaffold(
                body: uiFrames(player)[navbar.idx],
                bottomNavigationBar: NavigationBar(
                  selectedIndex: navbar.idx,
                  onDestinationSelected: (id) => navbar.change(id),
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                  indicatorColor: Colors.transparent,
                  destinations: [
                    NavigationDestination(
                        icon: Icon(CupertinoIcons.home,
                            size: 35,
                            color: navbar.activeColor[0]
                                ? CupertinoColors.activeGreen
                                : CupertinoColors.inactiveGray
                                    .withOpacity(0.5)),
                        label: ""),
                    NavigationDestination(
                        icon: Icon(CupertinoIcons.phone,
                            size: 35,
                            color: navbar.activeColor[1]
                                ? CupertinoColors.activeGreen
                                : CupertinoColors.inactiveGray
                                    .withOpacity(0.5)),
                        label: ""),
                    NavigationDestination(
                        icon: Icon(CupertinoIcons.clock,
                            size: 35,
                            color: navbar.activeColor[2]
                                ? CupertinoColors.activeGreen
                                : CupertinoColors.inactiveGray
                                    .withOpacity(0.5)),
                        label: ""),
                    NavigationDestination(
                        icon: Icon(Icons.wallet,
                            size: 35,
                            color: navbar.activeColor[3]
                                ? CupertinoColors.activeGreen
                                : CupertinoColors.inactiveGray.withOpacity(0.5)
                            //: const Color.fromARGB(255, 209, 209, 209)
                            ),
                        label: ""),
                    // NavigationDestination(
                    //     icon: Icon(CupertinoIcons.person_3), label: "About")
                  ],
                ),
              );
            });
      }),
    );
  }
}
