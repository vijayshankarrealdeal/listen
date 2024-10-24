import 'package:flutter/material.dart';
import 'package:listen/models/user_app.dart';
import 'package:listen/services/db.dart';

class SearchTextFieldLogic extends ChangeNotifier {
  List<FUsers> users = [];
  int nextItems = 0;
  void removefromSearchArea(context){
    FocusScope.of(context).unfocus();
    users = [];
    notifyListeners();
  }
  TextEditingController controller = TextEditingController();
  void onChanged(Database db, String searchTerm) async {
    users = await db.searchPsy(searchTerm);
    notifyListeners();
  }
  

}
