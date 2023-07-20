// ignore: depend_on_referenced_packages
import 'package:expertsway/models/programming_language.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expertsway/db/database_helper.dart';
import 'package:expertsway/models/course.dart';
import 'package:expertsway/services/api_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/shared_preference/shared_preference.dart';
import '../../../models/user.dart';

class LandingPageController extends GetxController {
  RxList<CourseElement> allCourses = <CourseElement>[].obs;
  RxList<CourseElement> coursesToDisplay = <CourseElement>[].obs;
  RxList<CourseElement> fundamentalCourses = <CourseElement>[].obs;
  // this is the list of prerequisite slugs whose dependent courses are currently displayed
  Set<String> displayedPrerequisites = {};

  RxList<CourseElement> startedCourses = <CourseElement>[].obs; // these are the courses the user has started learning
  RxList<CourseProgressElement> progressList = <CourseProgressElement>[].obs;


  String profileName = '';
  String _profileImage = '';

  String get profileImage => _profileImage;
  String get profileNames => profileName;

  set profileImage(String value) {   
    _profileImage = value;
    update();
  }

  final loading = false.obs;
  final fetchFail = false.obs; // this flag is used to show an error message if the api call fails and there's no cached data

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() async {
    super.onInit();
    setUpController();
  }

  Future<void> setUpController() async {
    // this function will prepare the course data to be fetched from the api, loaded
    // into the controller and displayed in the UI
    loading.value = true;
    fetchFail.value = false;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? savedCourseLastUpdateDate = pref.getString('new_lastupdate_date');
    String? savedPlLastUpdateDate = pref.getString('pl_lastupdate_date');
    getCoursesFromDatabase();
    // read courses data from the API in case there's some updates
    getCoursesFromApi(savedCourseLastUpdateDate, savedPlLastUpdateDate);
     getProfileDetails();
  }

  Future getCoursesFromApi(String? savedCourseLastUpdateDate, String? savedPlLastUpdateDate) async {
    loading.value = true;
    late final Map<String, dynamic> result;
    try {
      // the result is a map that contains a course object and a list of programming objects
      // the course object contains a list of courses in it. (it's weird, i know, but that's how the first people wrote it. It'll be fixed later)
      result = (await ApiProvider().retrieveCourses(savedCourseLastUpdateDate, savedPlLastUpdateDate));
      var resultCourse = result['course'] as Course;
      var resultPls = (result['pls'] as List).map<ProgrammingLanguage>((e) => e as ProgrammingLanguage).toList();
      // note that the api will return an empty list if there's no updates to the courses based on the date we send
      // but if the api returns a list of updated courses, we need to insert them into db or replace them if they exist.
      if (resultCourse.courses.isNotEmpty) {
        // insert the courses into local database
        for (var i = 0; i < resultCourse.courses.length; i++) {
          await DatabaseHelper.instance.upsertCourse(resultCourse.courses[i]);
        }
        // then we need to set the last updated date in shared preferences
        SharedPreferences pref = await SharedPreferences.getInstance();
        // TODO: THIS IS A TEMPORARY FIX FOR THE BACK END. 'lastUpdated' SHOULD BE NON-NULLABLE
        // TODO: TAKE THE LATEST OF THE DATES FROM ALL THE COURSES INSTEAD OF TAKING THE DATE OF THE LAST COURSE.
        var lastUpdated = resultCourse.courses.last.lastUpdated ?? DateTime.now();
        var timeString = "${lastUpdated.year}-${"${lastUpdated.month}".padLeft(2, "0")}-${"${lastUpdated.day}".padLeft(2, "0")} "
            "${"${lastUpdated.hour}".padLeft(2, "0")}:${"${lastUpdated.minute}".padLeft(2, "0")}:${"${lastUpdated.second}".padLeft(2, "0")}";
        await pref.setString('new_lastupdate_date', timeString);
        // finally, let's read the updates courses from the database
        await getCoursesFromDatabase();
      }
      if (resultPls.isNotEmpty) {
        // insert the programming languages into local database
        for (var i = 0; i < resultPls.length; i++) {
          await DatabaseHelper.instance.upsertProgrammingLanguage(resultPls[i]);
        }
        // then let's get the latest pl_last_updated date from the programming languages and
        // set it in shared preferences
        SharedPreferences pref = await SharedPreferences.getInstance();
        // let's get the latest of the last_updated_dates for programming languages
        var lastUpdateDate = DateTime.parse("1970-01-01 00:00:00"); // start of the unix epoch
        for (var i = 0; i < resultPls.length; i++) {
          if (resultPls[i].lastUpdateDate.isAfter(lastUpdateDate)) {
            lastUpdateDate = resultPls[i].lastUpdateDate;
          }
        }
        var timeString = "${lastUpdateDate.year}-${"${lastUpdateDate.month}".padLeft(2, "0")}-${"${lastUpdateDate.day}".padLeft(2, "0")} "
            "${"${lastUpdateDate.hour}".padLeft(2, "0")}:${"${lastUpdateDate.minute}".padLeft(2, "0")}:${"${lastUpdateDate.second}".padLeft(2, "0")}";
        await pref.setString('pl_lastupdate_date', timeString);
      }
    } catch (e) {
      Get.log(e.toString());
      // if the network request fails, we want to set the allCourses field to the empty list of courses from the database
      // and set loading to false. also, we want to show an error message to the user. so set fetchFail to true.
      loading.value = false;
      fetchFail.value = true;
      loading.refresh();
    }
  }

