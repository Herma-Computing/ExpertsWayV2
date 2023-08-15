import 'package:expertsway/ui/pages/landing_page/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expertsway/utils/color.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/api_controller.dart';

import '../../api/shared_preference/shared_preference.dart';
import '../../models/lesson.dart';
import '../../models/other_profile_model.dart';
import '../../routes/routing_constants.dart';
import '../../services/follow_unfollow_controller.dart';
import '../widgets/card.dart';
import 'contributions/my_contributions.dart';
import 'navmenu/menu_dashboard_layout.dart';
import 'package:expertsway/theme/box_icons_icons.dart';

final LandingPageController Pagescontroller = Get.put(LandingPageController());

class OtherProfile extends StatefulWidget {
  late String userName;

  OtherProfile({Key? key}) : super(key: key);

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  // final  UserPreferences prefs=UserPreferences();
  late Lesson lesson;
  bool isloading = true;
  final FollowUnfollowController followUnfollowController = Get.put(FollowUnfollowController());

  List<OtherProfileModels> otherProfileInfo = [];

  @override
  void initState() {
    followUnfollowController.getUserNmae();
    followUnfollowController.IsFollow(Get.arguments["username"]);
    widget.userName = Get.arguments["username"];
    Pagescontroller.getProfileDetails();
    getValue();
    super.initState();
  }

  getValue() async {
    lesson = await ApiProvider().getMyContributions();

    setState(() {
      isloading = false;
    });
  }

