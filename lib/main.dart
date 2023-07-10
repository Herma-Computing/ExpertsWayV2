import 'package:expertsway/auth/auth.dart';
import 'package:expertsway/routes/page.dart';
import 'package:expertsway/routes/routing_constants.dart';
import 'package:expertsway/theme/theme.dart';
import 'package:expertsway/ui/pages/navmenu/menu_dashboard_layout.dart';
import 'package:expertsway/ui/pages/onboarding1.dart';
import 'package:expertsway/ui/pages/undefined_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expertsway/routes/router.dart' as router;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

String? name;
String? image;
late SharedPreferences prefs;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferennces = await SharedPreferences.getInstance();

  final isDark = sharedPreferennces.getBool('is_dark') ?? false;
  final dontshowonboarding = sharedPreferennces.getBool('dontshowonboarding') ?? false;
  final logedin = checkuserlogin(sharedPreferennces);

  SharedPreferences.getInstance().then((prefs) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(
          RestartWidget(
            child: MyApp(isDark: isDark, dontshowonboarding: dontshowonboarding, logedin: logedin),
          ),
        ));
  });
}

bool checkuserlogin(SharedPreferences sharedPreferennces) {
  String? token = sharedPreferennces.getString("token");
  if (token != null) {
    return true;
  } else {
    return false;
  }
}

class MyApp extends StatefulWidget {
  final bool isDark;
  final bool dontshowonboarding;
  final bool logedin;
  const MyApp({
    super.key,
    required this.isDark,
    required this.dontshowonboarding,
    required this.logedin,
  });

  @override
  MyAppState createState() => MyAppState();
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyAppState extends State<MyApp> {
  // getValue() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //Return double
  //   name = prefs.getString('name');
  //   image = prefs.getString('image');
  // }

  @override
  void initState() {
    const MenuDashboardLayout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(widget.isDark),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        context.read<ThemeProvider>();
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          localizationsDelegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          themeMode: themeProvider.currentTheme == ThemeData.light() ? ThemeMode.light : ThemeMode.dark,
          theme: Themes.lightTheme,
          darkTheme: Themes.darkTheme,
          onGenerateRoute: router.generateRoute,
          onUnknownRoute: (settings) => CupertinoPageRoute(
              builder: (context) => UndefinedScreen(
                    name: settings.name,
                  )),
          // theme: Provider.of<ThemeModel>(context).currentTheme,
          debugShowCheckedModeBanner: false,
          getPages: pages,
          home: SplashScreen(dontshowonboarding: widget.dontshowonboarding, logedin: widget.logedin),
        );
      });
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({this.child, super.key});

  final Widget? child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<RestartWidgetState>()!.restartApp();
  }

  @override
  RestartWidgetState createState() => RestartWidgetState();
}

class RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child!,
    );
  }
}

class SplashScreen extends StatelessWidget {
  // final youController = Get.find<LandingPageController>();
  final bool dontshowonboarding;
  final bool logedin;
  const SplashScreen({Key? key, required this.dontshowonboarding, required this.logedin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final text = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
    //     ? 'DarkTheme'
    //     : 'LightTheme';
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final taskController = youController;
    bool signedIn = logedin;

    return Scaffold(
      body: AnimatedSplashScreen(
          splash: Image.asset('assets/images/splash.png'),
          duration: 3000,
          curve: Curves.easeInOut,
          splashIconSize: 350,
          splashTransition: SplashTransition.slideTransition,
          animationDuration: const Duration(milliseconds: 1500),
          backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
          pageTransitionType: PageTransitionType.fade,
          nextScreen: dontshowonboarding ? const AuthPage() : const Onboarding(),
          nextRoute: signedIn ? AppRoute.landingPage : null),
    );
  }
}
