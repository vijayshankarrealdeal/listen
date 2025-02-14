import 'package:flutter/material.dart';

class DailyTips {
  final String imageUrl;
  final Color color;
  final String text;
  final String banners;

  DailyTips({
    required this.imageUrl,
    required this.color,
    required this.text,
    this.banners = ""
  });
}