  Widget _container(String? title, String? description, LessonElement lesons) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.white,
      child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(54, 188, 187, 187),
                blurRadius: 10,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              iconTheme: const IconThemeData(
                size: 35,
              ),
            ),
            child: ListTile(
              onTap: () async {
                // await Get.to(
                //   () => LessonPage(
                //     lessonData: controller.lessonData,
                //     lesson: lesons, // this is LessonElement
                //     contents: lessonContents,
                //     courseData: controller.courseData,
                //   ),
                // );
              },
              title: Padding(
                padding: const EdgeInsets.only(left: 100),
                child: Text(
                  title!,
                  style: textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Html(
                  data: description,
                ),
              ),
            ),
          )),
    );
  }

  Widget build(BuildContext context) {
    ApiProvider provider = ApiProvider();
    TextTheme textTheme = Theme.of(context).textTheme;
    IconThemeData icon = Theme.of(context).iconTheme;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 216, 211, 211),
          title: Padding(
            padding: const EdgeInsets.all(55.0),
            child: Text(
              "@${widget.userName}",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: FutureBuilder<OtherProfileModels>(
            future: provider.fetchOtherProfileInformation(widget.userName),

            //future: provider.fetchOtherProfileInformation("esubalew"), //this is for testing
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 30, top: 150),
                        child: Text("something went wrong please try agin latter "),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text("check your internet connections "),
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text("Try again")),
                    ],
                  );
                }
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: seccolor,
                              child: CircleAvatar(
                                radius: 53,
                                backgroundImage: NetworkImage(
                                  snapshot.data!.avatar_url,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                snapshot.data!.first_name,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color.fromARGB(221, 33, 33, 33)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            followUnfollowController.checkIsYou == true
                                ? Text("")
                                : followUnfollowController.userNames == Get.arguments["username"]
                                    ? const Text("")
                                    : followUnfollowController.userNames == ""
                                        ? const Text("something went wrong")
                                        : Padding(
                                            padding: const EdgeInsets.only(left: 130, bottom: 30),
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(Icons.check_circle),
                                                ),
                                                GetBuilder<FollowUnfollowController>(
                                                  builder: (controller) => ElevatedButton(
                                                      onPressed: () {
                                                        if (controller.isfollowOrunfollow == true) {
                                                          provider.unfollow(widget.userName);
                                                          followUnfollowController.IsFollow(widget.userName);
                                                        } else {
                                                          provider.follow(widget.userName);
                                                          followUnfollowController.IsFollow(widget.userName);
                                                        }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.white,
                                                      ),
                                                      child: controller.isfollowOrunfollow == true
                                                          ? const Text(
                                                              "following",
                                                              style: TextStyle(color: Colors.black),
                                                            )
                                                          : const Text(
                                                              "follow",
                                                              style: TextStyle(color: Colors.black),
                                                            )),
                                                )
                                              ],
                                            ),
                                          ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 238, 236, 236),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height: 100,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "23",
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: grey1),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        FittedBox(
                                          child: Text(
                                            "questions Answered",
                                            style: TextStyle(fontSize: 18, color: grey2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 90,
                                  height: 100,
                                  decoration: BoxDecoration(color: Color.fromARGB(255, 238, 236, 236), borderRadius: BorderRadius.circular(20)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "88",
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: Color.fromARGB(202, 75, 75, 75)),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        FittedBox(
                                          child: Text(
                                            "Course Completed",
                                            style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 101, 101, 101)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 238, 236, 236),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height: 100,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "23",
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: grey1),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        FittedBox(
                                          child: Text(
                                            "Last Ranking",
                                            style: TextStyle(fontSize: 18, color: grey2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 90,
                                  height: 100,
                                  decoration: BoxDecoration(color: Color.fromARGB(255, 238, 236, 236), borderRadius: BorderRadius.circular(20)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "88",
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: Color.fromARGB(202, 75, 75, 75)),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        FittedBox(
                                          child: Text(
                                            "Global Ranking",
                                            style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 101, 101, 101)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Text(
                                "Badges",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  // margin: const EdgeInsets.only(left: 30, top: 100, right: 30, bottom: 50),
                                  height: 50,
                                  width: 145,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image(image: AssetImage("assets/images/js.png")),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text("Javascript"),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // margin: const EdgeInsets.only(left: 30, top: 100, right: 30, bottom: 50),
                                  height: 50,
                                  width: 145,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image(image: AssetImage("assets/images/python.png")),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text("python"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  // margin: const EdgeInsets.only(left: 30, top: 100, right: 30, bottom: 50),
                                  height: 50,
                                  width: 145,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image(image: AssetImage("assets/images/java.png")),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text("Java"),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  //margin: const EdgeInsets.only(left: 30, top: 100, right: 30, bottom: 50),
                                  height: 50,
                                  width: 145,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Image(image: AssetImage("assets/images/go.png")),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text("Go"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  // margin: const EdgeInsets.only(left: 30, top: 100, right: 30, bottom: 50),
                                  height: 50,
                                  width: 145,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image(image: AssetImage("assets/images/cpp.png")),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text("C++"),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // margin: const EdgeInsets.only(left: 30, top: 100, right: 30, bottom: 50),
                                  height: 50,
                                  width: 145,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Image(
                                            image: AssetImage(
                                          "assets/images/mysql.png",
                                        )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text("Mysql"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GetBuilder<FollowUnfollowController>(
                              builder: (controller) => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        followUnfollowController.seeFollowers();
                                      },
                                      child: Text(
                                        "Followers",
                                        style: TextStyle(
                                            fontSize: 20, color: controller.getfollowers == true ? Color.fromARGB(255, 11, 140, 214) : Colors.black),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        followUnfollowController.seeFollowing();
                                      },
                                      child: Text(
                                        "Following",
                                        style: TextStyle(
                                            fontSize: 20, color: controller.getfollowers == false ? Color.fromARGB(255, 11, 140, 214) : Colors.black),
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: GetBuilder<FollowUnfollowController>(
                                builder: (controller) => controller.getfollowers == true
                                    ? snapshot.data!.followers!.isEmpty
                                        ? const Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text(
                                              "You don't have any followers",
                                              style: TextStyle(fontSize: 20, color: Colors.black),
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.followers!.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Get.toNamed(AppRoute.otherProfilePage, preventDuplicates: false, arguments: {
                                                    'username': snapshot.data!.followers![index].username,
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
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text(
                                                          "${index + 1}.",
                                                          style: const TextStyle(fontSize: 16, color: Colors.black),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        CircleAvatar(
                                                          minRadius: 22,
                                                          maxRadius: 22,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(100),
                                                            child: Image.network(
                                                              snapshot.data!.followers![index].avatorUrl,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text(
                                                          snapshot.data!.followers![index].firstName,
                                                          style: const TextStyle(fontSize: 16, color: Colors.black),
                                                          overflow: TextOverflow.fade,
                                                        ),
                                                        const SizedBox(
                                                          width: 30,
                                                        ),
                                                        Expanded(child: Container()),
                                                        snapshot.data!.is_following == true
                                                            ? const Text("following")
                                                            : TextButton(
                                                                onPressed: () {},
                                                                child: const Text("follow", style: TextStyle(color: Colors.white, fontSize: 15)),
                                                              ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            })
                                    : snapshot.data!.followings!.isEmpty
                                        ? const Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text(
                                              "You didn't followings anyone yet",
                                              style: TextStyle(fontSize: 20, color: Colors.black),
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.followings!.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Get.toNamed(AppRoute.otherProfilePage, preventDuplicates: false, arguments: {
                                                    'username': snapshot.data!.followings![index].username,
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
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text(
                                                          "${index + 1}.",
                                                          style: const TextStyle(fontSize: 16, color: Colors.black),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        CircleAvatar(
                                                          minRadius: 22,
                                                          maxRadius: 22,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(100),
                                                            child: Image.network(
                                                              snapshot.data!.followings![index].avatorUrl,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text(
                                                          snapshot.data!.followings![index].firstName,
                                                          style: const TextStyle(fontSize: 16, color: Colors.black),
                                                          overflow: TextOverflow.fade,
                                                        ),
                                                        Expanded(child: Container()),
                                                        snapshot.data!.is_following == true
                                                            ? const Text("following")
                                                            : TextButton(
                                                                onPressed: () {},
                                                                child: const Text(
                                                                  "follow",
                                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                                )),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                              ),
                            ),
                            isloading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                  ))
                                : Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 40, left: 5, right: 25),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CupertinoButton(
                                              padding: const EdgeInsets.all(0),
                                              child: Icon(
                                                Icons.chevron_left,
                                                color: icon.color,
                                                size: 35,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            Text(
                                              'My Contributions',
                                              textAlign: TextAlign.end,
                                              style: textTheme.displayLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CupertinoButton(
                                                padding: const EdgeInsets.only(left: 3),
                                                child: const Icon(
                                                  Icons.search,
                                                  color: Colors.grey,
                                                  size: 30,
                                                ),
                                                onPressed: () {},
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Stack(
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ListView.separated(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: lesson.lessons.length,
                                                itemBuilder: (context, index) {
                                                  return _container(
                                                    lesson.lessons[index]?.title.toString(),
                                                    lesson.lessons[index]?.shortDescription.toString(),
                                                    lesson.lessons[index]!,
                                                  );
                                                },
                                                separatorBuilder: (context, index) {
                                                  return const SizedBox(height: 20);
                                                },
                                              ),
                                            const   Image(
                                                  image: ResizeImage(
                                                AssetImage('assets/images/helpbackground.PNG'),
                                                width: 300,
                                                height: 200,
                                              )),
                                              SizedBox(height: 20),
                                             const  Text(
                                                "Success leaves clues.",
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 193, 193, 194),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Study People you admire or want to be like.",
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 193, 193, 194),
                                                ),
                                              ),
                                              SizedBox(height: 50),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Text("user information is Empty");
                  }
                }
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
