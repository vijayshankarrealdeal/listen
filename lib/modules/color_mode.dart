import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorMode extends ChangeNotifier {
  ColorMode() {
    _init();
  }
  bool light = true;

  void _init() async {
    final pref = await SharedPreferences.getInstance();
    light = pref.getBool('mode') ?? true;
    notifyListeners();
  }

  void onChange(bool x) async {
    final pref = await SharedPreferences.getInstance();
    if (x) {
      light = x;
      pref.setBool('mode', x);
    } else {
      light = x;
      pref.setBool('mode', x);
    }

    notifyListeners();
  }

  Color textBasic() {
    return light
        ? const Color.fromRGBO(0, 0, 0, 1)
        : const Color.fromRGBO(255, 255, 255, 1);
  }

  Color textlastMessage() {
    return light
        ? const Color.fromRGBO(60, 60, 67, 0.60)
        : const Color.fromRGBO(235, 235, 245, 0.60);
  }

  Color chatBubbleUser() {
    return light
        ? const Color.fromRGBO(0, 122, 255, 1)
        : const Color.fromRGBO(10, 132, 255, 1);
  }

  Color invite() {
    return light
        ? const Color.fromRGBO(0, 122, 255, 1)
        : const Color.fromRGBO(10, 132, 255, 0.85);
  }

  Color chatBubbleNUser() {
    return light
        ? const Color.fromRGBO(230, 229, 235, 1)
        : const Color.fromRGBO(38, 38, 41, 1);
  }

  Color chatBubbleTextUser() {
    return light
        ? const Color.fromRGBO(255, 255, 255, 1)
        : const Color.fromRGBO(255, 255, 255, 1);
  }

  Color chatBubbleTextNUser() {
    return light
        ? const Color.fromRGBO(0, 0, 0, 1)
        : const Color.fromRGBO(255, 255, 255, 1);
  }
}