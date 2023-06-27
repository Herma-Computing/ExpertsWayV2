import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/theme.dart';
import 'package:get/get.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends State<Onboarding> {
  final PageController controller = PageController(initialPage: 0);

  int counter = 0; // a counter to track which "page" we're at
  List<Widget> pictures = []; // list of the 3 pictures on the 3 "pages"
  List<Widget> messages = []; // list of the 3 messages on the 3 "pages"
  List<Widget> buttons = []; // list of the TWO buttons on the 3 "pages"
  late Widget displayedPicture; // the image currently displayed
  late Widget displayedMessage;
  late Widget displayedButton;

  @override
  void initState() {
    super.initState();
  }

  void createWidgets() {
    // this method populates the lists of widgets we use on the 3 pages
    // populating the pictures list
    pictures.addAll([
      buildSvgPicture('assets/images/freelancer.svg'),
      buildSvgPicture('assets/images/recess.svg'),
      buildSvgPicture('assets/images/knowledge.svg'),
    ]);
    // populating the buttons list
    Widget button;
    button = buildButton("Next", () {
      counter++;
      setState(() {
        displayedPicture = pictures[counter];
        displayedMessage = messages[counter];
        displayedButton = buttons[counter];
      });
    });
    buttons.add(button);
    button = buildButton("Next", () {
      counter++;
      setState(() {
        displayedPicture = pictures[counter];
        displayedMessage = messages[counter];
        displayedButton = buttons[counter];
      });
    });
    buttons.add(button);
    buttons.add(
      buildButton("Get started", signin),
    );
    // populating the messages list
    messages.addAll([
      buildMessage(
        "Learn anytime, and anywhere",
        "Discover the convenience of learning on-the-go with our app. "
            "Study at your own pace, wherever you are.",
      ),
      buildMessage(
        "Unleash Your Creativity and Compete with Style",
        "Get ready to take your skills to the next level! "
            "Our app challenges you to be creative and innovative, and rewards your efforts with recognition.",
      ),
      buildMessage(
          "High quality lectures and unlimited questions",
          "Upgrade your learning with our top-notch lectures and endless practice questions. "
              "Prepare to ace any exam and achieve your academic goals.")
    ]);
    // at the start, we show the first elements from each list
    displayedPicture = pictures[counter];
    displayedMessage = messages[counter];
    displayedButton = buttons[counter];
  }

  Widget buildMessage(String mainMessage, String subMessage) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      key: UniqueKey(),
      height: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: <Widget>[
            Text(
              mainMessage,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              subMessage,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String label, VoidCallback onTap) {
    return SizedBox(
      key: UniqueKey(),
      width: 240,
      height: 50,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0396FF), Color.fromARGB(255, 110, 195, 255)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSvgPicture(String assetName) {
    return SizedBox(
      key: UniqueKey(),
      height: MediaQuery.of(context).size.height * 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SvgPicture.asset(assetName),
      ),
    );
  }

  Widget buildPageControlDots(int currentPageNumber) {
    return Row(
      key: UniqueKey(),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (var index = 0; index < 3; index++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: CircleAvatar(
              radius: 5,
              backgroundColor: index == currentPageNumber ? Colors.blue : Colors.blue[100],
            ),
          )
      ],
    );
  }

  Future signin() async {
    // try {
    //   final user = await GoogleSignInApi.login();
    //   String? name = user!.displayName;
    //   String? image = user.photoUrl;

    //   // SharedPreferences pref = await SharedPreferences.getInstance();
    //   UserPreferences.setuser(image!, name!);
    // } catch (error) {
    //   // console.error("Error during login: ", error);
    //   UserPreferences.setuser(
    //       "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50",
    //       "testDisplayName");
    // }

    // ignore: use_build_context_synchronously

    SharedPreferences sharedPreferennces = await SharedPreferences.getInstance();
    sharedPreferennces.setBool('dontshowonboarding', true);

    Get.offAllNamed('/auth');
    }

  @override
  Widget build(BuildContext context) {
    // we will maintain the same layout-forming column but switch the
    // contained widgets in order to show the 3 different "pages"
    createWidgets();
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
      body: Column(
        children: <Widget>[
          const Spacer(flex: 3),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: displayedPicture,
          ),
          const Spacer(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: displayedMessage,
          ),
          const Spacer(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: buildPageControlDots(counter),
          ),
          const Spacer(
            flex: 2,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: displayedButton,
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
