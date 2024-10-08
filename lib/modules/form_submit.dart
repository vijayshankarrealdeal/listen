import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:listen/models/user_app.dart';
import 'package:listen/services/db.dart';
import 'package:listen/widgets/error_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormSubmit extends ChangeNotifier {
  TextEditingController dobController = TextEditingController();
  TextEditingController cont = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController email = TextEditingController();
  bool load = false;
  final String displayProfile =
      "https://firebasestorage.googleapis.com/v0/b/music-e276c.appspot.com/o/ss.png?alt=media&token=1e7123ca-712a-4f93-812c-c9ad629fea3a";
  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      notifyListeners();
    }
  }

  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegExp.hasMatch(email);
  }

  Map<String, dynamic> mapper = {
    "Male": "M",
    "Female": "F",
    "User": "U",
    "Psycologist": "E"
  };
  void registerUser(Database db, BuildContext context) async {
    if (name.text.isEmpty) {
      errorAlert(context, "You must enter a name.");
      return;
    } else if (cont.text.isEmpty) {
      errorAlert(context, "You must select a gender.");
      return;
    } else if (dobController.text.isEmpty) {
      errorAlert(context, "Enter valid date");
      return;
    } else if (role.text.isEmpty) {
      errorAlert(context, "You must select a role.");
      return;
    } else if (email.text.isNotEmpty && !isValidEmail(email.text)) {
      errorAlert(context, "You must enter valid email.");
      return;
    }
    String? token = await FirebaseMessaging.instance.getToken();

    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dobController.text);
    Timestamp timestamp = Timestamp.fromDate(dateTime);
    load = true;
    notifyListeners();
    FUsers user = FUsers(
      phoneNumber: db.phoneNum,
      uid: db.currentUseruid,
      name: name.text,
      gender: mapper[cont.text],
      email: email.text,
      dob: timestamp,
      role: mapper[role.text],
      displayProfile: displayProfile,
      fmcToken: token ?? "",
    );
    try {
      await db.addUser(user);
      load = false;
      name.clear();
      dobController.clear();
      role.clear();
      cont.clear();
      email.clear();
      notifyListeners();
    } catch (e) {
      load = false;
    }
  }

  @override
  void dispose() {
    name.dispose();
    dobController.dispose();
    role.dispose();
    cont.dispose();
    email.dispose();
    super.dispose();
  }
}
