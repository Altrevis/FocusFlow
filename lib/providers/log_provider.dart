import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/services/hive_service.dart';
import '../models/log_entry.dart';

class LogState {
  final List<LogEntry> entries;
  final int streak;

  const LogState({required this.entries, this.streak = 0});

  LogState copyWith({List<LogEntry>? entries, int? streak}) =>
      LogState(
        entries: entries ?? this.entries,
        streak: streak ?? this.streak,
      );
}

class LogNotifier extends StateNotifier<LogState> {
  static const _uuid = Uuid();

  LogNotifier() : super(const LogState(entries: [])) {
    _load();
  }

  void _load() {
    final entries = HiveService.logs.values
        .map((v) => LogEntry.fromMap(v as Map))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    state = LogState(entries: entries, streak: _calcStreak(entries));
  }

  // Calcule le nombre de jours consécutifs avec au moins un log
  int _calcStreak(List<LogEntry> entries) {
    if (entries.isEmpty) return 0;

    final dates = entries
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    // La streak n'est valide que si l'entrée la plus récente est aujourd'hui ou hier
    if (dates.first.isBefore(today.subtract(const Duration(days: 1)))) return 0;

    int streak = 0;
    DateTime check = dates.first;

    for (final date in dates) {
      if (date == check) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  Future<void> addEntry(String content, List<String> tags) async {
    final entry = LogEntry(
      id: _uuid.v4(),
      date: DateTime.now(),
      content: content,
      tags: tags,
    );
    await HiveService.logs.put(entry.id, entry.toMap());
    final updated = [entry, ...state.entries];
    state = LogState(entries: updated, streak: _calcStreak(updated));
  }

  Future<void> deleteEntry(String id) async {
    await HiveService.logs.delete(id);
    final updated = state.entries.where((e) => e.id != id).toList();
    state = LogState(entries: updated, streak: _calcStreak(updated));
  }
}

final logProvider = StateNotifierProvider<LogNotifier, LogState>(
  (ref) => LogNotifier(),
);
