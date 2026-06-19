class BugEntry {
  final String id;
  final String title;
  final String context;
  final String solution;
  final List<String> tags;
  final String technology;
  final DateTime date;

  const BugEntry({
    required this.id,
    required this.title,
    required this.context,
    required this.solution,
    required this.tags,
    required this.technology,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'context': context,
        'solution': solution,
        'tags': tags,
        'technology': technology,
        'date': date.toIso8601String(),
      };

  factory BugEntry.fromMap(Map<dynamic, dynamic> map) => BugEntry(
        id: map['id'] as String,
        title: map['title'] as String,
        context: map['context'] as String,
        solution: map['solution'] as String,
        tags: List<String>.from(map['tags'] as List),
        technology: map['technology'] as String,
        date: DateTime.parse(map['date'] as String),
      );
}
