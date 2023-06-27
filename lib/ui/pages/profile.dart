import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expertsway/ui/widgets/header.dart';
import 'package:expertsway/utils/color.dart';

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
        boxShadow: const [
          BoxShadow(
              blurRadius: 10,
              offset: Offset(1, 1),
              color: Color.fromARGB(54, 104, 104, 104))
        ],
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
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 233, 233, 233),
                  borderRadius: BorderRadius.circular(radius)),
              child: Icon(
                leading,
                color: maincolor,
                size: 18,
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                  color: Color.fromARGB(255, 137, 137, 137),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
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
        body: Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Column(
        children: [
          const Header(title: "Profile"),

          const SizedBox(
            height: 30,
          ),
          // profile
          Container(
            margin: const EdgeInsets.all(12),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.4,
                  margin: const EdgeInsets.only(top: 55),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(202, 116, 175, 211),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 20,
                        offset: Offset(5, 15),
                        color: Colors.black12,
                      )
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: const [
                              Text(
                                "John Perol",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(221, 33, 33, 33)),
                              ),
                              Text(
                                "Student",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black38),
                              ),
                            ],
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
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "23",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25,
                                            color: grey1),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      FittedBox(
                                        child: Text(
                                          "questions",
                                          style: TextStyle(
                                              fontSize: 18, color: grey2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 90,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "88",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25,
                                            color: Color.fromARGB(
                                                202, 75, 75, 75)),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      FittedBox(
                                        child: Text(
                                          "answer",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 101, 101, 101)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: seccolor,
                    child: CircleAvatar(
                      radius: 53,
                      backgroundImage: AssetImage(
                        "assets/images/user.jpg",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),

          // list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _container(
                      FontAwesomeIcons.question,
                      "My questions",
                      Icons.arrow_forward_ios,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _container(
                      FontAwesomeIcons.check,
                      "My answer",
                      Icons.arrow_forward_ios,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _container(
                      FontAwesomeIcons.calendar,
                      "My Calendar",
                      Icons.arrow_forward_ios,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _container(
                      Icons.logout,
                      "Log out",
                      Icons.arrow_forward_ios,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
