// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:expertsway/theme/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';

// IMPOTANT: We are not using this themeData anywhere in the app.
// the theme to the cupertino app is provided in the main.dart file.
// and the font family 'Red Hat Display' is no longer suppoted in this codebase.
class ThemeProvider extends ChangeNotifier {
  // ThemeMode themeMode = ThemeMode.system;
  ThemeData _currentTheme = ThemeData.light();
  ThemeData get currentTheme => _currentTheme;

  ThemeProvider(bool isDark) {
    if (isDark) {
      _currentTheme = ThemeData.dark();
    } else {
      _currentTheme = ThemeData.light();
    }
  }

  void toggleTheme() async {
    SharedPreferences sharedPreferennces = await SharedPreferences.getInstance();
    if (_currentTheme == ThemeData.light()) {
      _currentTheme = ThemeData.dark();
      sharedPreferennces.setBool('is_dark', true);
    } else {
      _currentTheme = ThemeData.light();
      sharedPreferennces.setBool('is_dark', false);
    }
    notifyListeners();
  }
}

class Themes {
  static final lightTheme = ThemeData(
    // appBarTheme:
    //     AppBarTheme(backgroundColor: const Color.fromARGB(255, 124, 61, 200)),
    scaffoldBackgroundColor: Colors.white, shadowColor: Colors.transparent,
    // colorScheme: const ColorScheme.light(),
    canvasColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.black),
    primaryColor: Colors.white, cardColor: Colors.white,
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    hintColor: config.Colors().mainColor(1),
    textTheme: TextTheme(
      button: const TextStyle(
        fontFamily: 'Red Hat Display',
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFFFFFFFF),
      ),
      headline5: TextStyle(
        fontSize: 16.0,
        color: const Color.fromARGB(255, 41, 40, 40).withOpacity(0.7),
        fontFamily: "Red Hat Display",
      ),
      headline4: TextStyle(fontSize: 16, fontFamily: "Red Hat Display", fontWeight: FontWeight.w500, color: config.Colors().accentColor(1)),
      headline3: TextStyle(
        fontSize: 20,
        fontFamily: "Red Hat Display",
        fontWeight: FontWeight.w500,
        color: Colors.white.withOpacity(0.4),
      ),
      headline2: TextStyle(
        fontSize: 24,
        fontFamily: "Red Hat Display",
        fontWeight: FontWeight.w500,
        color: const Color.fromARGB(255, 41, 40, 40).withOpacity(0.9),
      ),
      headline1: TextStyle(
        fontFamily: 'Red Hat Display',
        color: const Color.fromARGB(255, 26, 26, 26).withOpacity(0.9),
        fontSize: 50,
        fontWeight: FontWeight.w600,
      ),
      subtitle1: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: config.Colors().secondColor(1),
        fontFamily: "Roboto",
      ),
      headline6: TextStyle(
        fontSize: 13.0,
        color: Colors.grey[500],
        fontFamily: "Red Hat Display",
      ),
      bodyText2: TextStyle(
        fontFamily: 'Red Hat Display',
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.grey[800],
      ),
      // bodyMedium: TextStyle(
      //   fontFamily: 'Red Hat Display',
      //   fontSize: 20,
      //   fontWeight: FontWeight.w500,
      //   color: Colors.black,
      // ),
      bodyText1: TextStyle(
        fontFamily: 'Red Hat Display',
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Colors.white.withOpacity(1),
      ),

      // caption: TextStyle(
      //   fontFamily: 'Red Hat Display',
      //   fontSize: 16,
      //   fontWeight: FontWeight.w400,
      //   color: config.Colors().accentColor(1),
      // ),
    ),
    buttonTheme: const ButtonThemeData(buttonColor: Color.fromARGB(255, 182, 114, 246)),
  );
  static final darkTheme = ThemeData(
    buttonTheme: const ButtonThemeData(buttonColor: Color.fromARGB(255, 75, 51, 79)),
    shadowColor: Colors.transparent,
    scaffoldBackgroundColor: const Color.fromARGB(0, 38, 50, 56),
    colorScheme: const ColorScheme.dark(),
    iconTheme: const IconThemeData(color: Colors.white),
    canvasColor: Colors.transparent,
    primaryColor: const Color.fromARGB(0, 38, 50, 56),
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    // accentColor: config.Colors().accentDarkColor(1),
    focusColor: config.Colors().mainDarkColor(1),
    hintColor: config.Colors().secondDarkColor(1),
    cardColor: const Color.fromARGB(26, 255, 255, 255),
    backgroundColor: const Color.fromARGB(26, 255, 255, 255),
    // accentTextTheme: const TextTheme(headline6: TextStyle(fontFamily: "Red Hat Display")),
    textTheme: TextTheme(
      button: const TextStyle(
        fontFamily: 'Red Hat Display',
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF181818),
      ),
      headline5: TextStyle(
        fontSize: 16.0,
        color: config.Colors().accentDarkColor(1),
        fontFamily: "Red Hat Display",
      ),
      headline4: TextStyle(fontSize: 16, fontFamily: "Red Hat Display", fontWeight: FontWeight.w500, color: config.Colors().accentDarkColor(1)),
      headline3: const TextStyle(fontSize: 20, fontFamily: "Red Hat Display", fontWeight: FontWeight.w500, color: Colors.white),
      headline2: const TextStyle(fontSize: 24, fontFamily: "Red Hat Display", fontWeight: FontWeight.w500, color: Colors.white),
      headline1: TextStyle(
        fontFamily: 'Red Hat Display',
        color: config.Colors().accentDarkColor(1),
        fontSize: 50,
        fontWeight: FontWeight.w600,
      ),
      subtitle1: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: config.Colors().secondDarkColor(1),
        fontFamily: "Roboto",
      ),
      headline6: const TextStyle(
        fontSize: 14.0,
        color: Colors.white,
        fontFamily: "Red Hat Display",
      ),
      bodyText2: const TextStyle(
        fontFamily: 'Red Hat Display',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      // bodyMedium: TextStyle(
      //   fontFamily: 'Red Hat Display',
      //   fontSize: 20,
      //   fontWeight: FontWeight.w500,
      //   color: Colors.white,
      // ),
      bodyText1: TextStyle(
        fontFamily: 'Red Hat Display',
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: config.Colors().accentDarkColor(1),
      ),
      // caption: TextStyle(
      //   fontFamily: 'Red Hat Display',
      //   fontSize: 16,
      //   fontWeight: FontWeight.w400,
      //   color: config.Colors().accentDarkColor(1),
      // ),
    ),
  );
}

