import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/models/youtube_video.dart';

void main() {
  group('YoutubeVideo', () {
    const video = YoutubeVideo(
      id: 'dQw4w9WgXcQ',
      title: 'Flutter State Management',
      channelTitle: 'Flutter Dev',
      thumbnailUrl: 'https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
      publishedAt: '2024-01-15T10:00:00Z',
    );

    test('les champs sont correctement assignés', () {
      expect(video.id, 'dQw4w9WgXcQ');
      expect(video.title, 'Flutter State Management');
      expect(video.channelTitle, 'Flutter Dev');
      expect(video.thumbnailUrl, 'https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg');
      expect(video.publishedAt, '2024-01-15T10:00:00Z');
    });

    test('url retourne l\'URL YouTube correcte', () {
      expect(video.url, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ');
    });

    test('embedUrl retourne l\'URL embed correcte', () {
      expect(video.embedUrl, 'https://www.youtube.com/embed/dQw4w9WgXcQ');
    });

    group('fromJson()', () {
      test('désérialise correctement avec thumbnail high', () {
        final json = {
          'id': {'videoId': 'abc123'},
          'snippet': {
            'title': 'Riverpod Tutorial',
            'channelTitle': 'Code With Me',
            'publishedAt': '2024-03-10T08:00:00Z',
            'thumbnails': {
              'high': {'url': 'https://i.ytimg.com/vi/abc123/hqdefault.jpg'},
              'medium': {'url': 'https://i.ytimg.com/vi/abc123/mqdefault.jpg'},
              'default': {'url': 'https://i.ytimg.com/vi/abc123/default.jpg'},
            },
          },
        };

        final v = YoutubeVideo.fromJson(json);

        expect(v.id, 'abc123');
        expect(v.title, 'Riverpod Tutorial');
        expect(v.channelTitle, 'Code With Me');
        expect(v.publishedAt, '2024-03-10T08:00:00Z');
        expect(v.thumbnailUrl, 'https://i.ytimg.com/vi/abc123/hqdefault.jpg');
      });

      test('utilise medium si high est absent', () {
        final json = {
          'id': {'videoId': 'xyz789'},
          'snippet': {
            'title': 'Dart Tips',
            'channelTitle': 'Dart Dev',
            'publishedAt': '2024-04-01T12:00:00Z',
            'thumbnails': {
              'medium': {'url': 'https://i.ytimg.com/vi/xyz789/mqdefault.jpg'},
              'default': {'url': 'https://i.ytimg.com/vi/xyz789/default.jpg'},
            },
          },
        };

        final v = YoutubeVideo.fromJson(json);
        expect(v.thumbnailUrl, 'https://i.ytimg.com/vi/xyz789/mqdefault.jpg');
      });

      test('utilise default si high et medium sont absents', () {
        final json = {
          'id': {'videoId': 'def456'},
          'snippet': {
            'title': 'Intro Dart',
            'channelTitle': 'Dart Intro',
            'publishedAt': '2024-05-01T12:00:00Z',
            'thumbnails': {
              'default': {'url': 'https://i.ytimg.com/vi/def456/default.jpg'},
            },
          },
        };

        final v = YoutubeVideo.fromJson(json);
        expect(v.thumbnailUrl, 'https://i.ytimg.com/vi/def456/default.jpg');
      });
    });
  });
}
