import 'package:expertsway/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/profile.dart';

class UserPreferences {
// set AuthToken once user login completed
  static Future<bool> setuser(
    String image,
    String username,
    String firstName,
    String lastName,
    String email,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("image", image);
    prefs.setString("username", username);
    prefs.setString("name", firstName);
    prefs.setString("last_name", lastName);

    prefs.setString("email", email);
    return true;
  }

  static Future<User> getuser(String image, String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
     String? image = prefs.getString("image");
    return User(name: name, image: image);
  }

  static Future<bool> setuserProfile(String birthdate, String occupation, String country, List<String>? languages) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("birthdate", birthdate);
    prefs.setString("occupation", occupation);
    prefs.setString("country", country);
    await LanguageOptionPreferences.setLanguage(languages);

    return true;
  }

  static Future<Profile> getUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? birthdate = prefs.getString("birthdate");
    String? occupation = prefs.getString("occupation");
    String? country = prefs.getString("country");
    return Profile(occupation: occupation, birthdate: birthdate, country: country);
  }

  static Future<void> setProfilePicture(String imageUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("image", imageUrl);
  }
}

class LanguageOptionPreferences {
  static Future<bool> setLanguage(List<String>? languages) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (languages!.isNotEmpty) {
      prefs.setStringList("languages", languages);
    }
    return true;
  }

  static Future<List<String>?> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? language = prefs.getStringList("languages");
    return language;
  }
}

class NotificationPreferences {
  static Future<bool> setNotif(String date, String message, bool read) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("date", date);
    prefs.setString("message", message);
    prefs.setBool("read", read);
    return true;
  }
}
