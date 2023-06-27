// ignore_for_file: constant_identifier_names

import 'dart:convert';

Lesson lessonFromJson(dynamic str) {
  return Lesson.fromJson(str);
}

String lessonToJson(Lesson data) => json.encode(data.toJson());

class Lesson {
  int code;
  List<LessonElement?> lessons;

  Lesson({required this.code, required this.lessons});

  factory Lesson.fromJson(Map<String, dynamic> jsonData) => Lesson(
        code: jsonData["code"],
        lessons: jsonData["lessons"] == null ? [] : List<LessonElement?>.from(jsonData["lessons"]!.map((x) => LessonElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        // ignore: unnecessary_null_comparison
        "lessons": lessons == null ? [] : List<dynamic>.from(lessons.map((x) => x!.toJson())),
      };
}

/// ****************** */
class LessonsElementFields {
  static final List<String> values = [
    lesson_id,
    slug,
    title,
    shortDescription,
    section,
    courseSlug,
    publishedDate,
    lessonCompleted,
    isQuizAvailable,
    isCompetitionAvailable,
  ];

  static const String lesson_id = 'lesson_id';
  static const String slug = 'slug';
  static const String title = 'title';
  static const String shortDescription = 'short_description';
  static const String section = 'section';
  static const String courseSlug = 'course_slug';
  static const String publishedDate = 'published_date';
  static const String lessonCompleted = 'lesson_completed';
  static const String isQuizAvailable = 'is_quiz_available';
  static const String isCompetitionAvailable = "is_competition_available";
}

class LessonElement {
  int lessonId;
  String slug;
  String title;
  String shortDescription;
  String section;
  String courseSlug;
  List<List<Map>> content;
  String? commentStatus;
  String? commentCount;
  DateTime? postModified;
  DateTime? publishedDate;
  bool lessonCompleted;
  bool isQuizAvailable;
  bool isCompetitionAvailable;

  LessonElement(
      {required this.lessonId,
      required this.slug,
      required this.title,
      required this.shortDescription,
      required this.section,
      required this.courseSlug,
      required this.content,
      required this.isQuizAvailable,
      required this.isCompetitionAvailable,
      this.commentStatus,
      this.commentCount,
      this.postModified,
      this.publishedDate,
      required this.lessonCompleted});

  LessonElement copy({
    int? lessonId,
    String? slug,
    String? title,
    String? shortDescription,
    String? section,
    String? courseSlug,
    List<List<Map>>? content,
    DateTime? publishedDate,
    bool? lessonCompleted,
    bool? isQuizAvailable,
    bool? isCompetitionAvailable,
  }) =>
      LessonElement(
        lessonId: lessonId ?? this.lessonId,
        slug: slug ?? this.slug,
        title: title ?? this.title,
        shortDescription: shortDescription ?? this.shortDescription,
        section: section ?? this.section,
        courseSlug: courseSlug ?? this.courseSlug,
        content: content ?? this.content,
        publishedDate: publishedDate ?? this.publishedDate,
        lessonCompleted: lessonCompleted ?? this.lessonCompleted,
        isQuizAvailable: isQuizAvailable ?? this.isQuizAvailable,
        isCompetitionAvailable: isCompetitionAvailable ?? this.isCompetitionAvailable,
      );

  factory LessonElement.fromJson(Map<String, dynamic> jsonData) {
    List<List<Map<String, dynamic>>> contents = jsonData['content'] == null
        ? []
        : (jsonData['content'] as List).map((outerList) {
            return (outerList as List).map((innerMap) {
              return Map<String, dynamic>.from(innerMap);
            }).toList();
          }).toList();
    return LessonElement(
      lessonId: jsonData[LessonsElementFields.lesson_id] as int,
      slug: jsonData[LessonsElementFields.slug] as String? ?? '',
      title: jsonData[LessonsElementFields.title] as String? ?? '',
      shortDescription: jsonData[LessonsElementFields.shortDescription] as String? ?? '',
      section: jsonData[LessonsElementFields.section] as String? ?? '',
      courseSlug: jsonData[LessonsElementFields.courseSlug] as String? ?? '',
      content: contents,
      commentStatus: jsonData['comment_status'] as String? ?? '',
      commentCount: jsonData['comment_count'] as String? ?? '',
      postModified: jsonData['post_modified'] == null ? null : DateTime.parse(jsonData['post_modified'] as String),
      publishedDate:
          jsonData[LessonsElementFields.publishedDate] == null ? null : DateTime.parse(jsonData[LessonsElementFields.publishedDate] as String),
      // we're using the same model to parse data both from the API and the local database. but sqlite doesn't have boolean types.
      // it stores booleans as 0 and 1 (while the API sends true or false json) thus we need the below condition to parse data correctly from the two sources.
      lessonCompleted: jsonData[LessonsElementFields.lessonCompleted] == true || jsonData[LessonsElementFields.lessonCompleted] == 1 ? true : false,
      isQuizAvailable: jsonData[LessonsElementFields.isQuizAvailable] == true || jsonData[LessonsElementFields.isQuizAvailable] == 1 ? true : false,
      isCompetitionAvailable:
          jsonData[LessonsElementFields.isCompetitionAvailable] == true || jsonData[LessonsElementFields.isCompetitionAvailable] == 1 ? true : false,
    );
  }

  Map<String, Object?> toJson() => {
        LessonsElementFields.lesson_id: lessonId,
        LessonsElementFields.slug: slug,
        LessonsElementFields.title: title,
        LessonsElementFields.shortDescription: shortDescription,
        LessonsElementFields.section: section,
        LessonsElementFields.courseSlug: courseSlug,
        LessonsElementFields.lessonCompleted: lessonCompleted ? 1 : 0,
        LessonsElementFields.publishedDate: publishedDate!.toIso8601String(),
        LessonsElementFields.isQuizAvailable: isQuizAvailable ? 1 : 0,
        LessonsElementFields.isCompetitionAvailable: isCompetitionAvailable ? 1 : 0,
      };
}

/// ****************** */
class LessonsContentFields {
  static List<String> lessonsvalue = [
    id,
    lessonId,
    content,
  ];
  static const String id = '_id';
  static const String lessonId = 'lessonId';
  static const String content = 'content';
}

class LessonContent {
  final int? id;
  final String lessonId;
  final List<Map> content;
  LessonContent({
    this.id,
    required this.lessonId,
    required this.content,
  });

  LessonContent copy({
    int? id,
    String? lessonId,
    List<Map>? content,
  }) =>
      LessonContent(id: id ?? this.id, lessonId: lessonId ?? this.lessonId, content: content ?? this.content);

  factory LessonContent.fromJson(Map<String, dynamic> jsonData) => LessonContent(
        id: jsonData[LessonsContentFields.id] as int,
        lessonId: jsonData[LessonsContentFields.lessonId] as String,
        content: (json.decode(jsonData[LessonsContentFields.content]) as List).map((innerMap) => Map<dynamic, dynamic>.from(innerMap)).toList(),
      );

  Map<String, dynamic> toJson() => {
        LessonsContentFields.id: id,
        LessonsContentFields.lessonId: lessonId,
        LessonsContentFields.content: json.encode(content),
      };
}

class ProgressFields {
  static List<String> progressvalue = [
    progId,
    courseSlug,
    lessonId,
    contentId,
    pageNum,
    userProgress,
  ];
  static const String progId = '_id';
  static const String courseSlug = 'courseSlug';
  static const String lessonId = 'lessonId';
  static const String contentId = 'contentId';
  static const String pageNum = 'pageNum';
  static const String userProgress = 'userProgress';
}

class ProgressElement {
  final int? progId;
  final String courseSlug;
  final String lessonId;
  final String contentId;
  final int pageNum;
  final String userProgress;

  ProgressElement({
    this.progId,
    required this.courseSlug,
    required this.lessonId,
    required this.contentId,
    required this.pageNum,
    required this.userProgress,
  });

  ProgressElement copy({
    final int? progId,
    final String? lessonId,
    final String? contentId,
    final int? pageNum,
    final String? userProgress,
  }) =>
      ProgressElement(
          progId: progId ?? this.progId,
          courseSlug: courseSlug,
          lessonId: lessonId ?? this.lessonId,
          contentId: contentId ?? this.contentId,
          pageNum: pageNum ?? this.pageNum,
          userProgress: userProgress ?? this.userProgress);

  factory ProgressElement.fromJson(Map<String, dynamic> json) => ProgressElement(
        progId: json[ProgressFields.progId] as int?,
        courseSlug: json[ProgressFields.courseSlug] as String? ?? '',
        lessonId: json[ProgressFields.lessonId] as String? ?? '',
        contentId: json[ProgressFields.contentId] as String? ?? '',
        pageNum: json[ProgressFields.pageNum] as int? ?? 0,
        userProgress: json[ProgressFields.userProgress] as String? ?? '',
      );

  Map<String, dynamic> tojson() => {
        ProgressFields.progId: progId,
        ProgressFields.courseSlug: courseSlug,
        ProgressFields.lessonId: lessonId,
        ProgressFields.contentId: contentId,
        ProgressFields.pageNum: pageNum,
        ProgressFields.userProgress: userProgress,
      };
}
