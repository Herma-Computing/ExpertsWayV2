import 'package:flutter/material.dart';
// import 'package:expertsway/main.dart' as main;

// ignore: constant_identifier_names
enum ThemeType { Light, Dark }

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = ThemeType.Light as ThemeData;
  ThemeType themeType = ThemeType.Dark;

  ThemeModel(this.currentTheme, this.themeType);

  // toggleTheme() {
  //   if (this.themeType == ThemeType.Dark) {
  //     main.prefs.setBool("darkMode", false);
  //     this.currentTheme = kLightTheme;
  //     this.themeType = ThemeType.Light;
  //     print(main.prefs.getBool("darkMode"));
  //     return notifyListeners();
  //   }

  //   if (this.themeType == ThemeType.Light) {
  //     main.prefs.setBool("darkMode", true);
  //     this.currentTheme = kDarkTheme;
  //     this.themeType = ThemeType.Dark;
  //     print(main.prefs.getBool("darkMode"));
  //     return notifyListeners();
  //   }
  // }

  returnTheme() {
    return themeType;
  }
}
