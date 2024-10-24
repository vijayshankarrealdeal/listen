import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listen/models/user_app.dart';

class CallLogs {
  final List<String> uids;
  final int callCount;
  final List<Timestamp> callTime;
  final String callLogId;
  final FUsers user;
  final Timestamp callDate;

  CallLogs({
    required this.callDate,
    required this.uids,
    required this.callCount,
    required this.callTime,
    required this.callLogId,
    required this.user,
  });

  // Convert a CallLogs object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'uids': uids,
      'callCount': callCount,
      'callLogId': callLogId,
    };
  }

  // Create a CallLogs object from a JSON map
  factory CallLogs.fromJson(Map<String, dynamic> json, FUsers user) {
    // Handle the 'callTime' field which can be a list of Timestamp objects
    var callTimeList = json['callTime'] as List;
    List<Timestamp> callTimes = callTimeList.map((e) {
      if (e is Timestamp) {
        return e;
      } else {
        // If somehow a string is encountered, handle it by parsing the date
        return Timestamp.fromDate(DateTime.parse(e));
      }
    }).toList();

    // Sort the list of Timestamps from latest to past
    callTimes.sort((a, b) => b.compareTo(a));

    return CallLogs(
      callDate: json['call_date'],
      user: user,
      uids: List<String>.from(json['uids']),
      callCount: json['callCount'],
      callTime: callTimes,
      callLogId: json['callLogId'],
    );
  }
}
