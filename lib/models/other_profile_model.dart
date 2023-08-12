import 'followers_model.dart';
import 'following_models.dart';

class OtherProfileModels {
  String first_name;
  String last_name;
  bool  is_following;
  String avatar_url;
  String occupation;
  String birthdate;
  List perfered_languages;
  String country;
  List followers;
  List followings;
  OtherProfileModels({
    required this.first_name,
    required this.last_name,
    required bool this.is_following,
    required this.avatar_url,
    required this.occupation,
    required this.birthdate,
    required this.perfered_languages,
    required this.country,
    required this.followers,
    required this.followings,
  });
  factory OtherProfileModels.fromJson(Map<String, dynamic> json) {

    return OtherProfileModels(
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      is_following: json['is_following'] as bool,
      avatar_url: json['avatar_url'] as String,
      occupation: json['occupation'] as String,
      birthdate: json['birthdate'] as String,
      perfered_languages: json['perfered_languages'],
      country: json['country'] as String,
      followers: json['followers']==null?[]: json['followers'].map((content) => followersList.fromJson(content)).toList(),
      followings: json['followings']==null?[]:json['followings'].map((content) => FollowingList.fromJson(content)).toList(),
    );
  }
  Map<String, dynamic> tojson() {
    return <String, dynamic>{
      'first_name': first_name,
      'last_name': last_name,
      'is_following': is_following,
      'avatar_url': avatar_url,
      'occupation': occupation,
      'birthdate': birthdate,
      'perfered_languages': perfered_languages,
      'country': country,
    };
  }
}
