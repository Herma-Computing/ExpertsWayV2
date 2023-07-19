import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:expertsway/models/course.dart';
import 'package:expertsway/ui/pages/course_detail/controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expertsway/routes/routing_constants.dart';
import 'package:expertsway/theme/box_icons_icons.dart';
import 'package:expertsway/ui/pages/course_detail/course_detail.dart';
import 'package:expertsway/ui/pages/landing_page/index.dart';
import 'package:expertsway/ui/pages/setting.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:expertsway/ui/pages/notification.dart' as notification_page;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/theme.dart';
import '../../../utils/color.dart';

class LandingPage extends GetView<LandingPageController> {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Obx(() {
      if (controller.allCourses.isEmpty && controller.fetchFail.value) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Something went wrong", style: TextStyle(fontSize: 22)),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    controller.setUpController();
                  },
                  child: const Text(
                    "Retry",
                    style: TextStyle(color: maincolor),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (controller.loading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: maincolor,
            ),
          ),
        );
      }
      return Theme(
          data: Theme.of(context).copyWith(
            buttonTheme: ButtonThemeData(
              buttonColor: themeProvider.currentTheme == ThemeData.dark() ? Colors.white : Colors.black,
            ),
          ),
          child: Scaffold(
            key: controller.scaffoldKey,
            backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
            appBar: CustomAppBar(
              themeProvider: themeProvider,
              controller: controller,
              theme: theme,
              scaffoldKey: controller.scaffoldKey,
            ),
            drawer: Drawer(
              elevation: 1,
              backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
              child: SafeArea(
                child: ListView(
                  children: [
                    DrawerHeader(controller, theme),
                    DrawerButton(
                      onPress: () {
                        controller.scaffoldKey.currentState?.closeDrawer();
                        Get.toNamed(AppRoute.landingPage);
                      },
                      theme: theme,
                      icon: BoxIcons.bx_home,
                      name: 'Home',
                    ),
                    // DrawerButton(
                    //   onPress: () {},
                    //   theme: theme,
                    //   icon: BoxIcons.bx_notepad,
                    //   name: 'To-do',
                    // ),
                    // DrawerButton(
                    //   onPress: () {},
                    //   theme: theme,
                    //   icon: Icons.play_arrow_outlined,
                    //   name: 'Videos',
                    // ),
                    DrawerButton(
                      onPress: () {
                        controller.scaffoldKey.currentState?.closeDrawer();
                        Get.toNamed(AppRoute.leaderBoardPage);
                      },
                      theme: theme,
                      icon: BoxIcons.bx_line_chart,
                      name: 'Leaderboard',
                    ),
                    // DrawerButton(
                    //   onPress: () {},
                    //   theme: theme,
                    //   icon: BoxIcons.bx_calendar_week,
                    //   name: 'calendar',
                    // ),
                    DrawerButton(
                      onPress: () {
                        controller.scaffoldKey.currentState?.closeDrawer();
                        Get.toNamed(AppRoute.bookmarkPage);
                      },
                      theme: theme,
                      icon: BoxIcons.bx_bookmarks,
                      name: 'Bookmarks',
                    ),
                    DrawerButton(
                      onPress: () async {
                        controller.scaffoldKey.currentState?.closeDrawer();
                        Get.toNamed(AppRoute.myContributions);
                      },
                      theme: theme,
                      icon: BoxIcons.bx_bookmarks,
                      name: 'My Contributions',
                    ),
                    const Divider(),
                    DrawerButton(
                      onPress: () async {
                        await Get.to(() => const Settings());
                        controller.update();
                      },
                      theme: theme,
                      icon: BoxIcons.bx_cog,
                      name: 'Settings',
                    ),
                    DrawerButton(
                      onPress: () {
                        Get.toNamed(AppRoute.help);
                      },
                      theme: theme,
                      icon: BoxIcons.bx_help_circle,
                      name: 'Help',
                    ),
                    DrawerButton(
                      onPress: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.remove("image");
                        prefs.remove("username");
                        prefs.remove("name");
                        prefs.remove("last_name");
                        prefs.remove("email");
                        prefs.remove("token");
                        prefs.remove("birthdate");
                        prefs.remove("occupation");
                        prefs.remove("country");
                        prefs.remove("languages");
                        try {
                          final GoogleSignIn googleSignIn = GoogleSignIn();
                          await googleSignIn.disconnect();
                        } catch (_) {}

                        Get.offNamedUntil(AppRoute.authPage, (route) => false);
                      },
                      theme: theme,
                      icon: BoxIcons.bx_log_out,
                      name: 'Logout',
                    ),
                  ],
                ),
              ),
            ),
            body: DoubleBackToCloseApp(
              snackBar: SnackBar(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(20),
                backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
                content: Center(
                  child: Text(
                    'Press back button again to exit'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: themeProvider.currentTheme == ThemeData.light() ? const Color.fromARGB(255, 25, 32, 36) : Colors.white,
                    ),
                    // style: theme.textTheme.bodySmall?.copyWith(color: theme.shadowColor),
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate([
                        // _Header(
                        //   t0heme: theme,
                        //   controller: controller,
                        // ),
                        const SizedBox(height: 12),

                        // search input field
                        SearchTextField(
                          hintText: "Search any course",
                          onChanged: (val) {
                            if (kDebugMode) print(val);
                          },
                        ),
                        const SizedBox(height: 12),

                        // header
                        _LanguageHeader(
                          theme: theme,
                          title: 'Recommended courses',
                        ),

                        const SizedBox(height: 12),

                        AlignedGridView.count(
                            shrinkWrap: true,
                            mainAxisSpacing: 20,
                            crossAxisCount: 2,
                            crossAxisSpacing: 30,
                            itemCount: controller.coursesToDisplay.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  // we need to delete the previous controller.
                                  Get.delete<CourseDetailController>();
                                  Get.put(CourseDetailController(courseData: controller.coursesToDisplay[index]));
                                  Get.to(
                                    () => const CourseDetailPage(),
                                  );
                                },
                                child: CardWidget(
                                    name: controller.coursesToDisplay[index].name,
                                    banner: controller.coursesToDisplay[index].banner,
                                    icon: controller.coursesToDisplay[index].icon,
                                    theme: theme,
                                    level: controller.coursesToDisplay[index].level,
                                    minutesToFinish: controller.coursesToDisplay[index].minutesToFinish,
                                    rate: controller.coursesToDisplay[index].rate),
                              );
                            }),
                        const SizedBox(height: 12),
                        if (controller.startedCourses.isNotEmpty)
                          _LanguageHeader(
                            theme: theme,
                            title: 'Your Courses',
                          ),

                        const SizedBox(height: 12),

                        AlignedGridView.count(
                            shrinkWrap: true,
                            mainAxisSpacing: 20,
                            crossAxisCount: 2,
                            crossAxisSpacing: 30,
                            itemCount: controller.startedCourses.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var progress = controller.progressList
                                  .firstWhere((element) => element.courseSlug == controller.startedCourses[index].slug)
                                  .percentage;
                              return InkWell(
                                onTap: () {
                                  // we need to delete the previous controller.
                                  Get.delete<CourseDetailController>();
                                  Get.put(CourseDetailController(courseData: controller.startedCourses[index]));
                                  Get.to(
                                    () => const CourseDetailPage(),
                                  );
                                },
                                child: CardWidget(
                                  name: controller.startedCourses[index].name,
                                  banner: controller.startedCourses[index].banner,
                                  icon: controller.startedCourses[index].icon,
                                  progressPercentage: progress,
                                  theme: theme,
                                  level: controller.startedCourses[index].level,
                                  minutesToFinish: controller.startedCourses[index].minutesToFinish,
                                ),
                              );
                            })
                      ])),

                      // landing page header
                    ],
                  ),
                ),
              ),
            ),
          ));
    });
  }
}

