class  followersList {
  String username;
  String first_name;
  String last_name;
  String avator_url;



  bool is_following;

  followersList({
    required this.username,
    required this.first_name,
    required this.last_name,
    required  this.avator_url,
    required this.is_following});
    
      factory followersList.fromJson(Map<String, dynamic> json) {
    return followersList(
      username: json['username'] as String,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      is_following: json['is_following'] as bool,
      avator_url: json['avatar_url'] as String,
     
    );
  }
    Map<String, dynamic> tojson() {
    return <String, dynamic>{
      'username': username,
      'first_name': first_name,
      'last_name': last_name,
      'is_following': is_following,
      'avator_url': avator_url,
     
      
    };
  }

}