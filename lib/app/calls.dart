import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallInvitationPage extends StatelessWidget {
  final String callerId;
  final String userID;
  final String username;
  const CallInvitationPage(
      {super.key,
      required this.callerId,
      required this.userID,
      required this.username});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1491639421,
      callID: "abc",
      userID: userID,
      userName: username,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
