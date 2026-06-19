import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/services/hive_service.dart';
import '../models/bug_entry.dart';

class BugState {
  final List<BugEntry> entries;
  final String searchQuery;

  const BugState({required this.entries, this.searchQuery = ''});

  List<BugEntry> get filtered {
    if (searchQuery.isEmpty) return entries;
    final q = searchQuery.toLowerCase();
    return entries
        .where((b) =>
            b.title.toLowerCase().contains(q) ||
            b.technology.toLowerCase().contains(q) ||
            b.solution.toLowerCase().contains(q) ||
            b.context.toLowerCase().contains(q) ||
            b.tags.any((t) => t.toLowerCase().contains(q)))
        .toList();
  }

  BugState copyWith({List<BugEntry>? entries, String? searchQuery}) =>
      BugState(
        entries: entries ?? this.entries,
        searchQuery: searchQuery ?? this.searchQuery,
      );
}

class BugNotifier extends StateNotifier<BugState> {
  static const _uuid = Uuid();

  BugNotifier() : super(const BugState(entries: [])) {
    _load();
  }

  void _load() {
    final entries = HiveService.bugs.values
        .map((v) => BugEntry.fromMap(v as Map))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    state = state.copyWith(entries: entries);
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> addEntry({
    required String title,
    required String context,
    required String solution,
    required List<String> tags,
    required String technology,
  }) async {
    final entry = BugEntry(
      id: _uuid.v4(),
      title: title,
      context: context,
      solution: solution,
      tags: tags,
      technology: technology,
      date: DateTime.now(),
    );
    await HiveService.bugs.put(entry.id, entry.toMap());
    state = state.copyWith(entries: [entry, ...state.entries]);
  }

  Future<void> deleteEntry(String id) async {
    await HiveService.bugs.delete(id);
    state =
        state.copyWith(entries: state.entries.where((e) => e.id != id).toList());
  }
}

final bugProvider = StateNotifierProvider<BugNotifier, BugState>(
  (ref) => BugNotifier(),
);
