import 'package:expertsway/ui/pages/landing_page/controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expertsway/ui/widgets/header.dart';
import 'package:expertsway/utils/color.dart';
import 'package:get/get.dart';

LandingPageController _controller = LandingPageController();

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
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
                    backgroundImage: AssetImage(
                      "${_controller.profileImage}",
                    ),
                  ),
                ),
                const Text(
                  "Solomon Girma",
                  // "${_controller.profileNames}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color.fromARGB(221, 33, 33, 33)),
                ),
                const SizedBox(
                  height: 20,
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
                SizedBox(
                  height: 15,
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
                            offset: Offset(0, 3), // changes position of shadow
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
                            offset: Offset(0, 3), // changes position of shadow
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
                SizedBox(
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
                            offset: Offset(0, 3), // changes position of shadow
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
                SizedBox(
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
                            offset: Offset(0, 3), // changes position of shadow
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
                            offset: Offset(0, 3), // changes position of shadow
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
              ],
            ),
          ),
        ));
  }
}
