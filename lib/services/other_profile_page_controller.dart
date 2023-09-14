import 'package:get/get.dart';

import '../../models/lesson.dart';




class otherProfilePageController extends GetxController {
    late Lesson lesson;
    bool isloading = true;

  Lesson get Lessons => lesson;
  bool get isloadings => isloading;
  getLeson(Lesson lessons){
lesson=lessons;
update();
  }
getisloading(bool isloadings){
isloading=isloadings;
update();
  }


}