// ignore_for_file: constant_identifier_names

import 'dart:convert';

Course courseFromJson(dynamic str) => Course.fromJson(str);

String courseToJson(Course data) => json.encode(data.toJson());

class CourseFilds {
  static final List<dynamic> values = [
    // add all fileds
    code,
  ];
  static const String code = 'code';
}

class Course {
  Course({
    required this.code,
    required this.courses,
  });

  Course copy({
    int? code,
    List<CourseElement>? courses,
  }) =>
      Course(
        code: code ?? this.code,
        courses: courses ?? this.courses,
      );

  int code;
  List<CourseElement> courses;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        code: json["code"],
        courses: List<CourseElement>.from(json["courses"].map((x) => CourseElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
      };
}

class CourseElementFields {
  static final List<String> values = [
    // add all fileds
    name, slug, description, color, level, minutesToFinish, rate, icon, banner, shortVideo,
    lastUpdated, eneabled, isCompleted, isCertificateAvailable,
  ];
  static const String name = 'name';
  static const String slug = 'slug';
  static const String description = 'description';
  static const String color = 'color';
  static const String level = 'level';
  static const String minutesToFinish = 'minutes_to_finish';
  static const String rate = 'rate';
  static const String icon = 'icon';
  static const String banner = 'banner';
  static const String shortVideo = 'short_video';
  static const String lastUpdated = 'last_updated';
  static const String eneabled = 'enabled';
  static const String isLastSeen = 'is_last_seen';
  static const String seenCounter = 'seen_counter';
  static const String prerequisites = 'prerequisites';
  static const String isCompleted = 'is_completed';
  static const String isCertificateAvailable = 'is_certificate_available';
}

class CourseElement {
  CourseElement({
    required this.name,
    required this.slug,
    required this.description,
    required this.color,
    required this.level,
    required this.minutesToFinish,
    required this.rate,
    required this.icon,
    required this.banner,
    required this.shortVideo,
    required this.isCompleted,
    required this.isCertificateAvailable,
    this.lastUpdated,
    required this.enabled,
    this.seenCounter,
    this.isLastSeen,
    this.prerequisites,
  });

  CourseElement copy({
    String? name,
    String? slug,
    String? description,
    String? color,
    String? level,
    int? minutesToFinish,
    String? rate,
    String? icon,
    String? banner,
    String? shortVideo,
    DateTime? lastUpdated,
    bool? enabled,
    int? isLastSeen,
    int? seenCounter,
    List<String>? prerequisites,
    bool? isCompleted,
    bool? isCertificateAvailable,
  }) =>
      CourseElement(
        name: name ?? this.name,
        slug: slug ?? this.slug,
        description: description ?? this.description,
        color: color ?? this.color,
        level: level ?? this.level,
        minutesToFinish: minutesToFinish ?? this.minutesToFinish,
        rate: rate ?? this.rate,
        icon: icon ?? this.icon,
        banner: banner ?? this.banner,
        shortVideo: shortVideo ?? this.shortVideo,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        enabled: enabled ?? this.enabled,
        isLastSeen: isLastSeen ?? this.isLastSeen,
        seenCounter: seenCounter ?? this.seenCounter,
        prerequisites: prerequisites ?? this.prerequisites,
        isCompleted: isCompleted ?? this.isCompleted,
        isCertificateAvailable: isCertificateAvailable ?? this.isCertificateAvailable,
      );

  String name;
  String slug;
  String description;
  String color;
  String level;
  int minutesToFinish;
  String rate;
  String icon;
  String banner;
  String shortVideo;
  DateTime? lastUpdated;
  bool enabled;
  int? seenCounter;
  int? isLastSeen;
  List<String>? prerequisites;
  bool isCompleted;
  bool isCertificateAvailable;

