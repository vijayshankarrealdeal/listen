import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:listen/models/daily_tips.dart';

class ShowDailyTips extends StatelessWidget {
  final DailyTips todayTip;
  const ShowDailyTips({super.key, required this.todayTip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: todayTip.color.withOpacity(0.2),
      body: Stack(
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: CachedNetworkImage(
              imageUrl: todayTip.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(
                    todayTip.color.alpha,
                    (todayTip.color.red * 0.7).toInt(), // Reduce red component
                    (todayTip.color.green * 0.7)
                        .toInt(), // Reduce green component
                    (todayTip.color.blue * 0.7)
                        .toInt(), // Reduce blue component
                  ).withOpacity(0.6)),
                  child: Center(
                    child: Text('Today Tips',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: todayTip.color)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Stack(
      //   children: [
      //     ClipRect(
      //       child: BackdropFilter(
      //         filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      //         child: Container(
      //           decoration: BoxDecoration(
      //             image: DecorationImage(
      //               fit: BoxFit.cover,
      //               image: CachedNetworkImageProvider(
      //                 todayTip.imageUrl,
      //               ),
      //             ),
      //           ),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Align(
      //                   alignment: Alignment.topRight,
      //                   child: IconButton(
      //                       onPressed: () => Navigator.pop(context),
      //                       icon: Icon(
      //                         CupertinoIcons.clear,
      //                         color: todayTip.color,
      //                       )),
      //                 ),
      //               ),
      //               Center(
      //                 child: Text(
      //                   "Text Placeholder",
      //                   style: Theme.of(context)
      //                       .textTheme
      //                       .displayLarge!
      //                       .copyWith(color: todayTip.color),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
