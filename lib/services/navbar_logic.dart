import 'package:flutter/material.dart';

class NavbarLogic extends ChangeNotifier {
  int idx = 0;
  List<bool> activeColor = [true, false, false, false];

  void change(int indx) {
    activeColor[indx] = true;
    idx = indx;
    for (int i = 0; i < activeColor.length; i++) {
      if (i != indx) {
        activeColor[i] = false;
      }
    }

    notifyListeners();
  }
}
