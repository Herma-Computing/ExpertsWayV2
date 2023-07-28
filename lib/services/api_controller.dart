import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:expertsway/models/auth_model.dart';
import 'package:expertsway/models/course.dart';
import 'package:expertsway/models/lesson.dart';
import 'package:expertsway/models/programming_language.dart';
import 'package:expertsway/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/shared_preference/shared_preference.dart';
import '../models/contributor_lesson.dart';
import '../models/other_profile_model.dart';
import '../models/profile.dart';

class ApiProvider {
  Future<Map<String, dynamic>> retrieveCourses(String? courseLastUpdate, String? plLastUpdate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    // we want to set the connection timeout to 10 seconds
    // this is long but it's done in the background so it's fine.
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    Response response = await dio.get(
      AppUrl.courseUrl,
      queryParameters: {
        'last_updated': courseLastUpdate ?? '2020-10-14 06:48:28',
        'pl_last_updated': plLastUpdate ?? '2020-10-14 06:48:28',
      },
    );
    if (response.statusCode == 200) {
      final responseBody = response.data;
      final Course course = courseFromJson(responseBody);
      // let's also extract the programming languages from the response
      var plList = responseBody['pls'].map((pl) => ProgrammingLanguage.fromMap(pl)).toList();

      return {'course': course, 'pls': plList};
    } else {
      throw Exception('Failed to load course');
    }
  }

  Future<Lesson> getMyContributions() async {
    var dio = Dio();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";

    Response response = await dio.get(
      AppUrl.myContributions,
      queryParameters: {'page_number': 1},
    );
    if (response.statusCode == 200) {
      final responseBody = response.data;
      final lesson = lessonFromJson(responseBody);
      return lesson;
    } else {
      throw Exception('Failed to get Help page');
    }
  }

  Future<Lesson> retrieveLessons(slug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastUpdate = prefs.getString("last_update_$slug") ?? '2020-10-14 06:48:28';
    var dio = Dio();
    // we want to set the connection timeout to 10 seconds
    // this is long. but it's done in the background so it's fine.
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    Response response = await dio.get(
      '${AppUrl.lessonUrl}/$slug',
      queryParameters: {'post_modified': lastUpdate},
    );
    if (response.statusCode == 200) {
      final responseBody = response.data;
      final lesson = lessonFromJson(responseBody);
      return lesson;
    } else {
      throw Exception('Failed to load lesson');
    }
  }

  Future<String> registerUser(String email, String firstname, String lastname, String password, String registerWith) async {
    String res = "Some error is occured";

    try {
      // UserAccount userAccount =
      //     UserAccount(registed_with: register_with, email: email, firstname: firstname, lastname: lastname, password: password);

      String passwordParam = "password";
      String firstNameParam = "first_name";
      String lastNameParam = "last_name";
      if (registerWith == "google") {
        passwordParam = "google_user_id";
        firstNameParam = "given_name";
        lastNameParam = "family_name";
      }
      var dio = Dio();
      Map<String, dynamic> requestBody = {
        "registed_with": registerWith,
        "email": email,
        firstNameParam: firstname,
        lastNameParam: lastname,
        passwordParam: password
      };
      Response response = await dio.post(
        AppUrl.userregisterUrl,
        data: requestBody,
      );
      if (response.statusCode == 200) {
        res = "success";
        if (registerWith == "google") {
          final AuthModel authModel = authModelFromJson(response.data);
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString("token", authModel.token);

          UserPreferences.setuser(
            authModel.userImage.toString(),
            authModel.username.toString(),
            authModel.userFirstName.toString(),
            authModel.userLastName.toString(),
            authModel.userEmail.toString(),
          );
          // profileGet();

          await UserPreferences.setuserProfile(
              authModel.birthdate.toString(), authModel.occupation.toString(), authModel.country.toString(), authModel.perferedLanguages);
        }
      } else {}
    } catch (e) {
      if (e is DioError) {
        Response response = e.response!;
        res = response.data['message'];
      }
    }

    return res;
  }

  Future<String> verification(String email, int otp) async {
    String res = "Some error is occured";
    try {
      var dio = Dio();
      Map<String, dynamic> requestBody = {"email": email, "code": otp};
      Response response = await dio.post(
        AppUrl.activateaccount,
        data: requestBody,
      );
      if (response.statusCode == 200) {
        res = "success";
      } else {
        var temp = jsonDecode(response.data.toString());
        String message = temp['message'];
        res = message;
      }
    } catch (e) {
      if (e is DioError) {
        Response response = e.response!;
        res = response.data['message'];
      } else {
        res = "Some error is occurred";
      }
    }

    return res;
  }

