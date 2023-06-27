import 'dart:convert';

AuthModel authModelFromJson(dynamic str) => AuthModel.fromJson(str);

String authModelToJson(AuthModel data) => json.encode(data.toJson());  

class AuthModel {
    String token;
    String userEmail;
    String username;
    String userNickname;
    String userDisplayName;
    String userFirstName;
    String userLastName;
    String userImage;

    String? occupation;
    String? birthdate;
    String? country;
    List<String>? perferedLanguages;

    AuthModel({
        required this.token,
        required this.userEmail,
        required this.username,
        required this.userNickname,
        required this.userDisplayName,
        required this.userFirstName,
        required this.userLastName,
        required this.userImage,

        this.occupation,
        this.birthdate,
        this.country,
        this.perferedLanguages,
    });

    factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        token: json["token"],
        userEmail: json["user_email"],
        username: json["username"],
        userNickname: json["user_nicename"],
        userDisplayName: json["user_display_name"],
        userFirstName: json["first_name"],
        userLastName: json["last_name"],
        userImage: json["image"],

        occupation: json["occupation"],
        birthdate: json["birthdate"],
        country: json["country"],
        perferedLanguages: json["perfered_languages"] == null ? [] : List<String>.from(json["perfered_languages"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "user_email": userEmail,
        "username": username,
        "user_nicename": userNickname,
        "user_display_name": userDisplayName,
        "first_name": userFirstName,
        "last_name": userLastName,
        "image": userImage,

        "occupation": occupation,
        "birthdate": birthdate,
        "country": country,
        "perfered_languages": List<dynamic>.from(perferedLanguages!.map((x) => x)),
    };
}
