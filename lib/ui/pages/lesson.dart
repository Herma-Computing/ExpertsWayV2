// ignore_for_file: unused_element, unused_local_variable, use_build_context_synchronously

import 'dart:math' show Random;
import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expertsway/api/shared_preference/shared_preference.dart';
import 'package:expertsway/models/lesson.dart';
import 'package:expertsway/models/user.dart';
import 'package:expertsway/ui/pages/course_detail/controller.dart';
import 'package:expertsway/ui/pages/course_detail/course_detail.dart';
import 'package:expertsway/ui/widgets/lesson_content_display.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expertsway/utils/color.dart';
import 'package:expertsway/utils/lesson_finish_message.dart';
import 'package:provider/provider.dart';
import '../../db/database_helper.dart';
import '../../models/course.dart';
import '../../models/notification.dart';

import '../../theme/theme.dart';

class LessonPage extends StatefulWidget {
  final List<List> lessonData;
  final List<LessonContent?> contents;
  // final String section;
  // final String lesson;
  // final String lessonId;
  final LessonElement lesson;
  final CourseElement courseData;
  const LessonPage({
    super.key,
    // required this.section, //
    // required this.lesson,  // this is the title
    required this.lesson,
    required this.lessonData,
    required this.contents,
    // required this.lessonId, //
    required this.courseData,
  });

  @override
  State<LessonPage> createState() => _LessonState();
}

class _LessonState extends State<LessonPage> {
  static ProgressElement? progressElement;
  static CourseElement? courseElement;
  bool _isLessonFinished = false;
  bool isLoading = false;
  CourseDetailController courseDetailController = Get.find();

  @override
  void initState() {
    super.initState();
    init();
    getLeContents();
    getContentsId();
    getCourseNameandIcon();
    refreshProgress();

  }

  Future<void> getCourseNameandIcon() async {
    courseElement = await DatabaseHelper.instance.readCourseBySlug(widget.courseData.slug);
  }

  Future addNotification() async {
    await getCourseNameandIcon();

    NotificationElement notElem = NotificationElement(
      heighlightText: courseElement!.name,
      imgUrl: courseElement!.icon,
      type: 'finishedCourse',
      createdDate: DateTime.now(),
    );
    await DatabaseHelper.instance.createNotification(notElem);
  }

  static int getPageNum() {
    int val = progressElement!.pageNum;
    return val;
  }

  Future<void> addOrupdateProgress() async {
    if (progressElement != null) {
      await updateProgress();
    } else {
      await addProgress();
    }
  }

  Future addProgress() async {
    var newProgressElement = ProgressElement(
        progId: null,
        courseSlug: widget.courseData.slug,
        lessonId: widget.lesson.lessonId.toString(),
        contentId: getContentID[index].toString(),
        pageNum: index,
        userProgress: getUserProgress().toString());
    progressElement = await DatabaseHelper.instance.createProgress(newProgressElement);
    var courseDetailController = Get.find<CourseDetailController>();
    // let's refresh the course_detail page to update the lesson progresses displayed
    courseDetailController.loading.refresh();
  }

  Future updateProgress() async {
    final progress = progressElement!.copy(
      contentId: getContentID[index].toString(),
      pageNum: index,
      userProgress: getUserProgress().toString(),
    );
    await DatabaseHelper.instance.updateProgress(progress);
  }

  Future refreshProgress() async {
    setState(() => isLoading = true);
    // getContentID[index].toString()
    progressElement = await DatabaseHelper.instance.readProgress(
      widget.courseData.slug,
      widget.lesson.lessonId.toString(),
    );
    if (progressElement != null) {
      setState(() {
        index = progressElement!.pageNum;
        if (index == getContent.length - 1) {
          _isLessonFinished = true;
        }
      });
    } else {
      // since there's no progress found on the database, let's make one
      addProgress();
      setState(() {
        index = 0;
        if (getContent.length == 1) {
          _isLessonFinished = true;
        }
      });
    }
    setState(() => isLoading = false);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    progressElement = null;
    getContent.clear();
    getContentID.clear();
  }

