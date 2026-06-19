class LogEntry {
  final String id;
  final DateTime date;
  final String content;
  final List<String> tags;

  const LogEntry({
    required this.id,
    required this.date,
    required this.content,
    required this.tags,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'content': content,
        'tags': tags,
      };

  factory LogEntry.fromMap(Map<dynamic, dynamic> map) => LogEntry(
        id: map['id'] as String,
        date: DateTime.parse(map['date'] as String),
        content: map['content'] as String,
        tags: List<String>.from(map['tags'] as List),
      );
}
