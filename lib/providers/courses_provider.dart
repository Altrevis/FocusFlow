import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/api_service.dart';
import '../core/services/hive_service.dart';
import '../models/youtube_video.dart';

// Tags de recherche disponibles
const devTags = [
  'Flutter',
  'JavaScript',
  'Python',
  'React',
  'TypeScript',
  'CSS',
  'Node.js',
  'Git',
  'Docker',
  'Linux',
  'Backend',
  'Frontend',
  'DevOps',
];

class CoursesState {
  final String selectedTag;
  final List<YoutubeVideo> videos;
  final bool isLoading;
  final String? error;
  // Stocke le nextPageToken par tag → chaque switch de tag charge de nouvelles vidéos
  final Map<String, String> pageTokens;

  const CoursesState({
    this.selectedTag = 'Flutter',
    this.videos = const [],
    this.isLoading = false,
    this.error,
    this.pageTokens = const {},
  });

  CoursesState copyWith({
    String? selectedTag,
    List<YoutubeVideo>? videos,
    bool? isLoading,
    Object? error = _sentinel,
    Map<String, String>? pageTokens,
  }) =>
      CoursesState(
        selectedTag: selectedTag ?? this.selectedTag,
        videos: videos ?? this.videos,
        isLoading: isLoading ?? this.isLoading,
        error: error == _sentinel ? this.error : error as String?,
        pageTokens: pageTokens ?? this.pageTokens,
      );

  static const _sentinel = Object();
}

class CoursesNotifier extends StateNotifier<CoursesState> {
  CoursesNotifier() : super(const CoursesState()) {
    final key = HiveService.settings.get('youtubeApiKey', defaultValue: '') as String;
    if (key.isNotEmpty) fetchVideos();
  }

  String get _apiKey =>
      HiveService.settings.get('youtubeApiKey', defaultValue: '') as String;

  bool get hasApiKey => _apiKey.isNotEmpty;

  Future<void> fetchVideos({String? tag}) async {
    final selectedTag = tag ?? state.selectedTag;
    if (_apiKey.isEmpty) return;

    // Récupère le pageToken sauvegardé pour ce tag (null = première page)
    final pageToken = state.pageTokens[selectedTag];

    state = state.copyWith(
      selectedTag: selectedTag,
      isLoading: true,
      error: null,
      videos: [],
    );

    try {
      final result = await ApiService.fetchYoutubeShorts(
        tag: selectedTag,
        apiKey: _apiKey,
        pageToken: pageToken,
      );

      final videos = result['videos'] as List<YoutubeVideo>;
      final nextToken = result['nextPageToken'] as String?;

      // Sauvegarde le nextPageToken pour ce tag → prochain appel = nouvelles vidéos
      final updatedTokens = Map<String, String>.from(state.pageTokens);
      if (nextToken != null) {
        updatedTokens[selectedTag] = nextToken;
      } else {
        // Plus de pages : on repart du début pour ce tag
        updatedTokens.remove(selectedTag);
      }

      state = state.copyWith(
        videos: videos,
        isLoading: false,
        pageTokens: updatedTokens,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().contains('403')
            ? 'Clé API invalide ou quota dépassé.'
            : 'Impossible de charger les vidéos. Vérifie ta connexion.',
      );
    }
  }

  void selectTag(String tag) {
    // Toujours charger de nouvelles vidéos au changement de tag
    fetchVideos(tag: tag);
  }
}

final coursesProvider =
    StateNotifierProvider<CoursesNotifier, CoursesState>(
  (ref) => CoursesNotifier(),
);
