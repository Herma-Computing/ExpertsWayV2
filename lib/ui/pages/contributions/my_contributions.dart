import 'package:expertsway/theme/box_icons_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../models/lesson.dart';
import '../../../services/api_controller.dart';

class MyContributions extends StatefulWidget {
  const MyContributions({super.key});

  @override
  MyContributionsState createState() => MyContributionsState();
}

class MyContributionsState extends State<MyContributions> {
  late Lesson lesson;
  bool isloading = true;
  @override
  void initState() {
    getValue();
    super.initState();
  }

  getValue() async {

    lesson = await ApiProvider().getMyContributions();

    setState(() {
      isloading = false;
    });
  }

  Widget _container(String? title, String? description) {
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
            child: ExpansionTile(
              title: Row(
                children: [
                  const Icon(BoxIcons.bx_help_circle, color: Color.fromARGB(255, 193, 193, 194), size: 25),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      title!,
                      style: textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              iconColor: const Color.fromARGB(255, 193, 193, 194),
              collapsedIconColor: Colors.blue,
              children: <Widget>[
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                    child: Html(
                      data: description,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    IconThemeData icon = Theme.of(context).iconTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isloading
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
                        'Help',
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
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Center(
                            child: Image(
                                image: ResizeImage(
                              AssetImage('assets/images/helpbackground.PNG'),
                              width: 300,
                              height: 200,
                            )),
                          ),
                          SizedBox(height: 20),
                          Text(
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
                      ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: lesson.lessons.length,
                        itemBuilder: (context, index) {
                          return _container(lesson.lessons[index]?.title.toString(),
                              lesson.lessons[index]?.shortDescription.toString());
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 20);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
