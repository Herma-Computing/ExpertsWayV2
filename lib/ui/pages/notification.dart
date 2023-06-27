import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:expertsway/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../db/database_helper.dart';
import '../../models/notification.dart';
import '../../theme/box_icons_icons.dart';
import '../../theme/theme.dart';
import '../../utils/notification_message.dart';
import 'package:timeago/timeago.dart' as timeago;

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _NotificationState();
}

enum _MenuValues { all, unread, read }

class _NotificationState extends State<Notification> {
  List<NotificationElement> list = [];
  late SharedPreferences sharedPreferences;
  late bool allNotifs;
  late bool readNotifs;
  bool isLoading = false;

  @override
  void initState() {
    // loadSharedPreferencesAndData();
    allNotifs = true;
    readNotifs = false;
    // addItem();
    refershNotification();

    super.initState();
  }

  void sharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // String finishedCourse = "Congratualtions, You have finished"; // 0
    // String questionReply = "has replied to your question on the forum"; // 1
    // String quiz = "You have a quiz on"; // 2
    // String newCourse = "New course has been launched"; // 3

    // sharedPreferences.setString("finishedCourse", finishedCourse);
    // sharedPreferences.setString("questionReply", questionReply);
    // sharedPreferences.setString("quiz", quiz);
    // sharedPreferences.setString("newCourse", newCourse);
  }

  Future refershNotification() async {
    setState(() => isLoading = true);
    list = await DatabaseHelper.instance.readAllNotification();
    if (list.isNotEmpty) {
      setState(() {
        allNotifs = true;
        readNotifs = false;
      });
      getNotifs();
    } else {}
    setState(() => isLoading = false);
  }

  // void loadSharedPreferencesAndData() async {
  //   // sharedPreferences = await SharedPreferences.getInstance();
  //   loadData();
  // }

  // void loadData() {
  //   // List<dynamic>? listString = sharedPreferences.getStringList('list');
  //   additems(); //fortesting
  //   if (list != null) {
  //     list = listString.map((item) => notificationFromJson(item)).toList();
  //     getNotifs();
  //   }
  // }

  onNotifDismissed(int item) async {
    await DatabaseHelper.instance.deleteNotification(item);
    // list.remove(item);
    // List<String> stringList =
    //     list.map((item) => notificationToJson(item)).toList();
    // sharedPreferences.setStringList('list', stringList);
    refershNotification();
    getNotifs();
  }

  List<NotificationElement> today = [], thisWeek = [], older = [];

  getNotifs() {
    today = [];
    thisWeek = [];
    older = [];
    var now = DateTime.now();
    var now_1d = now.subtract(const Duration(days: 1));
    var now_1w = now.subtract(const Duration(days: 7));
    for (final e in list) {
      if (allNotifs) {
        if (now_1d.isBefore(e.createdDate)) {
          today.add(e);
        } else if (now_1w.isBefore(e.createdDate)) {
          thisWeek.add(e);
        } else {
          older.add(e);
        }
      } else {
        if (readNotifs) {
          if (now_1d.isBefore(e.createdDate)) {
            today.add(e);
          } else if (now_1w.isBefore(e.createdDate)) {
            thisWeek.add(e);
          } else {
            older.add(e);
          }
        } else {
          if (now_1d.isBefore(e.createdDate)) {
            today.add(e);
          } else if (now_1w.isBefore(e.createdDate)) {
            thisWeek.add(e);
          } else {
            older.add(e);
          }
        }
      }
    }
    setState(() {});
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        backgroundColor: themeProvider.currentTheme == ThemeData.light() ? const Color.fromARGB(255, 25, 32, 36) : Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  TextButton(
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.black,
                      size: 35,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width - 330),
                    child: Text('Notifications',
                        textAlign: TextAlign.end, style: textTheme.displayMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, bottom: 20),
              child: Row(children: [
                Text.rich(TextSpan(
                    style: const TextStyle(color: Colors.redAccent), //apply style to all
                    children: [
                      const TextSpan(text: "You have ", style: TextStyle(color: Colors.grey, fontSize: 15)),
                      readNotifs
                          ? today.length + thisWeek.length + older.length > 0
                              ? TextSpan(
                                  text:
                                      // '${today.length + thisWeek.length + older.length} read ',
                                      '${list.length.toString()} read ',
                                  style: const TextStyle(color: Color.fromARGB(255, 99, 187, 249), fontWeight: FontWeight.w500, fontSize: 15))
                              : const TextSpan(text: 'no read ', style: TextStyle(color: Colors.grey, fontSize: 15))
                          : today.length + thisWeek.length + older.length > 0
                              ? TextSpan(
                                  text:
                                      // '${today.length + thisWeek.length + older.length} new ',
                                      '${list.length.toString()} new ',
                                  style: const TextStyle(color: Color.fromARGB(255, 99, 187, 249), fontWeight: FontWeight.w500, fontSize: 15))
                              : const TextSpan(text: 'no new ', style: TextStyle(color: Colors.grey, fontSize: 15)),
                      const TextSpan(text: "notifications", style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ])),
                SizedBox(width: MediaQuery.of(context).size.width * 0.34),
                PopupMenuButton<_MenuValues>(
                  initialValue: _MenuValues.all,
                  position: PopupMenuPosition.under,
                  icon: const Icon(
                    BoxIcons.bx_slider,
                    color: Color.fromARGB(255, 180, 180, 180),
                  ),
                  iconSize: 22,
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: _MenuValues.all,
                      child: Text('All'),
                    ),
                    const PopupMenuItem(
                      value: _MenuValues.unread,
                      child: Text('Unread'),
                    ),
                    const PopupMenuItem(
                      value: _MenuValues.read,
                      child: Text('Read'),
                    ),
                  ],
                  onSelected: (value) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    switch (value) {
                      case _MenuValues.all:
                        allNotifs = true;
                        readNotifs = false;
                        getNotifs();
                        break;
                      case _MenuValues.unread:
                        allNotifs = false;
                        readNotifs = false;
                        getNotifs();
                        break;
                      case _MenuValues.read:
                        allNotifs = false;
                        readNotifs = true;
                        getNotifs();
                        break;
                    }
                  },
                ),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  today.isNotEmpty
                      ? Column(
                          children: [
                            titleText("Today"),
                            buildNotif(today.length, today),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : Container(),
                  thisWeek.isNotEmpty
                      ? Column(
                          children: [
                            titleText("This week"),
                            buildNotif(thisWeek.length, thisWeek),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : Container(),
                  older.isNotEmpty
                      ? Column(
                          children: [
                            titleText("Older"),
                            buildNotif(older.length, older),
                          ],
                        )
                      : Container()
                ],
              )),
            ),
          ],
        ));
  }

  Widget buildNotif(int length, List listNotif) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              buildTile(listNotif[index]),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            height: 1,
            color: const Color.fromARGB(255, 245, 245, 245),
          );
        });
  }

  Widget titleText(String title) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 20),
      alignment: Alignment.topLeft,
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 17, fontFamily: 'Red Hat Display', fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildTile(NotificationElement item) {
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Slidable(
          endActionPane: ActionPane(motion: const DrawerMotion(), extentRatio: 0.185, children: [
            SlidableAction(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.only(left: 10),
              icon: BoxIcons.bxs_trash,
              onPressed: ((context) => onNotifDismissed(item.id!)),
            )
          ]),
          child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(children: [
                // ignore: avoid_unnecessary_containers
                Container(
                    child:
                        // item.
                        //     ? const SizedBox(
                        //         width: 7,
                        //       )
                        // :
                        const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 7, 141, 251),
                  radius: 3,
                )),
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: item.imgUrl != null
                      ? CircleAvatar(
                          radius: 19,
                          backgroundColor: maincolor,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Image.network(
                              item.imgUrl!,
                              width: 25,
                              // fit: BoxFit.contain,
                            ),
                          ),
                        )
                      : const CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage("assets/images/logo.png"),
                        ),
                ),
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.78,
                    margin: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: getContent(item.type, item.heighlightText),
                          // Text(

                          //     style: const TextStyle(
                          //         color: const Color.fromARGB(136, 31, 31, 31))),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              timeago.format(DateTime.parse(item.createdDate.toString())),
                              style: const TextStyle(color: Color.fromARGB(136, 31, 31, 31)),
                            )),
                      ],
                    ),
                  ),
                )
              ])),
        ));
  }

  void addItem() async {
    NotificationElement notElem = NotificationElement(
      heighlightText: 'Object Oriented Course',
      imgUrl: 'https://cdn.pixabay.com/photo/2014/04/03/11/08/tea-311845__340.png',
      type: 'quiz',
      createdDate: DateTime.parse("2023-03-06 18:45:45.201920"),
    );
    await DatabaseHelper.instance.createNotification(notElem);
  }

  getContent(String type, String heighlightText) {
    if (type == 'finishedCourse') {
      return RichText(
          text: TextSpan(children: [
        TextSpan(text: ' ${notifMessages[0].message}', style: const TextStyle(color: Color.fromARGB(136, 31, 31, 31))),
        TextSpan(text: ' $heighlightText', style: const TextStyle(color: maincolor, fontWeight: FontWeight.w600)),
      ]));
    }
    if (type == 'replay') {
      return RichText(
          text: TextSpan(children: [
        TextSpan(text: ' $heighlightText', style: const TextStyle(color: maincolor, fontWeight: FontWeight.w600)),
        TextSpan(text: ' ${notifMessages[1].message}', style: const TextStyle(color: Color.fromARGB(136, 31, 31, 31))),
      ]));
    }
    if (type == 'quiz') {
      return RichText(
          text: TextSpan(children: [
        TextSpan(text: ' ${notifMessages[2].message}', style: const TextStyle(color: Color.fromARGB(136, 31, 31, 31))),
        TextSpan(text: ' $heighlightText', style: const TextStyle(color: maincolor, fontWeight: FontWeight.w600)),
        const TextSpan(text: ' today', style: TextStyle(color: Color.fromARGB(136, 31, 31, 31))),
      ]));
    }
    if (type == 'newCourse') {
      return RichText(
          text: TextSpan(children: [
        TextSpan(text: ' ${notifMessages[3].message}', style: const TextStyle(color: Color.fromARGB(136, 31, 31, 31))),
        TextSpan(text: ' $heighlightText', style: const TextStyle(color: maincolor, fontWeight: FontWeight.w600)),
      ]));
    } else {
      return RichText(
          text: const TextSpan(children: [
        TextSpan(text: '', style: TextStyle(color: Color.fromARGB(136, 31, 31, 31))),
        TextSpan(text: '', style: TextStyle(color: maincolor)),
      ]));
    }
  }
}
