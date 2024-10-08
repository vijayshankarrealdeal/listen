import 'package:flutter/cupertino.dart';

class ChatCallsScreenLogic extends ChangeNotifier {
  int indexSelected = 0;

  void changeChangeIndex(int idx) {
    indexSelected = idx;
    notifyListeners();
  }
}
