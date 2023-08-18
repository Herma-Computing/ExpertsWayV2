import 'package:dio/dio.dart';
import 'package:expertsway/ui/pages/landing_page/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expertsway/utils/color.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../services/api_controller.dart';

import '../../models/lesson.dart';
import '../../models/other_profile_model.dart';
import '../../routes/routing_constants.dart';
import '../../services/follow_unfollow_controller.dart';
import '../../services/user_search_controller.dart';
import '../../theme/theme.dart';
import '../widgets/card.dart';
import 'navmenu/menu_dashboard_layout.dart';

final LandingPageController landingPagesController = Get.put(LandingPageController());

class OtherProfile extends StatefulWidget {
  OtherProfile({Key? key}) : super(key: key);

  late String userName;

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  // final  UserPreferences prefs=UserPreferences();
  late Lesson lesson;
  bool isloading = true;
  final FollowUnfollowController followUnfollowController = Get.put(FollowUnfollowController());

  List<OtherProfileModels> otherProfileInfo = [];
  final TextEditingController _filter = TextEditingController();
  UserSearchController userSearchController = Get.put(UserSearchController());
  // for http requests
  bool isSearch = false;

  String _searchText = "";
  Widget _appBarTitle = Text("");

  // names we get from API
  List filteredNames = []; // names filtered by search text
  Icon _searchIcon = const Icon(Icons.search);
  _OtherProfileState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = userSearchController.globalAllUserNames;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }
  @override
  void initState() {
    _appBarTitle = Text(
      "@${Get.arguments["username"]}",
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
    );
    followUnfollowController.getUserNmae();
    followUnfollowController.IsFollow(Get.arguments["username"]);
    widget.userName = Get.arguments["username"];
    landingPagesController.getProfileDetails();
    getValue();

    super.initState();
  }

  getValue() async {
    lesson = await ApiProvider().getMyContributions();

    setState(() {
      isloading = false;
    });
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        isSearch = true;
        _searchIcon = const Icon(Icons.close);
        _appBarTitle = TextField(
          controller: _filter,
          decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                size: 20,
              ),
              hintText: 'Search by userName...'),
        );
      } else {
        isSearch = false;
        _searchIcon = const Icon(Icons.search);
        _appBarTitle = Text(
          "@${widget.userName}",
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        );
        filteredNames = userSearchController.globalAllUserNames;
        _filter.clear();
      }
    });
  }

  Widget _buildList() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // ignore: prefer_is_not_empty
    if (!(_searchText.isEmpty)) {
      List tempList = [];

      for (int i = 0; i < userSearchController.globalAllUserNames.length; i++) {
        if (userSearchController.globalAllUserNames[i]['username'].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(userSearchController.globalAllUserNames[i]);
        }
      }

      filteredNames = tempList;
    }

    return ListView.builder(
      itemCount: filteredNames.isEmpty ? userSearchController.globalAllUserNames.length : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return SingleChildScrollView(
            child: Stack(children: [
          Container(
            margin: EdgeInsets.only(left: 150),
            color: Colors.white,
            height: MediaQuery.of(context).size.height - 200,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              for (int index = 0; index < (filteredNames.isEmpty ? userSearchController.globalAllUserNames.length : filteredNames.length); index++)
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
                      Get.toNamed(AppRoute.otherProfilePage, preventDuplicates: false, arguments: {
                        'username':filteredNames.isEmpty ? userSearchController.globalAllUserNames[index]['username'] : filteredNames[index]['username'],
                      });
                    },
                    child: Container(
                      height: 70,
                      margin: EdgeInsets.only(left: 150),
                      width: MediaQuery.of(context).size.width - 80,
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1),
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
                                  filteredNames.isEmpty
                                      ? userSearchController.globalAllUserNames[index]['avatar_url']
                                      : filteredNames[index]['avatar_url'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Spacer(flex: 2),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                filteredNames.isEmpty
                                    ? userSearchController.globalAllUserNames[index]['first_name']
                                    : filteredNames[index]['first_name'],
                                style: TextStyle(fontSize: 16, color: textColor),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            const Spacer(flex: 5),
                            Text(
                              "${filteredNames.isEmpty ? userSearchController.globalAllUserNames[index]['month_score'] : filteredNames[index]['month_score']} pts.",
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
        ]));
      },
    );
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
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 216, 211, 211),
          title: _appBarTitle,
          actions: [
            // Navigate to the Search Screen
            IconButton(
                onPressed: () {
                  _searchPressed();
                },
                icon: _searchIcon)
          ],
        ),
        body: Stack(
          children: [
            FutureBuilder<OtherProfileModels>(
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
                                                fontSize: 20,
                                                color: controller.getfollowers == true ? Color.fromARGB(255, 11, 140, 214) : Colors.black),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            followUnfollowController.seeFollowing();
                                          },
                                          child: Text(
                                            "Following",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: controller.getfollowers == false ? Color.fromARGB(255, 11, 140, 214) : Colors.black),
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
                                                  "No followers found!",
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
                                                padding: EdgeInsets.all(18.0),
                                                child: Text(
                                                  "No followings found!",
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
                                            child: const Text(
                                              "Contributed Lessons",
                                              style: TextStyle(fontSize: 20),
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
                                                  const Image(
                                                      image: ResizeImage(
                                                    AssetImage('assets/images/helpbackground.PNG'),
                                                    width: 300,
                                                    height: 200,
                                                  )),
                                                  SizedBox(height: 20),
                                                  const Text(
                                                    "Success leaves clues.",
                                                    style: TextStyle(
                                                      color: Color.fromARGB(255, 193, 193, 194),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  const Text(
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
                }),
            isSearch == true ? _buildList(): Text(""),
          ],
        ));
  }
}
