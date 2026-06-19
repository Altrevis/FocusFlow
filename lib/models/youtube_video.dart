class YoutubeVideo {
  final String id;
  final String title;
  final String channelTitle;
  final String thumbnailUrl;
  final String publishedAt;

  const YoutubeVideo({
    required this.id,
    required this.title,
    required this.channelTitle,
    required this.thumbnailUrl,
    required this.publishedAt,
  });

  // URL de la vidéo YouTube
  String get url => 'https://www.youtube.com/watch?v=$id';

  // URL embed pour prévisualisation
  String get embedUrl => 'https://www.youtube.com/embed/$id';

  factory YoutubeVideo.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] as Map<String, dynamic>;
    final thumbnails = snippet['thumbnails'] as Map<String, dynamic>;
    final thumb = (thumbnails['high'] ?? thumbnails['medium'] ?? thumbnails['default'])
        as Map<String, dynamic>;

    return YoutubeVideo(
      id: (json['id'] as Map<String, dynamic>)['videoId'] as String,
      title: snippet['title'] as String,
      channelTitle: snippet['channelTitle'] as String,
      thumbnailUrl: thumb['url'] as String,
      publishedAt: snippet['publishedAt'] as String,
    );
  }
}
