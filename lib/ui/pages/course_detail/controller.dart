// create a getx controller for the course_detail page
// Path: lib/ui/pages/course_detail/controller.dart
import 'package:expertsway/db/database_helper.dart';
import 'package:expertsway/models/course.dart';
import 'package:expertsway/services/api_controller.dart';
import 'package:expertsway/ui/pages/landing_page/controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/contributor_lesson.dart';
import '../../../models/lesson.dart';

class MyController extends GetxController {
  Rx<List<Lessoncontent>> lessonContents = Rx<List<Lessoncontent>>([]);
  // RxList<TextEditingController> textController = <TextEditingController>[].obs;
  RxList<dynamic> lescontFields = <dynamic>[].obs;
  var itemCount = 0.obs;
  final RxString courseSlug = ''.obs;
  RxList<String> lessonafterItems = <String>[
    'lesson list',
  ].obs;

  RxList<String> ContTypeItems = <String>['Choose content type', 'title', 'paragraph', 'image', 'code'].obs;
  RxList<String> programmingItems = <String>[
    'Java',
    'C++',
  ].obs;

  final RxString lessonAfterSelectedItem = 'lesson list'.obs;
  final RxString contTypeSelectedItems = 'Choose content type'.obs;
  final RxString programmingSelectedItems = 'Java'.obs;
  late Lessoncontent lessonContent;
  // final RxString lessonAfterSelectedItem = ''.obs;

  RxBool isaddbtntap = false.obs;

  void updateData(String newData) {
    courseSlug.value = newData;
  }

  void addFieldandController(final field, Lessoncontent lessonCont, int? index) {
      lessonContent = Lessoncontent(title: lessonCont.title, p: lessonCont.p,code: lessonCont.code);
    if (index != null) {
      lescontFields.insert(index, field);
      lessonContents.value.insert(index, lessonContent);
    } else {
      lescontFields.add(field);
      lessonContents.value.add(lessonCont);
      // textController.add(controller);
    }
    itemCount.value = lescontFields.length;
  }

  // void updateField(TextEditingController controller, int? index) {
  //   if (index != null) {
  //     textController.replaceRange(index, index + 1, [controller]);
  //   } else {
  //     textController.replaceRange(index!, index + 1, [controller]);
  //   }
  // }

  void removeFieldandController(int index) {
    lessonContents.value.removeAt(index);
    lescontFields.removeAt(index);
    itemCount.value = lescontFields.length;
  }


}

class CourseDetailController extends GetxController {
  late final CourseElement courseData; // i want to initialize this variable before doing anything else
  late RxList<List> lessonData = <List>[]
      .obs; // this will contain lists of two elements: the first element is the lessonElement, the second element is a boolean that tells us if the lesson is completed or not
  Rx<CourseProgressElement?> courseProgress = Rx<CourseProgressElement?>(null);
  final loading = false.obs;
  final fetchFail = false.obs; // this flag is used to show an error message if the api call fails and there's no cached data

  // a constructor that takes the course data as a parameter
  CourseDetailController({required this.courseData});

  @override
  void onInit() async {
    super.onInit();
    setUpController();
  }

  void setUpController() {
    /// this function will prepare the lesson data to be fetched from the api, loaded
    /// into the controller and displayed in the UI
    loading.value = true;
    fetchFail.value = false;
    // read lesson data from the the database to display in the UI
    getLessonsFromDatabase();
    // read lesson data form the api in case there's any updates
    // if there's any updates,
    getLessonsFromApi();
  }

  Future getLessonsFromApi() async {
    try {
      final Lesson result = await ApiProvider().retrieveLessons(courseData.slug);
      // note that the api will return an empty list if there's no updates to the lessons based on the date we send
      // but if the api returns a list of updated lessons, we need to replace the lessons in the database with the new ones
      if (result.lessons.isNotEmpty) {
        // let's write the lessons to database
        for (var i = 0; i < result.lessons.length; i++) {
          await DatabaseHelper.instance.upsertLesson(result.lessons[i]!);
        }
        // let's set the last lesson update for this course in the shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // first let's get the lesson with the latest postModified date
        var lastModified = DateTime.parse("1970-01-01 00:00:00"); // start of the unix epoch
        for (var i = 0; i < result.lessons.length; i++) {
          //TODO: this is a temporary fix for the api
          if (result.lessons[i]?.postModified == null) {
            continue; // if the postModified is null, let's skip this lesson (this is a temporary fix for the api)
          }
          if (result.lessons[i]!.postModified!.isAfter(lastModified)) {
            lastModified = result.lessons[i]!.postModified!;
          }
        }
        // now let's set the last update in the shared preferences
        var timeString = "${lastModified.year}-${"${lastModified.month}".padLeft(2, "0")}-${"${lastModified.day}".padLeft(2, "0")} "
            "${"${lastModified.hour}".padLeft(2, "0")}:${"${lastModified.minute}".padLeft(2, "0")}:${"${lastModified.second}".padLeft(2, "0")}";
        await prefs.setString("last_update_${courseData.slug}", timeString);

        // since we have updated data, let's read the lessons from the database again
        // this time the data read from the catabase can't be empty. so we set loading to false there.
        await getLessonsFromDatabase();
      }
    } catch (e) {
      Get.log(e.toString());
      // if the network request fails, we want to set the lessons field to the empty list of lessons from the database
      // and set loading to false. Remember that the UI displays "No course" if loading is false and lessons is empty.
      // TODO: we need to display a message to the user that the network request failed
      loading.value = false;
      fetchFail.value = true;
      loading.refresh();
    }
  }

