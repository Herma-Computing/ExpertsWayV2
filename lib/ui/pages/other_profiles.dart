import 'package:expertsway/ui/pages/landing_page/controller.dart';
import 'package:flutter/material.dart';
import 'package:expertsway/utils/color.dart';
import 'package:get/get.dart';
import 'package:expertsway/models/auth_model.dart';

class OtherProfile extends StatefulWidget {
  const OtherProfile({Key? key}) : super(key: key);

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  // final  UserPreferences prefs=UserPreferences();

  final LandingPageController controller = Get.put(LandingPageController());
  @override
  void initState() {
    controller.getProfileDetails();
    super.initState();
  }

  Widget build(BuildContext context) {
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: seccolor,
                  child: CircleAvatar(
                    radius: 53,
                    backgroundImage: NetworkImage(
                      "${Get.arguments["avatarUrl"]}",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "${Get.arguments["firstName"]}",
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color.fromARGB(221, 33, 33, 33)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 130, bottom: 30),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.check_circle),
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "${Get.arguments["isFollowing"]}",
                            style: const TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          )),
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
                        color: Color.fromARGB(255, 238, 236, 236),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
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
              ],
            ),
          ),
        ));
  }
}
