class ProgrammingLanguageFields {
  static const String name = "name";
  static const String slug = "slug";
  static const String lastUpdateDate = "last_updated";
}

class ProgrammingLanguage {
  final String name;
  final String slug;
  final DateTime lastUpdateDate;

  ProgrammingLanguage({
    required this.name,
    required this.slug,
    required this.lastUpdateDate,
  });

  static ProgrammingLanguage fromMap(Map<String, dynamic> map) {
    return ProgrammingLanguage(
      name: map['name'],
      slug: map['slug'],
      lastUpdateDate: DateTime.parse(map['last_updated']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'slug': slug,
      'last_updated': lastUpdateDate.toIso8601String(),
    };
  }

  ProgrammingLanguage copy({String? name, String? slug, DateTime? lastUpdateDate}) {
    return ProgrammingLanguage(
      name: name ?? this.name,
      slug: slug ?? this.slug,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
    );
  }
}