  int index = 0;
  final List<List<Map>> getContent = [];
  final getContentID = [];
  final getContentLessonId = [];

  getLeContents() {
    for (var i = 0; i < widget.contents.length; i++) {
      var val = widget.contents[i];
      getContent.add(val!.content);
    }
  }

  getContentsId() {
    for (var val in widget.contents) {
      getContentID.add(val!.id);
    }
  }

  Future init() async {
    User user = await UserPreferences.getuser('image', 'name');
    String? name = user.name;
    this.name = name;
  }

  lessonFinished() {
    Random random = Random();
    int randomNo1 = random.nextInt(greeting.length);
    int randomNo2 = random.nextInt(completed.length);
    int randomNo3 = random.nextInt(encouragement.length);

    String message, greet;
    if (greeting[randomNo1].startsWith("Congratulations") || greeting[randomNo2].startsWith("You did it") || greeting[randomNo3].startsWith("Wow")) {
      greet = "${greeting[randomNo1]} $name!";
    } else {
      greet = "${greeting[randomNo1]} $name";
    }

    if (encouragement[randomNo3].endsWith(".") || encouragement[randomNo3].endsWith("!")) {
      message = "${completed[randomNo2]}${widget.lesson} in ${widget.lesson.section}. ${encouragement[randomNo3]}";
    } else {
      message =
          "${completed[randomNo2]}${widget.lesson} in ${widget.lesson.section}. ${encouragement[randomNo3]} $nextLessonTitle in the next chapter.";
    }
    List<String> encouragementMessage = [greet, message];
    return encouragementMessage;
  }

  nextLesson(lessonData, lesson, section) {
    bool lessonFound = false;
    for (var element in lessonData) {
      if (lessonFound) {
        nextLessonTitle = element[0].title;
        break;
      }
      if (element[0].title == lesson && element[0].section == section) {
        lessonFound = true;
      }
    }
  }

  lessonContent(lessonData, lesson, section) {
    for (var element in lessonData) {
      if (element.title == lesson && element.section == section) {
        final lessonHtml = element.content;
        return lessonHtml;
      }
    }
    return null;
  }

  bool finishLesson = false;
  String nextLessonTitle = "";
  bool showFlushbar = true;
  String? name;

