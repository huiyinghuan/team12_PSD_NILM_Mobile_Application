import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
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