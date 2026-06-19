import 'package:dio/dio.dart';
import '../../models/dev_tip.dart';
import '../../models/youtube_video.dart';
import '../data/seed_data.dart';

class ApiService {
  static final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 6),
    ),
  );

  // Quotable API — citations tech/programmation
  // Doc : https://github.com/lukePeavey/quotable
  static Future<DevTip> fetchDevTip() async {
    try {
      final response = await _dio.get(
        'https://api.quotable.io/quotes/random',
        queryParameters: {'tags': 'technology', 'limit': 1},
      );
      final data = (response.data as List).first as Map;
      return DevTip(
        content: data['content'] as String,
        author: data['author'] as String,
        category: 'quote',
      );
    } catch (_) {
      // Fallback local si l'API est inaccessible
      final tips = List<DevTip>.from(SeedData.localDevTips)..shuffle();
      return tips.first;
    }
  }

  // YouTube Data API v3 — recherche de Shorts par tag
  // Doc : https://developers.google.com/youtube/v3/docs/search/list
  // Retourne les vidéos ET le nextPageToken pour la pagination
  static Future<Map<String, dynamic>> fetchYoutubeShorts({
    required String tag,
    required String apiKey,
    int maxResults = 25,
    String? pageToken,
  }) async {
    final params = <String, dynamic>{
      'part': 'snippet',
      'q': '$tag #shorts',
      'type': 'video',
      'videoDuration': 'short',
      'maxResults': maxResults,
      'relevanceLanguage': 'fr',
      'order': 'relevance',
      'key': apiKey,
    };
    if (pageToken != null) params['pageToken'] = pageToken;

    final response = await _dio.get(
      'https://www.googleapis.com/youtube/v3/search',
      queryParameters: params,
    );

    final items = response.data['items'] as List;
    final videos = items
        .where((item) => (item['id'] as Map).containsKey('videoId'))
        .map((item) => YoutubeVideo.fromJson(item as Map<String, dynamic>))
        .toList();

    return {
      'videos': videos,
      'nextPageToken': response.data['nextPageToken'] as String?,
    };
  }
}

