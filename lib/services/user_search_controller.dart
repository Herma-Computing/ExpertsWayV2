import 'package:get/get.dart';

class UserSearchController extends GetxController{
  List localUserList = [];
  List GlobalUserList = [];
List get localAllUserNames=> localUserList;
List get globalAllUserNames => GlobalUserList;




 localUser(List<Map<String, dynamic>>? localUserName){
  
  update();

}
globalUser(List<Map<String, dynamic>>? globalUserName) {
    GlobalUserList = globalUserName!;
    update();
  }
}