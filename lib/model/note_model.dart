class NotesImpNames {
  static const String id = 'ID';
  static const String uniqueId = 'UNIQUEID';
  static const String pin = 'PIN';
  static const String title = 'TITLE';
  static const String content = 'CONTENT';
  static const String isArchive = 'ISARCHIVED';
  static const String createdTime = 'CREATEDTIME';
  static const String tableName = 'NOTES';

  static final List<String> values = [
    id,
    isArchive,
    pin,
    title,
    content,
    createdTime,
  ];
}

class Note {
  final int? id;
  final String uniqueId;
  final bool pin;
  final bool isArchive;
  final String title;
  final String content;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.uniqueId,
    required this.pin,
    required this.isArchive,
    required this.title,
    required this.content,
    required this.createdTime,
  });

  Note copy({
    int? id,
    String? uniqueId,
    bool? pin,
    bool? isArchive,
    String? title,
    String? content,
    DateTime? createdTime,
  }) {
    return Note(
      id: id ?? this.id,
      uniqueId: uniqueId ?? this.uniqueId,
      pin: pin ?? this.pin,
      isArchive: isArchive ?? this.isArchive,
      title: title ?? this.title,
      content: content ?? this.content,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  static Note fromJson(Map<String, Object?> json) {
    return Note(
      id: json[NotesImpNames.id] as int?,
      uniqueId: json[NotesImpNames.uniqueId] as String,
      pin: json[NotesImpNames.pin] == 1,
      isArchive: json[NotesImpNames.isArchive] == 1,
      title: json[NotesImpNames.title] as String,
      content: json[NotesImpNames.content] as String,
      createdTime: DateTime.parse(
        json[NotesImpNames.createdTime] as String,
      ),
    );
  }

  Map<String, Object?> toJson() {
    return {
      NotesImpNames.id: id,
      NotesImpNames.uniqueId: uniqueId,
      NotesImpNames.pin: pin ? 1 : 0,
      NotesImpNames.isArchive: isArchive ? 1 : 0,
      NotesImpNames.title: title,
      NotesImpNames.content: content,
      NotesImpNames.createdTime: createdTime.toIso8601String(),
    };
  }
}

//  ID integer primary key autoincrement,
//  PIN boolean not null,
//  TITLE text not null,
//  CONTENT text not null,
//  CREATEDTIME text not null
