import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier{
  bool isDarkMode = false;

  void changeTheme(){
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}