  @override
  Widget build(BuildContext context) {
    // We don't need lessonHtml any more: becouse we use getContent (which is data retrive from database)

    // final lessonHtml =
    //     lessonContent(widget.lessonData, widget.lesson, widget.section);
    nextLesson(widget.lessonData, widget.lesson, widget.lesson.section);
    // String lesson = lessonHtml[index];
    List<Map> data = getContent[index];
    final themeProvider = Provider.of<ThemeProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_isLessonFinished);
        return Future.value(true); // this is required for the page to pop.
      },
      child: Scaffold(
        backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildCoverImage(),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Material(
                        child: LessonContentDisplay(data: data),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          side: MaterialStateBorderSide.resolveWith((states) {
                            if (states.contains(MaterialState.disabled)) {
                              return const BorderSide(color: Color.fromARGB(64, 38, 176, 255));
                            }
                            return const BorderSide(color: Colors.blue);
                          }),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: index <= 0
                            ? null
                            : () {
                                setState(() {
                                  index--;
                                });
                              },
                        child: Text(
                          "Prev",
                          style: TextStyle(color: index == 0 ? const Color.fromARGB(64, 38, 176, 255) : Colors.blue, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: buildProgressBar(),
                        )),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color.fromARGB(255, 32, 130, 209), Color.fromARGB(255, 79, 170, 255)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              if (index < getContent.length - 1) {
                                nextButtonHandler();
                              } else if (widget.lesson.isQuizAvailable) {
                                _isLessonFinished = true;
                                launchTest();
                              } else {
                                _isLessonFinished = true;
                                Navigator.of(context).pop(_isLessonFinished);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Center(
                                child: Builder(builder: (context) {
                                  String text;
                                  if (index < getContent.length - 1) {
                                    text = "Next";
                                  } else if (widget.lesson.isQuizAvailable) {
                                    text = "Take test";
                                  } else {
                                    text = "Finish";
                                  }
                                  return Text(
                                    text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProgressBar() {
    // index and widget.contents.length
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: (index + 1) / widget.contents.length),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              backgroundColor: Colors.blue[100],
              color: Colors.blue[600],
              value: value,
              minHeight: 8,
            ),
          );
        },
      ),
    );
  }

  void nextButtonHandler() async {
    // showFlushbar && index == lessonHtml.length - 1
    if (showFlushbar && index == getContent.length - 1) {
      await addNotification();
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
        titleSize: 20,
        messageSize: 17,
        backgroundColor: maincolor,
        borderRadius: BorderRadius.circular(8),
        title: lessonFinished()[0].toString(),
        message: lessonFinished()[1].toString(),
        duration: const Duration(seconds: 5),
      ).show(context);
    } else {
      Container();
    }
    index < getContent.length - 1
        ? setState(() {
            index++;
          })
        : setState(() {
            finishLesson = true;
            showFlushbar = false;
          });
    if (index == getContent.length - 1) {
      _isLessonFinished = true;
    }
    if (index < getContent.length) {
      await addOrupdateProgress();
      refreshProgress();
    }
    courseDetailController.lessonData.refresh();
  }

  void launchTest() {
    // TODO: implement this method
  }

  Widget buildCoverImage() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // this mehtod builds the cover image and the texts
    // on it (displayed at the top of the course-detail screen)
    return Stack(
      // we use this stack to display the course name and chapters on top of the cover image.
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CachedNetworkImage(
            imageUrl: widget.courseData.banner,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => const SizedBox(height: 50),
          ),
        ),
        Positioned(
          bottom: 5,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.lesson.title,
                      // TODO: consider color contrast issues here.
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      color: Colors.white,
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.comment_outlined,
                        color: Colors.blue,
                        size: 20,
                      ),
                      onPressed: () => Get.bottomSheet(
                        const CourseDetailPage(),
                        isScrollControlled: true,
                      ),
                    ),
                    const SizedBox(width: 5),
                    PopupMenuButton(
                      color: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.zero,
                      onSelected: (value) {},
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.bug_report,
                              color: Colors.blue,
                            ),
                            title: Text(
                              'Report Issue',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: themeProvider.currentTheme == ThemeData.light() ? const Color.fromARGB(255, 25, 32, 36) : Colors.white),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.group,
                              color: Colors.blue,
                            ),
                            title: Text(
                              'Collaborate',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: themeProvider.currentTheme == ThemeData.light() ? const Color.fromARGB(255, 25, 32, 36) : Colors.white),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed('/editLesson');
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            title: Text(
                              'Edit Lesson',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: themeProvider.currentTheme == ThemeData.light() ? const Color.fromARGB(255, 25, 32, 36) : Colors.white),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed('/profile');
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            title: Text(
                              'Profile',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: themeProvider.currentTheme == ThemeData.light() ? const Color.fromARGB(255, 25, 32, 36) : Colors.white),
                            ),
                          ),
                        ),
                      ],
                      child: Container(
                        width: 42,
                        height: 42,
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: SizedBox(
            // height: 40,
            // width: 40,
            child: Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              height: 22,
              width: 22,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
              child: IconButton(
                padding: const EdgeInsets.only(left: 0),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.blue),
                iconSize: 14,
                constraints: const BoxConstraints(maxHeight: 60, maxWidth: 60),
                onPressed: () => Navigator.pop(context, _isLessonFinished),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double getUserProgress() {
    double status = ((index + 1) * 100) / (getContent.length);
    return status;
  }
}
