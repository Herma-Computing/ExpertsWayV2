import 'package:flutter/foundation.dart';
import 'package:expertsway/routes/routing_constants.dart';
import 'package:expertsway/ui/pages/home.dart';
import 'package:expertsway/ui/pages/undefined_screen.dart';
import 'package:flutter/cupertino.dart';

List<String> navStack = ["Home"];
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoute.homeRoute:
      navStack.add("Splash");
      if (kDebugMode) {
        print(navStack);
      }
      return CupertinoPageRoute(builder: (context) => const Home());
    // case SearchRoute:
    //   navStack.add("Search");
    //   print(navStack);
    //   analytics.setCurrentScreen(screenName: SearchRoute);
    //   return PageRouteBuilder(
    //       pageBuilder: (context, animation1, animation2) => SearchScreen());
    default:
      navStack.add("undefined");
      if (kDebugMode) {
        print(navStack);
      }
      return CupertinoPageRoute(
        builder: (context) => UndefinedScreen(
          name: settings.name,
        ),
      );
  }
}
