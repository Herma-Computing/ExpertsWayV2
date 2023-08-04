import 'package:dio/dio.dart';
import 'package:expertsway/models/other_profile_model.dart';
import 'package:expertsway/utils/constants.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FollowUnfollowController extends GetxController {
  late bool isFollowing=true;
  bool followers=true;
  late  String userName;

  bool get isfollowOrunfollow => isFollowing;
  bool get getfollowers => followers;
   String  get userNames => userName;
  Future<OtherProfileModels> IsFollow(String username) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    late OtherProfileModels datas;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    try {
      var response = await dio.get("${AppUrl.fetchOtherProfileInformation}/$username");
     
      if (response.data != null) {
        if (response.statusCode == 200) {
          datas = OtherProfileModels.fromJson(response.data);
          isFollowing = datas.is_following;
          update();
          
        } else {
          throw Exception('Failed to create album.');
        }
      } else {
        print("something went wrong internal error");
      }
    } catch (e) {
      print('Error creating user: $e');
    }
    return datas;
  }
  seeFollowers(){
    followers=true;
    update();
  }
  seeFollowing(){
    followers=false;
    update();
  }


  
Future getUserNmae() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
   userName=await prefs.getString("username")??"";
   update();
  }
}
