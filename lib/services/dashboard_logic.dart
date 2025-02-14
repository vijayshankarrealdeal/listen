import 'package:flutter/material.dart';
import 'package:listen/models/daily_tips.dart';
import 'package:listen/services/db.dart';

class DailyTipsNotifier extends ChangeNotifier {
  final Database db;
  List<DailyTips> _dailyTips = [];

  List<DailyTips> get dailyTips => _dailyTips;

  DailyTipsNotifier({required this.db}) {
    // Subscribe to the stream on app start
    _initialize();
  }

  void _initialize() {
    db.getCombinedDailyTips().listen((dailyTipsData) {
      _dailyTips = dailyTipsData;
      notifyListeners();
    });
  }
}