class CustomAppBar extends AppBar {
  late final ThemeProvider themeProvider;
  late final LandingPageController controller;
  late final ThemeData theme;

  CustomAppBar({
    super.key,
    required themeProvider,
    required controller,
    required theme,
    GlobalKey<ScaffoldState>? scaffoldKey,
  }) : super(
          automaticallyImplyLeading: false,
          backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
          shadowColor: Colors.transparent,
          centerTitle: true,
          leading: Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(left: 25),
              child: InkResponse(
                  radius: 25,
                  onTap: () {
                    if (scaffoldKey != null) {
                      scaffoldKey.currentState?.openDrawer();
                    }
                  },
                  child: Image.asset(
                    themeProvider.currentTheme == ThemeData.light() ? 'assets/images/drawer_icon.png' : 'assets/images/drawer_icon_white.png',
                    height: 20,
                    width: 20,
                  )),
            );
          }),
          leadingWidth: 60,
          title: _Header(
            theme: theme,
            controller: controller,
          ),
          actions: [
            Container(
              padding: const EdgeInsets.only(right: 10, top: 15),
              child: InkWell(
                onTap: () => Get.to(() => const notification_page.Notification()),
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Icon(Icons.notifications_none_rounded,
                        size: 28,
                        color: themeProvider.currentTheme == ThemeData.dark()
                            ? const Color.fromARGB(255, 221, 221, 221)
                            : const Color.fromARGB(255, 63, 63, 63).withOpacity(0.8)),
                    const Positioned(
                        top: 4,
                        right: 4,
                        child: CircleAvatar(
                          maxRadius: 5,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(maxRadius: 4, backgroundColor: Colors.blue),
                        ))
                  ],
                ),
              ),
            ),
          ],
        );
}

