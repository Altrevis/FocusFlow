import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/models/bug_entry.dart';
import 'package:focusflow/providers/bug_provider.dart';

BugEntry _bug({
  String id = '1',
  String title = 'Titre',
  String context = 'Contexte',
  String solution = 'Solution',
  List<String> tags = const [],
  String technology = 'Flutter',
}) =>
    BugEntry(
      id: id,
      title: title,
      context: context,
      solution: solution,
      tags: tags,
      technology: technology,
      date: DateTime(2024),
    );

void main() {
  group('BugState', () {
    group('filtered', () {
      test('retourne toutes les entrées si la recherche est vide', () {
        final state = BugState(
          entries: [_bug(id: '1'), _bug(id: '2')],
          searchQuery: '',
        );
        expect(state.filtered, hasLength(2));
      });

      test('filtre par titre (insensible à la casse)', () {
        final state = BugState(
          entries: [
            _bug(id: '1', title: 'Null Pointer Exception'),
            _bug(id: '2', title: 'Overflow widget'),
          ],
          searchQuery: 'null',
        );
        expect(state.filtered, hasLength(1));
        expect(state.filtered.first.id, '1');
      });

      test('filtre par technologie', () {
        final state = BugState(
          entries: [
            _bug(id: '1', technology: 'Flutter'),
            _bug(id: '2', technology: 'Dart'),
          ],
          searchQuery: 'dart',
        );
        expect(state.filtered, hasLength(1));
        expect(state.filtered.first.id, '2');
      });

      test('filtre par contenu de la solution', () {
        final state = BugState(
          entries: [
            _bug(id: '1', solution: 'Ajouter const au constructeur'),
            _bug(id: '2', solution: 'Utiliser setState'),
          ],
          searchQuery: 'const',
        );
        expect(state.filtered, hasLength(1));
        expect(state.filtered.first.id, '1');
      });

      test('filtre par contexte', () {
        final state = BugState(
          entries: [
            _bug(id: '1', context: 'Au démarrage de l\'app'),
            _bug(id: '2', context: 'Au clic du bouton'),
          ],
          searchQuery: 'démarrage',
        );
        expect(state.filtered, hasLength(1));
        expect(state.filtered.first.id, '1');
      });

      test('filtre par tag', () {
        final state = BugState(
          entries: [
            _bug(id: '1', tags: ['riverpod', 'state']),
            _bug(id: '2', tags: ['http', 'dio']),
          ],
          searchQuery: 'riverpod',
        );
        expect(state.filtered, hasLength(1));
        expect(state.filtered.first.id, '1');
      });

      test('retourne une liste vide si aucune entrée ne correspond', () {
        final state = BugState(
          entries: [_bug(id: '1', title: 'Crash au build')],
          searchQuery: 'firebase',
        );
        expect(state.filtered, isEmpty);
      });

      test('retourne plusieurs résultats si plusieurs entrées correspondent', () {
        final state = BugState(
          entries: [
            _bug(id: '1', title: 'Erreur Flutter A'),
            _bug(id: '2', title: 'Erreur Flutter B'),
            _bug(id: '3', title: 'Bug Dart', technology: 'Dart'),
          ],
          searchQuery: 'flutter',
        );
        expect(state.filtered, hasLength(2));
      });
    });

    group('copyWith()', () {
      test('met à jour searchQuery', () {
        const state = BugState(entries: [], searchQuery: '');
        final updated = state.copyWith(searchQuery: 'test');
        expect(updated.searchQuery, 'test');
        expect(updated.entries, isEmpty);
      });

      test('met à jour entries', () {
        const state = BugState(entries: [], searchQuery: 'q');
        final entries = [_bug(id: '1')];
        final updated = state.copyWith(entries: entries);
        expect(updated.entries, hasLength(1));
        expect(updated.searchQuery, 'q');
      });

      test('sans argument conserve l\'état actuel', () {
        final entries = [_bug(id: '1')];
        final state = BugState(entries: entries, searchQuery: 'dart');
        final copy = state.copyWith();
        expect(copy.searchQuery, 'dart');
        expect(copy.entries, hasLength(1));
      });
    });
  });
}
