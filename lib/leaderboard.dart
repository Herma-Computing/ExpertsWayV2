import 'package:expertsway/routes/routing_constants.dart';
import 'package:expertsway/services/api_controller.dart';
import 'package:expertsway/services/follow_unfollow_controller.dart';
import 'package:expertsway/theme/box_icons_icons.dart';
import 'package:expertsway/theme/theme.dart';
import 'package:expertsway/ui/pages/landing_page/index.dart' hide CardWidget;
import 'package:expertsway/ui/pages/profile_edit.dart';
import 'package:expertsway/ui/pages/setting.dart';
import 'package:expertsway/ui/widgets/card.dart';
import 'package:expertsway/ui/widgets/gradient_button.dart';
import 'package:expertsway/utils/color.dart';

import 'package:flutter/material.dart' hide DrawerHeader, DrawerButton;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/other_profile_model.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({
    Key? key,
    required this.onMenuTap,
  }) : super(key: key);
  final Function()? onMenuTap;

  @override
  LeaderBoardPageState createState() => LeaderBoardPageState();
}

class LeaderBoardPageState extends State<LeaderBoardPage> {
  final FollowUnfollowController followUnfollowController = Get.put(FollowUnfollowController());
  TextEditingController controller = TextEditingController();
  late bool local;
  LandingPageController landingPageController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Future<Map<String, List<Map<String, dynamic>>>> leaderboardDataFuture = ApiProvider().fetchLeaderboardData();
  late final SharedPreferences prefs;

  final List names = [
    'Sarvesh Mehta',
    'Karanjeet Gill',
    'Rahul Bose',
    'Sarvesh Mehta',
    'Karanjeet Gill',
    'Rahul Bose',
  ];

  final List coins = ['3895', '3678', '3675', '3456', '3455', '3454', '3453', '3452', '3451', '3450'];