  Future getLessonsFromDatabase() async {
    // let's read the lessons from the database
    final lessons = await DatabaseHelper.instance.readLessonsOfACourse(courseData.slug);
    // if lessons is empty, let's retry fetching the lessons from the api
    if (lessons.isNotEmpty) {
      // we set loading to false only if we have lessons in the database or the
      // requiest fails.
      await setUpProgress(lessons);
      loading.value = false;
      loading.refresh();
    }
  }

  Future setUpProgress(List<LessonElement> lessons) async {
    // let's read the course progress from the database
    final progress = await DatabaseHelper.instance.readCourseProgress(courseData.slug);
    // let's set the course progress
    courseProgress.value = progress;
    if (courseProgress.value == null) {
      // if the course progress is null, let's create a new one
      // set the lesson number of the course progress equal to the index of the first lesson with lessonCompleted = false
      int lessonNumber = 0;
      for (var i = 0; i < lessons.length; i++) {
        lessonNumber++;
        if (!lessons[i].lessonCompleted) {
          break;
        }
      }
      CourseProgressElement newCourseProgress = CourseProgressElement(
        courseSlug: courseData.slug,
        lessonNumber: lessonNumber,
        percentage: lessonNumber / lessons.length,
      );
      // write the course progress to the database
      await DatabaseHelper.instance.createCourseProgressElement(newCourseProgress);
      courseProgress.value = newCourseProgress;
    }

    // let's populate the lessonData list
    for (var i = 0; i < lessons.length; i++) {
      lessonData.add([lessons[i], false]);
    }
    //let's apply the progress to the lessonData (this means that if the user has completed lesson 1, then lessonData[1][1] will be true)
    applyProgressOnLessons();
  }

  applyProgressOnLessons() {
    // here we're applying it on the lessons if it exists
    // (applying it on lessons means setting some locked and some unlocked based on the progress)
    if (courseProgress.value != null) {
      for (int i = 0; i < courseProgress.value!.lessonNumber; i++) {
        lessonData[i][1] = true;
      }
    }
  }

  // this method will return a list of sections. each lesson will be under a section
  List<String> sectionList(List<List> lessonData) {
    var seen = <String>[];
    for (var element in lessonData) {
      seen.add(element[0].section as String);
    }
    final sectionList = seen.toSet().toList();
    return sectionList;
  }

  // this method will return a list of lessons under a section
  List<List> lessonList(List<List> lessonData, String section) {
    var seen = <List>[];
    for (int i = 0; i < lessonData.length; i++) {
      var element = lessonData[i];
      if (element[0].section == section) {
        seen.add(element);
      }
    }
    return seen;
  }

  // this method updates the courseProgress associated with the widget.courseData in the LandingPageController's progressList.
  void updateProgressOnLandingPage() {
    LandingPageController landingPageController = Get.find();
    landingPageController.progressList.removeWhere((element) => element.courseSlug == courseData.slug);
    landingPageController.progressList.add(courseProgress.value!);
    landingPageController.updateStartedCourses();
  }

  void setLessonAsCompleteAndUnlockNext(LessonElement lesson) async {
    // let's find the next lesson
    List? nextLessonEntry;
    for (int i = 0; i < lessonData.length - 1; i++) {
      if (lessonData[i][0].lessonId == lesson.lessonId) {
        nextLessonEntry = lessonData[i + 1];
        break;
      }
    }
    // if the next lesson is already unlocked, let's return
    // this happens when a user opens a lesson that's already complete and finishes it again
    // so we don't need to do anything in that case.
    if (nextLessonEntry == null || nextLessonEntry[1] == true) {
      return;
    }
    // set the lesson as complete
    lesson.lessonCompleted = true;
    // let's update the lesson as completed in the database
    DatabaseHelper.instance.shallowUpdateLesson(lesson);
    // let's update the course progress here and in the database
    CourseProgressElement newCourseProgress = courseProgress.value!.copy(
      newLessonNumber: courseProgress.value!.lessonNumber + 1,
      newPercentage: (courseProgress.value!.lessonNumber + 1) / lessonData.length,
    );
    await DatabaseHelper.instance.updateCourseProgress(newCourseProgress);
    courseProgress.value = newCourseProgress;
    // let's update the course progress in the landing page controller
    updateProgressOnLandingPage();
    // let's set the lesson as complete on the api
    try {
      ApiProvider().lessonCompleteUpdate(lesson.slug);
    } catch (e) {
      Get.log(e.toString());
    }
    // let's lock and unlock the lessons based on the new progress
    applyProgressOnLessons();
    lessonData.refresh();
  }
}
