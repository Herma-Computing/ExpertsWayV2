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
  Widget _container(IconData leading, String title, IconData trailing) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [BoxShadow(blurRadius: 10, offset: Offset(1, 1), color: Color.fromARGB(54, 104, 104, 104))],
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          highlightColor: const Color.fromARGB(132, 135, 208, 245),
          splashColor: const Color.fromARGB(61, 231, 231, 231),
          borderRadius: BorderRadius.circular(radius),
          child: ListTile(
            leading: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(color: const Color.fromARGB(255, 233, 233, 233), borderRadius: BorderRadius.circular(radius)),
              child: Icon(
                leading,
                color: maincolor,
                size: 18,
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(color: Color.fromARGB(255, 137, 137, 137), fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              trailing,
              color: Colors.grey,
              size: 17,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: const Header(title: "Profile"),
        ),

        const SizedBox(
          height: 30,
        ),
        // profile
        CircleAvatar(
          radius: 55,
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
                color: Color.fromARGB(255, 224, 222, 222),
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
                        "questions",
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
              decoration: BoxDecoration(color: Color.fromARGB(255, 224, 222, 222), borderRadius: BorderRadius.circular(20)),
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
                        "answer",
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
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Badges",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 100,
              width: 200,
              child: IconButton(
                  onPressed: () {},
                  icon: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {},
                      icon: Icon(
                        Icons.javascript,
                        size: 40,
                        color: Colors.yellow,
                      ),
                      label: Text(
                        "Javascrip",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ))),
            ),
            SizedBox(
              height: 100,
              width: 200,
              child: IconButton(
                  onPressed: () {},
                  icon: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {},
                      icon: Icon(
                        Icons.javascript,
                        size: 40,
                        color: Colors.yellow,
                      ),
                      label: Text(
                        "Javascrip",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ))),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 100,
              width: 200,
              child: IconButton(
                  onPressed: () {},
                  icon: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {},
                      icon: Icon(
                        Icons.javascript,
                        size: 40,
                        color: Colors.yellow,
                      ),
                      label: Text(
                        "Javascrip",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ))),
            ),
            SizedBox(
              height: 100,
              width: 200,
              child: IconButton(
                  onPressed: () {},
                  icon: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {},
                      icon: Icon(
                        Icons.javascript,
                        size: 40,
                        color: Colors.yellow,
                      ),
                      label: Text(
                        "Javascrip",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ))),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 100,
              width: 200,
              child: IconButton(
                  onPressed: () {},
                  icon: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {},
                      icon: Icon(
                        Icons.javascript,
                        size: 40,
                        color: Colors.yellow,
                      ),
                      label: Text(
                        "Javascrip",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ))),
            ),
            SizedBox(
              height: 100,
              width: 200,
              child: IconButton(
                  onPressed: () {},
                  icon: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {},
                      icon: Icon(
                        Icons.javascript,
                        size: 40,
                        color: Colors.yellow,
                      ),
                      label: Text(
                        "Javascrip",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ))),
            ),
          ],
        ),
      ],
    ));
  }
}