class LandingPageFundamentalCourseChips extends StatefulWidget {
  // this function executes when one of the chips is pressed. The isSelected argument is related to the toggling state of the chips
  final Function(bool isSelected, CourseElement courseElement)? onButtonClick;
  const LandingPageFundamentalCourseChips({Key? key, this.onButtonClick}) : super(key: key);

  @override
  State<LandingPageFundamentalCourseChips> createState() => _LandingPageFundamentalCourseChipsState();
}

class _LandingPageFundamentalCourseChipsState extends State<LandingPageFundamentalCourseChips> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    /// do not remove this line (we need it for the automatic keep alive)!!!
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    LandingPageController controller = Get.find<LandingPageController>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          for (int index = 0; index < controller.fundamentalCourses.length; index++)
            Builder(builder: (context) {
              var isSelected = controller.displayedPrerequisites.contains(controller.fundamentalCourses[index].slug);
              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
                child: InkWell(
                  onTap: () {
                    if (widget.onButtonClick != null) {
                      widget.onButtonClick!(isSelected, controller.fundamentalCourses[index]);
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: themeProvider.currentTheme == ThemeData.light()
                          ? (isSelected ? Colors.blue[100] : Colors.white)
                          : (isSelected ? Colors.blue[800] : const Color.fromARGB(26, 255, 255, 255)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.transparent,
                          child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: controller.fundamentalCourses[index].icon,
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(controller.fundamentalCourses[index].name)
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

class SearchTextField extends StatelessWidget {
  final String? hintText;
  final Icon? trailingIcon;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  const SearchTextField({Key? key, this.onChanged, this.onSubmitted, this.hintText, this.trailingIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color backgroundColor = Theme.of(context).cardColor;
    return Container(
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10), boxShadow: [
        BoxShadow(
            blurRadius: 20,
            color: themeProvider.currentTheme == ThemeData.light() ? Colors.grey.shade300 : Colors.transparent,
            spreadRadius: -6,
            offset: const Offset(-1, 8))
      ]),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Color.fromARGB(90, 166, 165, 165), fontSize: 18, fontWeight: FontWeight.w400),
          hintText: hintText ?? "Search",
          prefixIcon: Icon(
            Icons.search,
            color: themeProvider.currentTheme == ThemeData.light() ? const Color.fromARGB(90, 45, 45, 45) : const Color.fromARGB(90, 183, 182, 182),
          ),
          suffixIcon: trailingIcon,
          border: InputBorder.none,
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class _LanguageHeader extends StatelessWidget {
  final ThemeData theme;
  final String title;
  const _LanguageHeader({required this.theme, required this.title});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final ThemeData theme;
  final LandingPageController controller;
  const _Header({required this.theme, required this.controller});
  

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        SizedBox(
          width: (MediaQuery.of(context).size.width - 300) / 2,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w300),
            ),
            Text(
              controller.profileName ?? 'User',
              style: textTheme.displayLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width - 300) / 2,
        ),
      ],
    );
  }
}

class CardWidget extends StatelessWidget {
  final String banner;
  final String icon;
  final String name;
  final double? progressPercentage;
  final ThemeData theme;
  final String level;
  final int? minutesToFinish;
  final String? rate;

  const CardWidget({
    Key? key,
    required this.banner,
    required this.icon,
    required this.name,
    this.progressPercentage,
    required this.theme,
    required this.level,
    this.minutesToFinish,
    this.rate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    Color backgroundColor = Theme.of(context).cardColor;
    return Container(
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10), boxShadow: [
        BoxShadow(
            blurRadius: 20,
            color: themeProvider.currentTheme == ThemeData.light() ? Colors.grey.shade300 : Colors.transparent,
            spreadRadius: -6,
            offset: const Offset(-1, 8))
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: banner,
              height: 70,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              name,
              style: textTheme.bodyMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: icon,
                        height: 26,
                        width: 26,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 70,
                      child: FittedBox(
                        child: Text(
                          level,
                          style: textTheme.titleLarge?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
                if (minutesToFinish != null)
                  Row(
                    children: [
                      Text(
                        calcTime(minutesToFinish!),
                        style: textTheme.titleLarge?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      Icon(
                        Icons.timer_sharp,
                        size: 16,
                        color: Colors.grey.shade400,
                      )
                    ],
                  )
              ],
            ),
          ),
          if (progressPercentage != null) ...[
            LinearPercentIndicator(
              percent: progressPercentage!,
              backgroundColor: Colors.grey.shade200,
              progressColor: const Color(0xff26B0FF),
              animation: true,
              animationDuration: 1000,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completed',
                    style: textTheme.titleLarge?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    '${(progressPercentage! * 100).round()}%',
                    style: textTheme.titleLarge?.copyWith(fontSize: 12, color: const Color(0xff26B0FF)),
                  ),
                ],
              ),
            ),
          ],
          if (progressPercentage == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Color(0xffFCEA2B),
                      ),
                      if (rate != null)
                        Text(
                          rate!,
                          style: textTheme.titleLarge?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Enroll Now',
                        style: textTheme.titleLarge?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(width: 4),
                      const CircleAvatar(
                        backgroundColor: Color.fromARGB(80, 38, 175, 255),
                        maxRadius: 10,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: Color(0xff26B0FF),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  calcTime(int value) {
    int h = 0;
    int m = 0;

    if (value < 60) {
      m = value;
    } else {
      h = value ~/ 60;
    }

    String hour = h.toString().length < 2 ? "$h" : h.toString();
    String min = m.toString().length < 2 ? "$m" : m.toString();

    String result = int.parse(hour) >= 1 ? "$hour hr" : "$min min";

    return result;
  }
}

class DrawerHeader extends StatelessWidget {
  final LandingPageController controller;
  final ThemeData theme;
  const DrawerHeader(
    this.controller,
    this.theme, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GetBuilder<LandingPageController>(
            builder: (controller) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed('/profile');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: controller.profileImage == null
                      ? Image.asset(
                          'assets/images/profile_placeholder.png',
                          height: 60,
                          width: 60,
                        )
                      : CachedNetworkImage(
                          imageUrl: controller.profileImage!,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/profile');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.profileName ?? '',
                  style: textTheme.displayLarge?.copyWith(fontSize: 19, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                Text(
                  'Student',
                  style: textTheme.displayMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  final Function()? onPress;
  final ThemeData theme;
  final IconData icon;
  final String name;
  const DrawerButton({
    super.key,
    required this.onPress,
    required this.theme,
    required this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        splashColor: themeProvider.currentTheme == ThemeData.dark() ? const Color.fromARGB(64, 38, 176, 255) : const Color(0xff26B0FF),
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: themeProvider.currentTheme == ThemeData.dark() ? const Color.fromARGB(64, 38, 176, 255) : Colors.lightBlue[100],
                child: Icon(
                  icon,
                  size: 20,
                  color: themeProvider.currentTheme == ThemeData.dark()
                      ? const Color.fromARGB(255, 221, 221, 221)
                      : const Color.fromARGB(255, 63, 63, 63).withOpacity(0.8),
                ),
              ),
              const SizedBox(width: 28),
              Text(
                name,
                style: textTheme.displayMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
