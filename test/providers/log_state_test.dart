import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/models/log_entry.dart';
import 'package:focusflow/providers/log_provider.dart';

// Reproduit la logique privée _calcStreak de LogNotifier
// pour pouvoir la tester de façon isolée.
int calcStreak(List<LogEntry> entries) {
  if (entries.isEmpty) return 0;

  final dates = entries
      .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
      .toSet()
      .toList()
    ..sort((a, b) => b.compareTo(a));

  final today = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

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

LogEntry _entry(DateTime date) => LogEntry(
      id: date.toIso8601String(),
      date: date,
      content: 'Log du jour',
      tags: [],
    );

void main() {
  group('LogState', () {
    test('copyWith() met à jour entries', () {
      const state = LogState(entries: [], streak: 0);
      final entries = [_entry(DateTime.now())];
      final updated = state.copyWith(entries: entries);
      expect(updated.entries, hasLength(1));
      expect(updated.streak, 0);
    });

    test('copyWith() met à jour streak', () {
      const state = LogState(entries: [], streak: 3);
      final updated = state.copyWith(streak: 5);
      expect(updated.streak, 5);
    });

    test('copyWith() sans argument conserve l\'état actuel', () {
      final entries = [_entry(DateTime.now())];
      final state = LogState(entries: entries, streak: 2);
      final copy = state.copyWith();
      expect(copy.streak, 2);
      expect(copy.entries, hasLength(1));
    });
  });

  group('calcStreak (logique de la streak)', () {
    final today = DateTime.now();

    test('retourne 0 si la liste est vide', () {
      expect(calcStreak([]), 0);
    });

    test('retourne 0 si le dernier log est antérieur à hier', () {
      final oldEntry = _entry(today.subtract(const Duration(days: 3)));
      expect(calcStreak([oldEntry]), 0);
    });

    test('retourne 1 avec un seul log aujourd\'hui', () {
      final entry = _entry(today);
      expect(calcStreak([entry]), 1);
    });

    test('retourne 1 avec un seul log hier', () {
      final entry = _entry(today.subtract(const Duration(days: 1)));
      expect(calcStreak([entry]), 1);
    });

    test('retourne 2 avec des logs aujourd\'hui et hier', () {
      final entries = [
        _entry(today),
        _entry(today.subtract(const Duration(days: 1))),
      ];
      expect(calcStreak(entries), 2);
    });

    test('retourne 3 avec 3 jours consécutifs se terminant aujourd\'hui', () {
      final entries = [
        _entry(today),
        _entry(today.subtract(const Duration(days: 1))),
        _entry(today.subtract(const Duration(days: 2))),
      ];
      expect(calcStreak(entries), 3);
    });

    test('s\'arrête au premier jour manquant', () {
      final entries = [
        _entry(today),
        // Jour -1 manquant
        _entry(today.subtract(const Duration(days: 2))),
        _entry(today.subtract(const Duration(days: 3))),
      ];
      // Streak = 1 (seulement aujourd'hui est consécutif)
      expect(calcStreak(entries), 1);
    });

    test('plusieurs logs le même jour comptent comme 1 seul jour', () {
      final entries = [
        _entry(today),
        _entry(today.copyWith(hour: 14)), // même jour, heure différente
        _entry(today.subtract(const Duration(days: 1))),
      ];
      expect(calcStreak(entries), 2);
    });
  });
}
