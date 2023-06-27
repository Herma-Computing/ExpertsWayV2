import 'package:flutter/material.dart';

class ContributeLesson {
  final String courseSlug;
  final String afterLesson;
  final String lessonTitle;
  final String lessonDescription;
  final List<Lessoncontent> lessonContent;

  ContributeLesson({
    required this.courseSlug,
    required this.afterLesson,
    required this.lessonTitle,
    required this.lessonDescription,
    required this.lessonContent,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_slug': courseSlug,
      'after_lesson': afterLesson,
      'lesson_title': lessonTitle,
      'lesson_description': lessonDescription,
      'lesson_content': lessonContent.map((content) => content.toJson()).toList(),
    };
  }
}

class Lessoncontent {
  final TextEditingController? title;
  final TextEditingController? p;
  final TextEditingController? code;

  Lessoncontent({
    this.title,
    this.p,
    this.code,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic>? data = {};
    if (title != null) {
      data['title'] = title!.text;
    }
    if (p != null) {
      data['p'] = p!.text;
    }
    if (code != null) {
      data['code'] = code!.text;
    }

    return data;
  }
}