  //fetch the course from local database
  Future getCoursesFromDatabase() async {
    loading.value = true;
    var result = await DatabaseHelper.instance.readAllCourses();
    if (result.isNotEmpty) {
      allCourses.value = result;
      // we want to copy all the courses into coursesToDisplay the first time around.
      coursesToDisplay.addAll(allCourses);
      fundamentalCourses.value = await DatabaseHelper.instance.readFundamentalCourses();
      await getProgressListFromDatabase();
      updateStartedCourses();
      // we set loading to false only if we get courses from the database
      loading.value = false;
      loading.refresh();
    }
  }

  Future getProgressListFromDatabase() async {
    try {
      loading.value = true;
      progressList.value = await DatabaseHelper.instance.readAllCourseProgress();
      loading.value = false;
    } catch (e) {
      Get.log(e.toString());
    }
  }

  void addToDisplayedCourses(String prerequisiteSlug) {
    // this method takes a prerequisiteSlug and adds all courses with the given
    // prerequisite to the displayedCourses list.
    displayedPrerequisites.add(prerequisiteSlug);
    Set<CourseElement> tempSet = {};
    // let's first add all the main (parent/prerequisite) courses to be displayed
    tempSet.addAll(allCourses.where((element) => displayedPrerequisites.contains(element.slug)));
    // and let's add all the (dependent) courses with the above prerequisites
    tempSet.addAll(allCourses.where((course) => course.prerequisites!.toSet().intersection(displayedPrerequisites).isNotEmpty));
    coursesToDisplay.value = tempSet.toList();
  }

  void removeFromDisplayedCourses(String prerequisiteSlug) {
    // this method takes a prerequisiteSlug and removes all courses with the given
    // prerequisite from the displayedCourses list.
    displayedPrerequisites.remove(prerequisiteSlug);
    Set<CourseElement> tempSet = {};
    // let's first add all the main (parent/prerequisite) courses to be displayed
    tempSet.addAll(allCourses.where((element) => displayedPrerequisites.contains(element.slug)));
    // and let's add all the (dependent) courses with the above prerequisites
    tempSet.addAll(allCourses.where((course) => course.prerequisites!.toSet().intersection(displayedPrerequisites).isNotEmpty));
    coursesToDisplay.value = tempSet.toList();
  }

  void displayAllCourses() {
    // this method removes all courses from the displayedCourses list.
    displayedPrerequisites.clear();
    coursesToDisplay.clear();
    coursesToDisplay.addAll(allCourses);
  }

  void resetDisplayedCourses() {
    // whenever there's no selected chip to filter, we reset the displayed courses
    coursesToDisplay.clear();
    coursesToDisplay.addAll(allCourses);
  }

  void updateStartedCourses() {
    startedCourses.clear();
    for (var element in allCourses) {
      for (var progress in progressList) {
        if (progress.courseSlug == element.slug) {
          startedCourses.add(element);
          break;
        }
      }
    }
  }

  // get  user profile
  Future getProfileDetails() async {

    
   
  User result = await UserPreferences.getuser('image', 'name');
    profileName = result.name!;
    _profileImage =  result.image!;
    print("pro$profileName");
    print("im$_profileImage");
    update();
    
  }
}