  factory CourseElement.fromJson(Map<String, dynamic> jsonData) => CourseElement(
        name: jsonData[CourseElementFields.name] ?? '',
        slug: jsonData[CourseElementFields.slug] ?? '',
        description: jsonData[CourseElementFields.description] ?? '',
        color: jsonData[CourseElementFields.color] ?? '',
        level: jsonData[CourseElementFields.level] ?? '',
        minutesToFinish: jsonData[CourseElementFields.minutesToFinish] as int,
        rate: jsonData[CourseElementFields.rate] ?? '',
        icon: jsonData[CourseElementFields.icon] ?? '',
        banner: jsonData[CourseElementFields.banner] ?? '',
        shortVideo: jsonData[CourseElementFields.shortVideo] ?? '',
        lastUpdated: jsonData[CourseElementFields.lastUpdated] == null ? null : DateTime.parse(jsonData[CourseElementFields.lastUpdated]),
        enabled: jsonData[CourseElementFields.eneabled] == 1,
        isLastSeen: jsonData[CourseElementFields.isLastSeen] as int?,
        seenCounter: jsonData[CourseElementFields.seenCounter] as int?,
        prerequisites: jsonData[CourseElementFields.prerequisites]?.map<String>((e) => (e['course'] as String))?.toList(),
        // we're using the same model to parse data both from the API and the local database. but sqlite doesn't have boolean types.
        // it stores booleans as 0 and 1 (while the API sends true or false json) thus we need the below condition to parse data correctly from the two sources.
        isCompleted: jsonData[CourseElementFields.isCompleted] == true || jsonData[CourseElementFields.isCompleted] == 1 ? true : false,
        isCertificateAvailable:
            jsonData[CourseElementFields.isCertificateAvailable] == true || jsonData[CourseElementFields.isCertificateAvailable] == 1 ? true : false,
      );

  Map<String, Object?> toJson() => {
        CourseElementFields.name: name,
        CourseElementFields.slug: slug,
        CourseElementFields.description: description,
        CourseElementFields.color: color,
        CourseElementFields.level: level,
        CourseElementFields.minutesToFinish: minutesToFinish,
        CourseElementFields.rate: rate,
        CourseElementFields.icon: icon,
        CourseElementFields.banner: banner,
        CourseElementFields.shortVideo: shortVideo,
        CourseElementFields.lastUpdated: lastUpdated!.toIso8601String(),
        CourseElementFields.eneabled: enabled ? 1 : 0,
        CourseElementFields.isLastSeen: isLastSeen,
        CourseElementFields.seenCounter: seenCounter,
        CourseElementFields.isCompleted: isCompleted,
        CourseElementFields.isCertificateAvailable: isCertificateAvailable,
      };
}

class CourseProgressFields {
  static List<String> fieldValues = [
    progId,
    courseSlug,
    lessonNumber,
    percentage,
  ];
  static const String progId = '_id';
  static const String courseSlug = 'courseSlug';
  static const String lessonNumber = 'lessonNumber';
  static const String percentage = 'percentage';
}

class CourseProgressElement {
  final int? progId;
  final String courseSlug;
  final int lessonNumber;
  final double percentage;

  CourseProgressElement({this.progId, required this.courseSlug, required this.lessonNumber, required this.percentage});

  CourseProgressElement.fromMap(Map<String, dynamic> map)
      : progId = map[CourseProgressFields.progId] as int?,
        courseSlug = map[CourseProgressFields.courseSlug],
        lessonNumber = map[CourseProgressFields.lessonNumber],
        percentage = map[CourseProgressFields.percentage];

  Map<String, dynamic> toJson() {
    return {
      CourseProgressFields.progId: progId,
      CourseProgressFields.courseSlug: courseSlug,
      CourseProgressFields.lessonNumber: lessonNumber,
      CourseProgressFields.percentage: percentage,
    };
  }

  CourseProgressElement copy({
    int? newProgId,
    String? newCourseSlug,
    int? newLessonNumber,
    double? newPercentage,
  }) {
    return CourseProgressElement(
      progId: newProgId ?? progId,
      courseSlug: newCourseSlug ?? courseSlug,
      lessonNumber: newLessonNumber ?? lessonNumber,
      percentage: newPercentage ?? percentage,
    );
  }
}
