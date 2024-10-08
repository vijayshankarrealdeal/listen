import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> errorAlert(BuildContext context, String message) async {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title:  Text("Alert",style: TextStyle(color: Colors.green.shade900),),
        content: Text(message),
        actions: [
          CupertinoButton(
            child: const Text("Okay"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}