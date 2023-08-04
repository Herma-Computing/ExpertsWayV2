import 'package:expertsway/ui/pages/landing_page/controller.dart';
import 'package:flutter/material.dart';
import 'package:expertsway/utils/color.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/api_controller.dart';

import '../../api/shared_preference/shared_preference.dart';
import '../../models/other_profile_model.dart';
import '../../services/follow_unfollow_controller.dart';
import '../widgets/card.dart';
import 'navmenu/menu_dashboard_layout.dart';

class OtherProfile extends StatefulWidget {
  late String userName;
  OtherProfile({Key? key}) : super(key: key);

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  // final  UserPreferences prefs=UserPreferences();

  final LandingPageController controller = Get.put(LandingPageController());
  final FollowUnfollowController followUnfollowController = Get.put(FollowUnfollowController());

  List<OtherProfileModels> otherProfileInfo = [];

  @override
  void initState() {
    followUnfollowController.getUserNmae();
    followUnfollowController.IsFollow(Get.arguments["username"]);
    widget.userName = Get.arguments["username"];
    controller.getProfileDetails();
    super.initState();
  }

  Widget build(BuildContext context) {
    ApiProvider provider = ApiProvider();
    print("gi${followUnfollowController.userNames}");
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 216, 211, 211),
          title: const Padding(
            padding: EdgeInsets.all(55.0),
            child: Text(
              "User Profiles",
              style: TextStyle(
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
                  print(snapshot.error);
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
                            followUnfollowController.userNames == Get.arguments["username"]
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
                                    ? snapshot.data!.followers.isEmpty
                                        ? const Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text(
                                              "You don't have any followers",
                                              style: TextStyle(fontSize: 20, color: Colors.black),
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.followers.length,
                                            itemBuilder: (context, index) {
                                              return Container(
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
                                                          style: const TextStyle(fontSize: 16, color: Colors.black),
                                                        ),
                                                      ),
                                                      const Spacer(flex: 2),
                                                      CircleAvatar(
                                                        minRadius: 22,
                                                        maxRadius: 22,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(100),
                                                          child: Image.network(
                                                            snapshot.data!.followers[index].avator_url,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(flex: 2),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          snapshot.data!.followers[index].first_name,
                                                          style: const TextStyle(fontSize: 16, color: Colors.black),
                                                          overflow: TextOverflow.fade,
                                                        ),
                                                      ),
                                                      const Spacer(flex: 5),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })
                                    : snapshot.data!.followings.isEmpty
                                        ? const Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text(
                                              "You didn't followings anyone yet",
                                              style: TextStyle(fontSize: 20, color: Colors.black),
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.followings.length,
                                            itemBuilder: (context, index) {
                                              return Container(
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
                                                          style: const TextStyle(fontSize: 16, color: Colors.black),
                                                        ),
                                                      ),
                                                      const Spacer(flex: 2),
                                                      CircleAvatar(
                                                        minRadius: 22,
                                                        maxRadius: 22,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(100),
                                                          child: Image.network(
                                                            snapshot.data!.followings[index].avator_url,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(flex: 2),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          snapshot.data!.followings[index].first_name,
                                                          style: const TextStyle(fontSize: 16, color: Colors.black),
                                                          overflow: TextOverflow.fade,
                                                        ),
                                                      ),
                                                      const Spacer(flex: 5),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                              ),
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