  final List colors = const [
    Color(0xFFFFD700),
    Color(0xFFC0C0C0),
    Color(0xFFCD7F32),
    Color(0xFF0396FF),
    Color(0xFF0396FF),
    Color(0xFF0396FF),
    Color(0xFF0396FF),
    Color(0xFF0396FF),
    Color(0xFF0396FF),
    Color(0xFF0396FF)
  ];
  @override
  void initState() {
    local = false;
    SharedPreferences.getInstance().then((value) => prefs = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Provider.of<ThemeProvider>(context).currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
      drawer: Drawer(
        elevation: 1,
        backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
        child: SafeArea(
          child: ListView(
            children: [
              DrawerHeader(landingPageController, theme),
              DrawerButton(
                onPress: () {
                  scaffoldKey.currentState?.closeDrawer();
                  Get.toNamed(AppRoute.landingPage);
                },
                theme: theme,
                icon: BoxIcons.bx_home,
                name: 'Home',
              ),
              DrawerButton(
                onPress: () {},
                theme: theme,
                icon: BoxIcons.bx_notepad,
                name: 'To-do',
              ),
              DrawerButton(
                onPress: () {},
                theme: theme,
                icon: Icons.play_arrow_outlined,
                name: 'Videos',
              ),
              DrawerButton(
                onPress: () {
                  scaffoldKey.currentState?.closeDrawer();
                },
                theme: theme,
                icon: BoxIcons.bx_line_chart,
                name: 'Leaderboard',
              ),
              DrawerButton(
                onPress: () {},
                theme: theme,
                icon: BoxIcons.bx_calendar_week,
                name: 'calendar',
              ),
              DrawerButton(
                onPress: () {
                  scaffoldKey.currentState?.closeDrawer();
                  Get.offAndToNamed(AppRoute.bookmarkPage);
                },
                theme: theme,
                icon: BoxIcons.bx_bookmarks,
                name: 'Bookmarks',
              ),
              const Divider(),
              DrawerButton(
                onPress: () => Get.to(() => const Settings()),
                theme: theme,
                icon: BoxIcons.bx_cog,
                name: 'Settings',
              ),
              DrawerButton(
                onPress: () {},
                theme: theme,
                icon: BoxIcons.bx_help_circle,
                name: 'Help',
              ),
              DrawerButton(
                onPress: () {},
                theme: theme,
                icon: BoxIcons.bx_log_out,
                name: 'Logout',
              ),
            ],
          ),
        ),
      ),
      appBar: CustomAppBar(
        themeProvider: Provider.of<ThemeProvider>(context),
        controller: landingPageController,
        theme: Theme.of(context),
        scaffoldKey: scaffoldKey,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          var avatarAndListHeight = constraints.maxHeight - 134; // 128 is the height of the rest of the widgets in the column.
          return Column(
            children: <Widget>[
              _buildSearchAndSwitch(context),
              SizedBox(
                height: avatarAndListHeight,
                child: Builder(builder: (context) {
                  if (local) {
                    String? country = prefs.getString("country");
                    if (country == null) {
                      return buildNoNationalityLayout(context);
                    }
                  }
                  return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
                    future: leaderboardDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("An error occurred."),
                          );
                        }
                        if (snapshot.hasData) {
                          var data = local ? snapshot.data!['local']! : snapshot.data!['global']!;
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: 150,
                                child: SizedBox(
                                  // this sizedBox gives constraints to the listView that'd be unconstrained otherwise.
                                  height: avatarAndListHeight - 154,
                                  // the following line requires that the data is sent from the server as {local: [], global: []}
                                  child: _buildLeaderboardList(data),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                child: _buildTopThreeAvatars(context, data),
                              ),
                            ],
                          );
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: maincolor,
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  Column buildNoNationalityLayout(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset("assets/images/jungle.svg"),
        const Spacer(flex: 2),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.0),
          child: Text(
            "We couldn't find where you're from",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            "Please set your nationality to view your rank locally.",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
          ),
        ),
        const Spacer(flex: 2),
        GradientBtn(
          btnName: "Update Nationality",
          defaultBtn: true,
          isPcked: false,
          height: 50,
          width: 230,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfile()),
            );
            setState(() {});
          },
        ),
        const Spacer(flex: 4),
      ],
    );
  }

  Widget _buildTopThreeAvatars(BuildContext context, List<Map<dynamic, dynamic>> leaderboardData) {
    return InkWell(
      onTap: () async {
        //  OtherProfileModels  value=  await  provider.fetchOtherProfileInformation();

        //        Get.toNamed(AppRoute.otherProfilePage, arguments: {
        //           'firstName': value.first_name,
        //           "lastName": value.last_name,
        //           "isFollowing": value.is_following,
        //           "ocupation": value.occupation,
        //           "avatarUrl": value.avatar_url,
        //           "birthDate": value.birthdate,
        //           "country": value.country,
        //           "preferedLanguges": value.perfered_languages,
        //         }

        //         );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (leaderboardData.length >= 3)
              Positioned(
                key: const Key("third"),
                left: 20,
                top: 26,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.brown,
                      minRadius: 50,
                      maxRadius: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            leaderboardData[2]['avatar_url'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -8,
                      child: Container(
                        width: 36,
                        height: 36,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Center(
                          child: Text(
                            "3rd",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (leaderboardData.length >= 2)
              Positioned(
                key: const Key("second"),
                right: 20,
                top: 26,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      minRadius: 50,
                      maxRadius: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            leaderboardData[1]['avatar_url'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -8,
                      child: Container(
                        width: 36,
                        height: 36,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Center(
                          child: Text(
                            "2nd",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (leaderboardData.isNotEmpty)
              Positioned(
                key: const Key("first"),
                top: 0,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: AlignmentDirectional.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange,
                      minRadius: 70,
                      maxRadius: 70,
                      child: Container(
                        width: 140,
                        height: 140,
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            leaderboardData[0]['avatar_url'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 166, 0),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Center(
                          child: Text(
                            "1st",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Column _buildSearchAndSwitch(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 44,
            child: const SearchTextField(
              trailingIcon: Icon(
                Icons.display_settings,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.07,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    local = true;
                  });
                },
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      "Local",
                      style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    if (local)
                      Container(
                        width: 50,
                        height: 3,
                        decoration: BoxDecoration(color: const Color(0xFF03A9F4), borderRadius: BorderRadius.circular(500)),
                      ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    local = false;
                  });
                },
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      "Global",
                      style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    if (!local)
                      Container(
                        width: 50,
                        height: 3,
                        decoration: BoxDecoration(color: const Color(0xFF03A9F4), borderRadius: BorderRadius.circular(500)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList(List<Map<dynamic, dynamic>> leaderboardData) {
    // the widget built by this method should be constrained externally. call this method in a SizedBox or something.
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          for (int index = 0; index < leaderboardData.length; index++)
            Builder(builder: (context) {
              var backgroundColor = () {
                if (index == 0) return Colors.orange;
                if (index == 1) return Colors.blue;
                if (index == 2) return Colors.brown;
                if (themeProvider.currentTheme == ThemeData.dark()) return const Color.fromARGB(255, 48, 48, 48);
                return Colors.white;
              }.call();
              var textColor = themeProvider.currentTheme == ThemeData.dark() ? Colors.white : Colors.black;
              return InkWell(
                onTap: () async {
                  followUnfollowController.itisnotYou();

                  Get.toNamed(AppRoute.otherProfilePage, arguments: {
                    'username': leaderboardData[index]['username'],
                  });
                },
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width - 16,
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
                  child: CardWidget(
                    gradient: false,
                    button: false,
                    height: 60,
                    color: backgroundColor,
                    child: Row(
                      children: <Widget>[
                        const Spacer(flex: 1),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${index + 1}.",
                            style: TextStyle(fontSize: 16, color: textColor),
                          ),
                        ),
                        const Spacer(flex: 2),
                        CircleAvatar(
                          minRadius: 22,
                          maxRadius: 22,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              leaderboardData[index]['avatar_url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Spacer(flex: 2),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            leaderboardData[index]['first_name'],
                            style: TextStyle(fontSize: 16, color: textColor),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        const Spacer(flex: 5),
                        Text(
                          "${leaderboardData[index]['month_score']} pts.",
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              );
            })
        ],
      ),
    );
  }
}
