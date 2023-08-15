class FollowingList {
  String username;
  String firstName;
  String lastName;
  String avatorUrl;

  bool isFollowing;

  FollowingList({required this.username, required this.firstName, required this.lastName, required this.avatorUrl, required this.isFollowing});

  factory FollowingList.fromJson(Map<String, dynamic> json) {
    return FollowingList(
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      isFollowing: json['is_following'] as bool,
      avatorUrl: json['avatar_url'] as String,
    );
  }
  Map<String, dynamic> tojson() {
    return <String, dynamic>{
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'is_following': avatorUrl,
      'avator_url': avatorUrl,
    };
  }
}
