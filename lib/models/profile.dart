import 'dart:convert';

Profile profileFromJson(dynamic str) => Profile.fromJson(str);

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    this.firstName,
    this.lastName,
    this.occupation,
    this.birthdate,
    this.country,
    this.perferedLanguages,
  });

  String? firstName;
  String? lastName;
  String? occupation;
  String? birthdate;
  String? country;
  List<String>? perferedLanguages;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        firstName: json["first_name"],
        lastName: json["last_name"],
        occupation: json["occupation"],
        birthdate: json["birthdate"],
        country: json["country"],
        perferedLanguages: json["perfered_languages"] == null ? [] : List<String>.from(json["perfered_languages"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "occupation": occupation,
        "birthdate": birthdate,
        "country": country,
        "perfered_languages": List<dynamic>.from(perferedLanguages!.map((x) => x)),
      };
}
