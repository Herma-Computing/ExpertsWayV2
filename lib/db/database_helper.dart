import 'package:expertsway/models/programming_language.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expertsway/utils/color.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import 'package:get/get.dart';
import '../models/notification.dart';

const String courseElement = 'coursesElement';
const String tablesections = 'sections';
const String lessontable = 'lessons';
const String lessonContnentTable = 'lessonsContent';
const String progress = 'progress';
const String courseProgress = 'courseProgress';
const String notification = 'notification';
const String bookmark = 'bookmark';
const String programmingLanguages = 'programmingLanguages';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.init();

  static Database? _database;
  DatabaseHelper.init();
  Future<Database> get database async {
    // if it's exist return database
    if (_database != null) return _database!;
    // other wise inisialize a database
    _database = await _initDB('course.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // get the default database location
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    // const idTextType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const fkCourse = 'FOREIGN KEY (${LessonsElementFields.courseSlug}) REFERENCES $courseElement(${CourseElementFields.slug})';
    const fkLesson = 'FOREIGN KEY (${LessonsContentFields.lessonId}) REFERENCES $lessontable(${LessonsElementFields.lesson_id})';

    const textTypeNull = 'TEXT';
    const boolType = 'BOOLEAN NOT NULL';
    // const dateType = 'DATE';
    const intType = 'INTEGER NOT NULL';
    const intTypeNull = 'INTEGER';
    const realType = 'REAL NOT NULL';
    if (kDebugMode) {
      print("...createing table.....");
    }
    // CREATEING TABLES

// COURSE TABLE
    await db.execute('''
CREATE TABLE $courseElement (
      ${CourseElementFields.name} $textTypeNull,
      ${CourseElementFields.slug} $textTypeNull NOT NULL PRIMARY KEY,
      ${CourseElementFields.description} $textTypeNull,
      ${CourseElementFields.color} $textTypeNull,
      ${CourseElementFields.level} $textTypeNull,
      ${CourseElementFields.minutesToFinish} $intTypeNull,
      ${CourseElementFields.rate} $textTypeNull,
      ${CourseElementFields.icon} $textTypeNull,
      ${CourseElementFields.banner} $textTypeNull,
      ${CourseElementFields.shortVideo} $textTypeNull,
      ${CourseElementFields.lastUpdated} $textTypeNull,
      ${CourseElementFields.eneabled} $boolType,
      ${CourseElementFields.seenCounter} $intTypeNull,
      ${CourseElementFields.isLastSeen} $intTypeNull,
      ${CourseElementFields.isCertificateAvailable} $boolType,
      ${CourseElementFields.isCompleted} $boolType
       )
    ''');

    // create the prerequisites join table
    // we have a many to many relationship between instances of the same type: courseElement
    await db.execute('''
      CREATE TABLE Prerequisites (
        course_slug $textType,
        prerequisite_slug $textType,
        PRIMARY KEY (course_slug, prerequisite_slug),
        FOREIGN KEY (course_slug) REFERENCES $courseElement(${CourseElementFields.slug}),
        FOREIGN KEY (prerequisite_slug) REFERENCES $courseElement(${CourseElementFields.slug})
      );
''');

// LESSON TABLE
    await db.execute('''
CREATE TABLE $lessontable (
      ${LessonsElementFields.lesson_id} $intType PRIMARY KEY,
      ${LessonsElementFields.slug} $textType,
      ${LessonsElementFields.title} $textType,
      ${LessonsElementFields.shortDescription} $textType,
      ${LessonsElementFields.section} $textType,
      ${LessonsElementFields.courseSlug} $textType,
      ${LessonsElementFields.publishedDate} $textType,
      ${LessonsElementFields.lessonCompleted} $boolType,
      ${LessonsElementFields.isQuizAvailable} $boolType,
      ${LessonsElementFields.isCompetitionAvailable} $boolType,
      $fkCourse
    )
    ''');

// LESSON CONTENT TABLE
    await db.execute('''
CREATE TABLE $lessonContnentTable (
      ${LessonsContentFields.id} $idType,
      ${LessonsContentFields.lessonId} $textTypeNull,
      ${LessonsContentFields.content} $textType,
      $fkLesson
    )
    ''');

// PROGRESS TABLE
    await db.execute('''
CREATE TABLE $progress (
      ${ProgressFields.progId} $idType,
      ${ProgressFields.courseSlug} $textTypeNull,
      ${ProgressFields.lessonId} $textTypeNull,
      ${ProgressFields.contentId} $textTypeNull,
      ${ProgressFields.pageNum} $intTypeNull,
      ${ProgressFields.userProgress} $textTypeNull
    )
    ''');

// COURSE PROGRESS TABLE
    await db.execute('''
CREATE TABLE $courseProgress (
      ${CourseProgressFields.progId} $idType,
      ${CourseProgressFields.courseSlug} $textTypeNull,
      ${CourseProgressFields.lessonNumber} $intType,
      ${CourseProgressFields.percentage} $realType
    )
    ''');

// NOTIFICATION TABLE
    await db.execute('''
CREATE TABLE $notification (
      ${NotificationFields.id} $idType,
      ${NotificationFields.heighlightText} $textTypeNull,
      ${NotificationFields.type} $textTypeNull,
      ${NotificationFields.imgUrl} $textTypeNull,
      ${NotificationFields.createdDate} $textTypeNull
    )
    ''');

    // PROGRAMMING LANGUAGE TABLE
    await db.execute('''
CREATE TABLE $programmingLanguages (
      ${ProgrammingLanguageFields.slug} TEXT PRIMARY KEY,
      ${ProgrammingLanguageFields.name} $textType,
      ${ProgrammingLanguageFields.lastUpdateDate} $textType
    )
    ''');
  }

  Future<void> upsertCourse(CourseElement courseElem) async {
    final db = await instance.database;
    // final id = await db.insert(courseElement, courseElem.toJson());
    await db.insert(
      courseElement,
      courseElem.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // let's delete all the prerequisites of this course and re-insert them in case they changed
    // we can't update them because they don't have a unique identifier synced with the server.
    await db.delete("prerequisites", where: "course_slug = ?", whereArgs: [courseElem.slug]);

    for (var prerequisite in courseElem.prerequisites ?? []) {
      // save the prerequisite relationships for this course in the prerequisites table
      await db.insert("prerequisites", {'course_slug': courseElem.slug, 'prerequisite_slug': prerequisite});
    }
  }

  Future deleteAllCourses() async {
    final db = await instance.database;
    await db.delete(courseElement);
  }

  Future<void> upsertLesson(LessonElement lessonElement) async {
    /// this method inserts a lesson into db or replaces it if it already exists (upon unique constraint failures with the lesson_id)
    /// it also inserts the lesson contents into the lesson content table
    /// this method assumes the lessonId is unique and it doesn't change when the lesson is updated on the server
    final db = await instance.database;
    try {
      final json = lessonElement.toJson();
      const columns =
          '${LessonsElementFields.lesson_id},${LessonsElementFields.slug},${LessonsElementFields.title},${LessonsElementFields.shortDescription},${LessonsElementFields.section},${LessonsElementFields.courseSlug},${LessonsElementFields.publishedDate},${LessonsElementFields.lessonCompleted},${LessonsElementFields.isQuizAvailable},${LessonsElementFields.isCompetitionAvailable}';

      await db.rawInsert(
        'INSERT OR REPLACE INTO $lessontable ($columns) VALUES (?,?,?,?,?,?,?,?,?,?)',
        [
          json[LessonsElementFields.lesson_id].toString(),
          json[LessonsElementFields.slug],
          json[LessonsElementFields.title],
          json[LessonsElementFields.shortDescription],
          json[LessonsElementFields.section],
          json[LessonsElementFields.courseSlug],
          json[LessonsElementFields.publishedDate],
          json[LessonsElementFields.lessonCompleted],
          json[LessonsElementFields.isQuizAvailable],
          json[LessonsElementFields.isCompetitionAvailable],
        ],
      );

      // we need to delete the lesson contents for this lesson and re-insert them
      // updating them is not possible because they don't have a unique identifier.
      await db.delete(
        lessonContnentTable,
        where: '${LessonsContentFields.lessonId} = ?',
        whereArgs: [json[LessonsElementFields.lesson_id].toString()],
      );

      for (var i = 0; i < lessonElement.content.length; i++) {
        DatabaseHelper.instance.createLessonsContent(lessonElement.content[i], json[LessonsElementFields.lesson_id].toString());
      }
    } catch (e) {
      // TODO: handle this error better
      rethrow;
    }
  }

  Future<int> shallowUpdateLesson(LessonElement lesson) async {
    /// this method updates the lesson shallowly (without updating the contents)
    final db = await instance.database;
    var rows = await db.update(
      lessontable,
      lesson.toJson(),
      where: '${LessonsElementFields.lesson_id}= ?',
      whereArgs: [lesson.lessonId],
    );
    return rows;
  }

  Future deleteLessonsOfACourse(String courseSlug) async {
    final db = await instance.database;
    await db.delete(lessontable, where: '${LessonsElementFields.courseSlug} = ?', whereArgs: [courseSlug]);
  }

  Future<void> createLessonsContent(List<Map> content, String lessonid) async {
    final db = await instance.database;
    LessonContent lescon = LessonContent(lessonId: lessonid, content: content);
    final id = await db.insert(lessonContnentTable, lescon.toJson());
    lescon.copy(id: id);
  }

  Future<ProgressElement> createProgress(ProgressElement progressElement) async {
    final db = await instance.database;
    final json = progressElement.tojson();
    const columns =
        '${ProgressFields.progId},${ProgressFields.courseSlug},${ProgressFields.lessonId},${ProgressFields.contentId},${ProgressFields.pageNum},${ProgressFields.userProgress}';

    // final id = await db.insert(progress, progressElement.tojson());
    int id = await db.rawInsert(
      'INSERT INTO $progress ($columns) VALUES (?,?,?,?,?,?)',
      [
        json[ProgressFields.progId],
        json[ProgressFields.courseSlug],
        json[ProgressFields.lessonId],
        json[ProgressFields.contentId],
        json[ProgressFields.pageNum],
        json[ProgressFields.userProgress],
      ],
    );
    return progressElement.copy(progId: id);
  }

  Future<CourseProgressElement> createCourseProgressElement(CourseProgressElement courseProgressElement) async {
    final db = await instance.database;
    final json = courseProgressElement.toJson();
    const columns =
        '${CourseProgressFields.progId},${CourseProgressFields.courseSlug},${CourseProgressFields.lessonNumber},${CourseProgressFields.percentage}';
    int id = await db.rawInsert(
      'INSERT INTO $courseProgress ($columns) VALUES (?,?,?,?)',
      [
        json[CourseProgressFields.progId],
        json[CourseProgressFields.courseSlug],
        json[CourseProgressFields.lessonNumber],
        json[CourseProgressFields.percentage],
      ],
    );
    return courseProgressElement.copy(newProgId: id);
  }

  Future<void> createNotification(NotificationElement notificationElement) async {
    final db = await instance.database;
    try {
      final id = await db.insert(notification, notificationElement.tojson());

      notificationElement.copy(id: id);
    } on DatabaseException catch (error) {
      Get.snackbar("", "",
          borderWidth: 2,
          borderColor: maincolor,
          dismissDirection: DismissDirection.horizontal,
          duration: const Duration(seconds: 4),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.885),
          titleText: const Text(
            'Error',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          messageText: Text(
            '$error',
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          ),
          margin: const EdgeInsets.only(top: 12));
    } catch (e) {
      Get.snackbar("", "",
          borderWidth: 2,
          borderColor: maincolor,
          dismissDirection: DismissDirection.horizontal,
          duration: const Duration(seconds: 4),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.885),
          titleText: const Text(
            'Error',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          messageText: Text(
            '$e',
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          ),
          margin: const EdgeInsets.only(top: 12));
    }
  }

  Future<List<String>> getPrerequisitesForCourseElement(String courseElementSlug) async {
    final db = await instance.database;
    // every time we read a courseElement from db, we also need to read it's prerequisites and set it up
    final prerequisiteData = await db.query(
      "prerequisites",
      columns: ["prerequisite_slug"],
      where: 'course_slug = ?',
      whereArgs: [courseElementSlug],
    );
    return prerequisiteData.map<String>((e) => e['prerequisite_slug'].toString()).toList();
  }

  Future<CourseElement> readCourseBySlug(String courseSlug) async {
    final db = await instance.database;

    final maps = await db.query(
      courseElement,
      columns: CourseElementFields.values,
      where: '${CourseElementFields.slug} = ?',
      whereArgs: [courseSlug],
    );
    if (maps.isNotEmpty) {
      var courseElement = CourseElement.fromJson(maps.first);
      courseElement.prerequisites = await getPrerequisitesForCourseElement(courseElement.slug);
      return courseElement;
    } else {
      throw Exception('Course with slug: $courseSlug not found');
    }
  }

  Future<List<LessonElement>> readLessonsOfACourse(String courseSlug) async {
    final db = await instance.database;
    final result = await db.query(
      lessontable,
      columns: LessonsElementFields.values,
      where: '${LessonsElementFields.courseSlug} = ?',
      whereArgs: [courseSlug],
    );
    return result.map((json) => LessonElement.fromJson(json)).toList();
  }

  Future<LessonElement> readLessonById(int lessonId) async {
    final db = await instance.database;
    final result = await db.query(
      lessontable,
      columns: LessonsElementFields.values,
      where: '${LessonsElementFields.lesson_id} = ?',
      whereArgs: [lessonId],
    );
    if (result.isNotEmpty) {
      return LessonElement.fromJson(result.first);
    } else {
      throw Exception('A lesson with id: $lessonId not found');
    }
  }

  Future<List<CourseElement>> readFundamentalCourses() async {
    final db = await instance.database;
    const orderby = '${CourseElementFields.lastUpdated} DESC';
    final result = await db.query(
      courseElement,
      orderBy: orderby,
      where: '${CourseElementFields.level} = ?',
      whereArgs: ['fundamental'],
    );
    var courses = result.map((json) => CourseElement.fromJson(json)).toList();
    for (var course in courses) {
      course.prerequisites = await getPrerequisitesForCourseElement(course.slug);
    }
    return courses;
  }

  Future<List<CourseElement>> readAllCourses() async {
    final db = await instance.database;
    const orderby = '${CourseElementFields.lastUpdated} DESC';
    final result = await db.query(
      courseElement,
      orderBy: orderby,
    );
    var courses = result.map((json) => CourseElement.fromJson(json)).toList();
    for (var course in courses) {
      course.prerequisites = await getPrerequisitesForCourseElement(course.slug);
    }
    return courses;
  }

  Future<List<LessonContent>> readLessonContets({required int lessonId}) async {
    final db = await instance.database;
    final result = await db.query(
      lessonContnentTable,
      columns: LessonsContentFields.lessonsvalue,
      where: '${LessonsContentFields.lessonId} = ?',
      whereArgs: [lessonId],
    );
    if (result.isNotEmpty) {
      return result.map((json) => LessonContent.fromJson(json)).toList();
    }
    if (result.isEmpty) {
      return [];
    } else {
      return [];
    }
  }

  Future<List<LessonContent>> readAllLessonContent() async {
    final db = await instance.database;

    final result = await db.query(lessonContnentTable);

    return result.map((json) => LessonContent.fromJson(json)).toList();
  }

  Future<ProgressElement?> readProgress(String courseSlug, String lessonId) async {
    final db = await instance.database;
    final maps = await db.query(
      progress,
      columns: ProgressFields.progressvalue,
      where: '${ProgressFields.courseSlug} = ? and ${ProgressFields.lessonId} = ? ',
      whereArgs: [courseSlug, lessonId],
    );
    if (maps.isNotEmpty) {
      return ProgressElement.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<CourseProgressElement>> readAllCourseProgress() async {
    final db = await instance.database;
    final maps = await db.query(courseProgress);
    return maps.map((e) => CourseProgressElement.fromMap(e)).toList();
  }

  Future<CourseProgressElement?> readCourseProgress(String courseSlug) async {
    final db = await instance.database;
    final maps = await db.query(
      courseProgress,
      columns: CourseProgressFields.fieldValues,
      where: '${CourseProgressFields.courseSlug} = ?',
      whereArgs: [courseSlug],
    );
    if (maps.isNotEmpty) {
      return CourseProgressElement.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<NotificationElement>> readAllNotification() async {
    final db = await instance.database;

    final result = await db.query(notification);

    return result.map((json) => NotificationElement.fromJson(json)).toList();
  }

// UPDATE DATA'
  Future updateProgress(ProgressElement progressElement) async {
    final db = await instance.database;
    await db.update(
      progress,
      progressElement.tojson(),
      where: '${ProgressFields.courseSlug}= ? and ${ProgressFields.lessonId}= ?',
      whereArgs: [
        progressElement.courseSlug,
        progressElement.lessonId,
      ],
    );
  }

// UPDATE DATA'
  Future<int?> updateCourseProgress(CourseProgressElement courseProgressElement) async {
    final db = await instance.database;
    int id = await db.update(
      courseProgress,
      courseProgressElement.toJson(),
      where: '${CourseProgressFields.progId}= ?',
      whereArgs: [
        courseProgressElement.progId,
      ],
    );
    return id;
  }

// DELETE DATA
  Future<int> deleteNotification(int id) async {
    final db = await instance.database;

    return await db.delete(
      notification,
      where: '${NotificationFields.id}=?',
      whereArgs: [id],
    );
  }

  Future<void> upsertProgrammingLanguage(ProgrammingLanguage programmingLanguage) async {
    final db = await instance.database;
    await db.insert(
      programmingLanguages,
      programmingLanguage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProgrammingLanguage>> readAllProgrammingLanguages() async {
    final db = await instance.database;
    var result = await db.query(programmingLanguages);
    var pls = result.map((e) => ProgrammingLanguage.fromMap(e)).toList();
    return pls;
  }

// close DATABASE
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