// var kLightTheme = ThemeData(
//   canvasColor: Colors.transparent,
//   primaryColor: Colors.white,
//   brightness: Brightness.light,
//   accentColor: config.Colors().accentColor(1),
//   focusColor: config.Colors().mainColor(1),
//   hintColor: config.Colors().secondColor(1),
//   accentTextTheme:
//       TextTheme(headline6: TextStyle(fontFamily: "Red Hat Display")),
//   textTheme: TextTheme(
//     button: TextStyle(
//       fontFamily: 'Red Hat Display',
//       fontSize: 16,
//       fontWeight: FontWeight.w800,
//       color: Color(0xFFFFFFFF),
//     ),
//     headline5: TextStyle(
//       fontSize: 16.0,
//       color: Colors.white.withOpacity(1),
//       fontFamily: "Red Hat Display",
//     ),
//     headline4: TextStyle(
//         fontSize: 16,
//         fontFamily: "Red Hat Display",
//         fontWeight: FontWeight.w500,
//         color: config.Colors().accentColor(1)),
//     headline3: TextStyle(
//         fontSize: 20,
//         fontFamily: "Red Hat Display",
//         fontWeight: FontWeight.w500,
//         color: Colors.black),
//     headline2: TextStyle(
//         fontSize: 24,
//         fontFamily: "Red Hat Display",
//         fontWeight: FontWeight.w500,
//         color: Colors.black),
//     headline1: TextStyle(
//       fontFamily: 'Red Hat Display',
//       color: config.Colors().accentColor(1),
//       fontSize: 50,
//       fontWeight: FontWeight.w600,
//     ),
//     subtitle1: TextStyle(
//       fontSize: 20,
//       fontWeight: FontWeight.w900,
//       color: config.Colors().secondColor(1),
//       fontFamily: "Roboto",
//     ),
//     headline6: TextStyle(
//       fontSize: 13.0,
//       color: Colors.white.withOpacity(.85),
//       fontFamily: "Red Hat Display",
//     ),
//     bodyText2: TextStyle(
//       fontFamily: 'Red Hat Display',
//       fontSize: 14,
//       fontWeight: FontWeight.w500,
//       color: Colors.white.withOpacity(.75),
//     ),
//     bodyText1: TextStyle(
//       fontFamily: 'Red Hat Display',
//       fontSize: 24,
//       fontWeight: FontWeight.w500,
//       color: Colors.white.withOpacity(1),
//     ),
//     caption: TextStyle(
//       fontFamily: 'Roboto',
//       fontSize: 16,
//       fontWeight: FontWeight.w400,
//       color: config.Colors().accentColor(1),
//     ),
//   ),
// );

