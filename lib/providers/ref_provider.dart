import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/hive_service.dart';
import '../models/cheat_sheet.dart';

class RefState {
  final List<CheatSheet> sheets;
  final String searchQuery;
  final String? selectedTechnology;

  const RefState({
    required this.sheets,
    this.searchQuery = '',
    this.selectedTechnology,
  });

  List<CheatSheet> get filtered {
    var list = sheets;
    if (selectedTechnology != null) {
      list = list.where((s) => s.technology == selectedTechnology).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where((s) =>
              s.title.toLowerCase().contains(q) ||
              s.technology.toLowerCase().contains(q) ||
              s.tags.any((t) => t.toLowerCase().contains(q)))
          .toList();
    }
    // Les favoris apparaissent en premier
    list.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return 0;
    });
    return list;
  }

  List<String> get technologies =>
      sheets.map((s) => s.technology).toSet().toList()..sort();

  RefState copyWith({
    List<CheatSheet>? sheets,
    String? searchQuery,
    Object? selectedTechnology = _sentinel,
  }) =>
      RefState(
        sheets: sheets ?? this.sheets,
        searchQuery: searchQuery ?? this.searchQuery,
        selectedTechnology: selectedTechnology == _sentinel
            ? this.selectedTechnology
            : selectedTechnology as String?,
      );

  static const _sentinel = Object();
}

class RefNotifier extends StateNotifier<RefState> {
  RefNotifier() : super(const RefState(sheets: [])) {
    _load();
  }

  void _load() {
    final box = HiveService.ref;
    final sheets =
        box.values.map((v) => CheatSheet.fromMap(v as Map)).toList();
    state = state.copyWith(sheets: sheets);
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setTechnology(String? tech) {
    state = state.copyWith(selectedTechnology: tech);
  }

  void toggleFavorite(String id) {
    final updated = state.sheets.map((s) {
      if (s.id == id) {
        final updatedSheet = s.copyWith(isFavorite: !s.isFavorite);
        HiveService.ref.put(id, updatedSheet.toMap());
        return updatedSheet;
      }
      return s;
    }).toList();
    state = state.copyWith(sheets: updated);
  }
}

final refProvider = StateNotifierProvider<RefNotifier, RefState>(
  (ref) => RefNotifier(),
);
