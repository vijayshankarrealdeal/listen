import 'package:flutter/material.dart';

class LifecycleNotifier with ChangeNotifier, WidgetsBindingObserver {
  LifecycleNotifier() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // Code to execute before the app is closed
      // Notify listeners if needed
      notifyListeners();
    }
  }
}