  Future<String> loginUser(String email, String password, String loginWith) async {
    String res = "Some error is occured";
    try {
      var dio = Dio();
      Response response = await dio.post(
        AppUrl.loginUrl,
        data: jsonEncode(<String, dynamic>{
          'username': email,
          'password': password,
          'login_with': loginWith,
        }),
      );

      if (response.statusCode == 200) {
        res = "success";
        final responseBody = response.data;
        final AuthModel authModel = authModelFromJson(responseBody);
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString("token", authModel.token);

        UserPreferences.setuser(
          authModel.userImage.toString(),
          authModel.username.toString(),
          authModel.userFirstName.toString(),
          authModel.userLastName.toString(),
          authModel.userEmail.toString(),
        );
        // profileGet();

        await UserPreferences.setuserProfile(
            authModel.birthdate.toString(), authModel.occupation.toString(), authModel.country.toString(), authModel.perferedLanguages);
      }
    } catch (e) {
      if (e is DioError) {
        Response response = e.response!;
        res = response.data['message'];
      } else {
        res = "Some error is occured";
      }
    }
    return res;
  }

  Future<String> changeProfilePicture(String filePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
    });
    try {
      Response response = await dio
          .post(
        AppUrl.changeProfilePicture,
        data: formData,
      )
          .timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException("Connection timed out");
        },
      );
      if (response.statusCode == 200) {
        // parse the response data and return the image path
        String imageUrl = response.data['message'];
        return imageUrl;
      } else {
        throw Exception("server returned non-200 response while uploading profile image");
      }
    } catch (error) {
      // we want to catch the error on the settings page code and display a snackbar to the user
      // so we are re-throwing the exception here.
      rethrow;
    }
  }

  Future<String> sendInstraction(String email) async {
    String res = "Some error is occured";
    try {
      var dio = Dio();
      Response response = await dio.post(
        AppUrl.sendInstraction,
        data: jsonEncode(<String, dynamic>{"user_login": email}),
      );

      if (response.statusCode == 200) {
        res = "success";
      }
    } catch (e) {
      if (e is DioError) {
        Response response = e.response!;
        res = response.data['message'];
      } else {
        res = "Some error is occured";
      }
    }

    return res;
  }

  Future<String> setnewpassword(String email, String newpass, int code) async {
    String res = "Some error is occured";
    try {
      var dio = Dio();
      Response response = await dio.post(
        AppUrl.setnewpassword,
        data: jsonEncode(<String, dynamic>{"email": email, "password": newpass, "code": code}),
      );
      if (response.statusCode == 200) {
        res = "success";
      }
    } catch (e) {
      if (e is DioError) {
        Response response = e.response!;
        res = response.data['message'];
      } else {
        res = "Some error is occured";
      }
    }

    return res;
  }

  Future<String> resendActivation(
    String email,
  ) async {
    String res = "Some error is occured";
    try {
      var dio = Dio();
      Response response = await dio.post(
        AppUrl.resendActivation,
        data: jsonEncode(<String, dynamic>{"email": email}),
      );
      if (response.statusCode == 200) {
        res = "success";
      }
    } catch (e) {
      if (e is DioError) {
        Response response = e.response!;
        res = response.data['message'];
      } else {
        res = "Some error is occured";
      }
    }

    return res;
  }

  Future<void> lessonCompleteUpdate(String lessonSlug) async {
    // let's read the email, password, and login_with values from shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    if (token == null) {
      throw Exception("User account information is missing from shares preferences."
          "Failed to send lesson completion update to the server.");
    }
    try {
      var dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
      var response = await dio.post(
        "${AppUrl.lessonCompleteProgressUpdate}/$lessonSlug",
        data: jsonEncode(<String, dynamic>{}),
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to send lesson completion update to the server.");
      }
    } catch (_) {
      // TODO: do the appropriate error handling here instead of just rethrowing the error.
      rethrow;
    }
  }

  Future<String> preferedLanguagesPatch(List<String> list) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
      String perferedLanguagesJson = '{"perfered_languages": [';
      String perferedLanguagesJsonEnd = ']}';
      for (var i = 0; i < list.length; i++) {
        perferedLanguagesJson = i == list.length - 1
            ? '$perferedLanguagesJson${list[i]}'
            // : perferedLanguagesJson + '"' + list[i].toString() + '"' + ",";
            : ' $perferedLanguagesJson  ' "'  ${list[i].toString()}  '" '  ","';
      }
      Response response = await dio.patch(
        AppUrl.profile,
        data: perferedLanguagesJson + perferedLanguagesJsonEnd,
      );
      return response.statusMessage.toString();
    } catch (e) {
      return 'Failed to update languages';
    }
  }

  // Future<List<String>?> preferedLanguagesGet() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var dio = Dio();
  //   dio.options.headers['content-Type'] = 'application/json';
  //   dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
  //   Response response = await dio.get(
  //     AppUrl.profile,
  //   );
  //   if (response.statusCode == 200) {
  //     final responseBody = response.data;
  //     final Profile profile = profileFromJson(responseBody);
  //     return profile.perferedLanguages;
  //   } else {
  //     throw Exception('Failed to load languages');
  //   }
  // }

  Future<Profile> profileGet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    Response response = await dio.get(
      AppUrl.profile,
    );
    if (response.statusCode == 200) {
      final responseBody = response.data;
      final Profile profile = profileFromJson(responseBody);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("name");
      prefs.remove("last_name");
      prefs.remove("birthdate");
      prefs.remove("occupation");
      prefs.remove("country");
      prefs.setString("name", profile.firstName.toString());
      prefs.setString("last_name", profile.lastName.toString());
      await UserPreferences.setuserProfile(
          profile.birthdate.toString(), profile.occupation.toString(), profile.country.toString(), profile.perferedLanguages);
      return profile;
    } else {
      throw Exception('Failed to get profile');
    }
  }

  Future<String> profilePatch(String fName, String? lName, String? birthdate, String? occupation, String? country) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    Response response = await dio.patch(
      AppUrl.profile,
      data: jsonEncode(<String, dynamic>{
        "first_name": fName,
        "last_name": lName,
        "occupation": occupation,
        "birthdate": birthdate,
        "country": country,
      }),
    );
    if (response.statusCode == 200) {
      return response.statusCode.toString();
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<String> profileDelete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    Response response = await dio.delete(
      AppUrl.profile,
    );
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("image");
      prefs.remove("username");
      prefs.remove("name");
      prefs.remove("last_name");
      prefs.remove("email");
      prefs.remove("token");
      prefs.remove("birthdate");
      prefs.remove("occupation");
      prefs.remove("country");
      prefs.remove("languages");
      return "Profile successfully deleted";
    } else {
      throw Exception('Failed to delete profile');
    }
  }

  Future<String> createContributor({required ContributeLesson contributeLesson}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 20);
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
      final json = contributeLesson.toJson();

      Map<String, dynamic> jsonData = {
        "course_slug": json['course_slug'],
        "after_lesson": json['after_lesson'],
        "lesson_title": json['lesson_title'],
        "lesson_description": json['lesson_description'],
        "lesson_content": json['lesson_content']
      };
      String jsonString = jsonEncode(jsonData);
      Response response = await dio.post(AppUrl.contributor, data: jsonString);
      if (response.statusCode == 200) {
        final message = response.data['message'];
        return message;
      } else {
        final message = response.data['message'];
        return message;
        // throw Exception('Failed to create data on the server.');
      }
    } catch (e) {
      String? message = 'Some error occured';

      if (e is DioError) {
        Response response = e.response!;

        if (e.response?.statusCode == 403) {
          // Handle 403 error
          // print('Error: ${e.response?.statusCode} - ${}');
          message = response.statusMessage;
        } else {
          // Handle other DioError cases
          // print('DioError: ${e.toString()}');
          // message = e.toString();
          message = response.data['message'];
        }
      }
      return message!;
    }
  }

  Future ClearCourseProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    try {
      Response response = await dio.post("${AppUrl.ClearCourseProgress}", data: {});

      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        print('CoureseProgressCleared: ${response.data}');
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        print("coded${response.statusCode}");
        throw Exception('Failed to create album.');
      }
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("yes"),
      onPressed: () {
        ClearCourseProgress();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text(
        "Are you sure to clear your progress?",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future fetchOtherProfileInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    try {
      Response response = await dio.get(AppUrl.fetchOtherProfileInformation);
   if(response.data != null){
     if (response.statusCode == 200) {
          return OtherProfileModels.fromJson(response.data);
        } else {
          // If the server did not return a 201 CREATED response,
          // then throw an exception.
          print("coded${response.statusCode}");
          throw Exception('Failed to create album.');
        }
   }else{
    print("something went wrong internal error");
   }
     
    } catch (e) {

      print('Error creating user: $e');
    }
  }

  Future follow() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    try {
      Response response = await dio.post(AppUrl.follow);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.

        throw Exception('Failed follow');
      }
    } catch (e) {
      print('Error to follow: $e');
    }
  }

  Future unfollow() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    try {
      Response response = await dio.post(AppUrl.unfollow);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        print("coded${response.statusCode}");
        throw Exception('Failed to unfollow.');
      }
    } catch (e) {
      print('Error to unfollow: $e');
    }
  }
}
