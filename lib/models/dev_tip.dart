class DevTip {
  final String content;
  final String author;
  final String category;

  const DevTip({
    required this.content,
    required this.author,
    required this.category,
  });

  Map<String, dynamic> toMap() => {
        'content': content,
        'author': author,
        'category': category,
      };

  factory DevTip.fromMap(Map<dynamic, dynamic> map) => DevTip(
        content: map['content'] as String,
        author: map['author'] as String,
        category: map['category'] as String,
      );
}
