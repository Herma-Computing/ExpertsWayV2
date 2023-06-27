import 'package:cached_network_image/cached_network_image.dart';
import 'package:expertsway/routes/routing_constants.dart';
import 'package:expertsway/ui/pages/course_detail/controller.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:expertsway/ui/pages/lesson.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile_null_safety.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';

import '../../../db/database_helper.dart' hide courseProgress;
import '../../../models/lesson.dart';
import '../../../utils/color.dart';

class CourseDetailPage extends GetView<CourseDetailController> {
  const CourseDetailPage({
    Key? key,
  }) : super(key: key);

  Widget buildCoverImage(BuildContext context) {
    // this method builds the cover image and the texts on it (displayed at the top of the course-detail screen)
    return Stack(
      // we use this stack to display the course name and chapters on top of the cover image.
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CachedNetworkImage(
            imageUrl: controller.courseData.banner,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.courseData.name,
                    // TODO: consider color contrast issues here.
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  // controller.loading.value
                  //     ? Container()
                  //     : Text(
                  //         // we're considering the lessons to be the "chapters"
                  //         "${controller.lessonData.length} Chapters",
                  //       ),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: SizedBox(
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height + 60,
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  children: <Widget>[
                    buildCoverImage(context),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 4),
                          Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Description",
                                  style: textTheme.displayLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                controller.loading.value
                                    ? Container()
                                    : Text(
                                        // we're considering the lessons to be the "chapters"
                                        "${controller.lessonData.length} Chapters",
                                      ),
                                PopupMenuButton(
                                  color: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.zero,
                                  onSelected: (value) {},
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: ListTile(
                                        onTap: () {
                                          String slug = controller.courseData.slug;
                                          final MyController myController = Get.put(MyController());
                                          myController.courseSlug.value = slug;
                                          Navigator.pop(context);
                                          Get.toNamed(AppRoute.editLesson);
                                          // Get.toNamed(AppRoute.termsAndConditions);
                                          // Get.toNamed(AppRoute.contentSubmitted);
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        title: Text(
                                          'Contribute Lesson',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: themeProvider.currentTheme == ThemeData.light()
                                                  ? const Color.fromARGB(255, 25, 32, 36)
                                                  : Colors.white),
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
                          Container(
                            margin: const EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Html(
                              data: controller.courseData.description,
                              style: {
                                "body": Style(
                                  fontSize: const FontSize(14),
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.justify,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.lessonData.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Select chapter",
                              style: textTheme.displayLarge?.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Builder(builder: (context) {
                        if (controller.loading.value) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: maincolor,
                          ));
                        } else {
                          if (controller.lessonData.isEmpty && controller.fetchFail.value) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 50),
                                const Text("Something went wrong", style: TextStyle(fontSize: 22)),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () {
                                    controller.setUpController();
                                  },
                                  child: const Text(
                                    "Retry",
                                    style: TextStyle(color: maincolor),
                                  ),
                                ),
                              ],
                            );
                          }
                          if (controller.lessonData.isEmpty) {
                            return Center(
                              child: Text("There is no Course", style: textTheme.displayLarge?.copyWith(fontSize: 15, fontWeight: FontWeight.w400)),
                            );
                          }
                          return buildLessonGroups(context);
                        }
                        // buildUniformLessonList();
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildLessonGroups(BuildContext context) {
    var sections = controller.sectionList(controller.lessonData);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        for (int i = 0; i < sections.length; i++)
          Builder(builder: (context) {
            var lessonsUnderSection = controller.lessonList(controller.lessonData, sections[i]);
            return ConfigurableExpansionTile(
              header: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                        title: Text(
                          sections[i],
                          style: textTheme.displayLarge?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        color: Colors.grey[300],
                        width: MediaQuery.of(context).size.width - 36,
                        height: 1,
                      )
                    ],
                  ),
                ),
              ),
              headerExpanded: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                        title: Text(
                          sections[i],
                          style: textTheme.displayLarge?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width - 36,
                        height: 4,
                      )
                    ],
                  ),
                ),
              ),
              childrenBody: Column(
                children: [
                  for (int j = 0; j < lessonsUnderSection.length; j++)
                    GestureDetector(
                      onTap: (lessonsUnderSection[j][1]) // only the very first lesson will be unlocked
                          ? () async {
                              var lessonContents = await DatabaseHelper.instance.readLessonContets(lessonId: lessonsUnderSection[j][0].lessonId);
                              var isLessonFinished = await Get.to(
                                () => LessonPage(
                                  lessonData: controller.lessonData,
                                  lesson: lessonsUnderSection[j][0],
                                  contents: lessonContents,
                                  courseData: controller.courseData,
                                ),
                              );
                              if (isLessonFinished) {
                                controller.setLessonAsCompleteAndUnlockNext(lessonsUnderSection[j][0]);
                              }
                            }
                          : null,
                      child: ListTile(
                        title: Text(
                          lessonsUnderSection[j][0].title,
                          style: textTheme.displayLarge?.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          lessonsUnderSection[j][0].shortDescription,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.headlineSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        trailing: (lessonsUnderSection[j][1])
                            ? SizedBox(
                                width: 40,
                                child: FutureBuilder<ProgressElement?>(
                                  future: DatabaseHelper.instance.readProgress(
                                    controller.courseData.slug,
                                    lessonsUnderSection[j][0].lessonId.toString(),
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        throw Exception("Error reading progress from the database");
                                      }
                                      return CircularPercentIndicator(
                                        radius: 20,
                                        lineWidth: 3,
                                        percent: double.parse(snapshot.data?.userProgress ?? "0") / 100,
                                        progressColor: Colors.blue,
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              )
                            : CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.blue[50],
                                child: const Icon(
                                  Icons.lock_outline,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                              ),
                      ),
                    ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
