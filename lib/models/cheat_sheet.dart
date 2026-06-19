class CheatSheet {
  final String id;
  final String title;
  final String technology;
  final List<String> tags;
  final String content;
  final bool isFavorite;

  const CheatSheet({
    required this.id,
    required this.title,
    required this.technology,
    required this.tags,
    required this.content,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'technology': technology,
        'tags': tags,
        'content': content,
        'isFavorite': isFavorite,
      };

  factory CheatSheet.fromMap(Map<dynamic, dynamic> map) => CheatSheet(
        id: map['id'] as String,
        title: map['title'] as String,
        technology: map['technology'] as String,
        tags: List<String>.from(map['tags'] as List),
        content: map['content'] as String,
        isFavorite: map['isFavorite'] as bool? ?? false,
      );

  CheatSheet copyWith({bool? isFavorite}) => CheatSheet(
        id: id,
        title: title,
        technology: technology,
        tags: tags,
        content: content,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}
