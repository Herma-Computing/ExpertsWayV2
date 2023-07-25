import 'package:expertsway/ui/pages/landing_page/controller.dart';
import 'package:flutter/material.dart';
import 'package:expertsway/utils/color.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';

class OtherProfile extends StatefulWidget {
  const OtherProfile({Key? key}) : super(key: key);

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  // final  UserPreferences prefs=UserPreferences();
  final TextEditingController _searchController = TextEditingController();
  final LandingPageController controller = Get.put(LandingPageController());
  @override
  void initState() {
    controller.getProfileDetails();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        // This controller will store the value of the search bar

        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            centerTitle: true,
            title: Container(
                // Add padding around the search bar
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                // Use a Material design search bar
                child: Text(
                  "Other Profiles",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ))),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        // Add a clear button to the search bar
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.black,
                          ),
                          onPressed: () => _searchController.clear(),
                        ),
                        // Add a search icon or button to the search bar
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // Perform the search here
                          },
                        ),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(20.0),
                        // ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Local",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Global",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext, context) {
                              return CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.orange,
                                child: CircleAvatar(radius: 50, backgroundImage: AssetImage("assets/images/avatar_1.jpg")),
                              );
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 100,
                    child: ListView.builder(
                        itemCount: 30,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, index) {
                          return Card(
                              color: ConstantColors[index],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.orange,
                                    child: CircleAvatar(radius: 50, backgroundImage: AssetImage("assets/images/avatar_1.jpg")),
                                  ),
                                  Text(
                                    "Samuel",
                                    style: TextStyle(fontSize: 10, color: Colors.black),
                                  ),
                                  Text(
                                    "50Pts",
                                    style: TextStyle(fontSize: 10, color: Colors.black),
                                  )
                                ],
                              ));
                        }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
