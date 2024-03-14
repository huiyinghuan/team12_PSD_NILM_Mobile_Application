// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class Navigation_Provider extends ChangeNotifier {
  bool _isCollapsed = false;

  bool get isCollapsed => _isCollapsed;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void toggleIsCollapsed() {
    _isCollapsed = !isCollapsed;

    notifyListeners();
  }
}
