import 'package:flutter/material.dart';

class FollowUnfollow{
  String  code;
  String message;
  FollowUnfollow({required this.code,required this.message});

  factory  FollowUnfollow.fromJson(Map<String, dynamic>json)=>
     FollowUnfollow(
      code: json['code'] ?? '',
        message: json['message'] ?? '',
    );
  

}