// var kDarkTheme = ThemeData(
//   canvasColor: Colors.transparent,
//   primaryColor: Color(0xFF181818),
//   brightness: Brightness.dark,
//   accentColor: config.Colors().accentDarkColor(1),
//   focusColor: config.Colors().mainDarkColor(1),
//   hintColor: config.Colors().secondDarkColor(1),
//   accentTextTheme:
//       TextTheme(headline6: TextStyle(fontFamily: "Red Hat Display")),
//   textTheme: TextTheme(
//     button: TextStyle(
//       fontFamily: 'Red Hat Display',
//       fontSize: 16,
//       fontWeight: FontWeight.w800,
//       color: Color(0xFF181818),
//     ),
//     headline5: TextStyle(
//       fontSize: 16.0,
//       color: config.Colors().accentDarkColor(1),
//       fontFamily: "Red Hat Display",
//     ),
//     headline4: TextStyle(
//         fontSize: 16,
//         fontFamily: "Red Hat Display",
//         fontWeight: FontWeight.w500,
//         color: config.Colors().accentDarkColor(1)),
//     headline3: TextStyle(
//         fontSize: 20,
//         fontFamily: "Red Hat Display",
//         fontWeight: FontWeight.w500,
//         color: Colors.white),
//     headline2: TextStyle(
//         fontSize: 24,
//         fontFamily: "Red Hat Display",
//         fontWeight: FontWeight.w500,
//         color: Colors.white),
//     headline1: TextStyle(
//       fontFamily: 'Red Hat Display',
//       color: config.Colors().accentDarkColor(1),
//       fontSize: 50,
//       fontWeight: FontWeight.w600,
//     ),
//     subtitle1: TextStyle(
//       fontSize: 20,
//       fontWeight: FontWeight.w900,
//       color: config.Colors().secondDarkColor(1),
//       fontFamily: "Roboto",
//     ),
//     headline6: TextStyle(
//       fontSize: 14.0,
//       color: config.Colors().accentDarkColor(.85),
//       fontFamily: "Red Hat Display",
//     ),
//     bodyText2: TextStyle(
//       fontFamily: 'Red Hat Display',
//       fontSize: 14,
//       fontWeight: FontWeight.w500,
//       color: config.Colors().accentDarkColor(.85),
//     ),
//     bodyText1: TextStyle(
//       fontFamily: 'Red Hat Display',
//       fontSize: 22,
//       fontWeight: FontWeight.w500,
//       color: config.Colors().accentDarkColor(1),
//     ),
//     caption: TextStyle(
//       fontFamily: 'Roboto',
//       fontSize: 16,
//       fontWeight: FontWeight.w400,
//       color: config.Colors().accentDarkColor(1),
//     ),
//   ),
// );
