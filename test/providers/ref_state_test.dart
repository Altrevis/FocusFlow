import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/models/cheat_sheet.dart';
import 'package:focusflow/providers/ref_provider.dart';

CheatSheet _sheet({
  String id = '1',
  String title = 'Titre',
  String technology = 'Flutter',
  List<String> tags = const [],
  String content = 'Contenu',
  bool isFavorite = false,
}) =>
    CheatSheet(
      id: id,
      title: title,
      technology: technology,
      tags: tags,
      content: content,
      isFavorite: isFavorite,
    );

void main() {
  group('RefState', () {
    group('filtered', () {
      test('retourne toutes les feuilles si aucun filtre', () {
        final state = RefState(
          sheets: [_sheet(id: '1'), _sheet(id: '2')],
        );
        expect(state.filtered, hasLength(2));
      });

      test('filtre par technologie', () {
        final state = RefState(
          sheets: [
            _sheet(id: '1', technology: 'Flutter'),
            _sheet(id: '2', technology: 'Git'),
          ],
          selectedTechnology: 'Git',
        );
        expect(state.filtered, hasLength(1));
        expect(state.filtered.first.id, '2');
      });

      test('filtre par titre (insensible à la casse)', () {
        final state = RefState(
          sheets: [
            _sheet(id: '1', title: 'Commandes Git'),
            _sheet(id: '2', title: 'Provider Flutter'),
          ],
          searchQuery: 'git',
        );
        expect(state.filtered, hasLength(1));
        expect(state.filtered.first.id, '1');
      });

      test('filtre par tag', () {
        final state = RefState(
          sheets: [
            _sheet(id: '1', tags: ['async', 'await']),
            _sheet(id: '2', tags: ['widget', 'layout']),
          ],
          searchQuery: 'async',
        );
        expect(state.filtered, hasLength(1));
        expect(state.filtered.first.id, '1');
      });

      test('combine filtre technologie ET recherche texte', () {
        final state = RefState(
          sheets: [
            _sheet(id: '1', technology: 'Flutter', title: 'Widgets de base'),
            _sheet(id: '2', technology: 'Flutter', title: 'Navigation avancée'),
            _sheet(id: '3', technology: 'Git', title: 'Widgets Git'),
          ],
          selectedTechnology: 'Flutter',
          searchQuery: 'widget',
        );
        expect(state.filtered, hasLength(1));
        expect(state.filtered.first.id, '1');
      });

      test('les favoris apparaissent avant les non-favoris', () {
        final state = RefState(
          sheets: [
            _sheet(id: '1', isFavorite: false),
            _sheet(id: '2', isFavorite: true),
            _sheet(id: '3', isFavorite: false),
          ],
        );
        expect(state.filtered.first.id, '2');
        expect(state.filtered.first.isFavorite, true);
      });

      test('retourne une liste vide si aucune correspondance', () {
        final state = RefState(
          sheets: [_sheet(id: '1', title: 'Git rebase')],
          searchQuery: 'firebase',
        );
        expect(state.filtered, isEmpty);
      });
    });

    group('technologies', () {
      test('retourne la liste dédupliquée des technologies triée', () {
        final state = RefState(
          sheets: [
            _sheet(technology: 'Flutter'),
            _sheet(technology: 'Git'),
            _sheet(technology: 'Flutter'),
            _sheet(technology: 'Dart'),
          ],
        );
        expect(state.technologies, ['Dart', 'Flutter', 'Git']);
      });

      test('retourne une liste vide s\'il n\'y a pas de feuilles', () {
        const state = RefState(sheets: []);
        expect(state.technologies, isEmpty);
      });
    });

    group('copyWith()', () {
      test('met à jour searchQuery', () {
        const state = RefState(sheets: []);
        final updated = state.copyWith(searchQuery: 'dart');
        expect(updated.searchQuery, 'dart');
      });

      test('met à jour selectedTechnology', () {
        const state = RefState(sheets: []);
        final updated = state.copyWith(selectedTechnology: 'Git');
        expect(updated.selectedTechnology, 'Git');
      });

      test('peut effacer selectedTechnology avec null', () {
        const state = RefState(sheets: [], selectedTechnology: 'Git');
        final updated = state.copyWith(selectedTechnology: null);
        expect(updated.selectedTechnology, isNull);
      });

      test('sans argument conserve l\'état actuel', () {
        final state = RefState(
          sheets: [_sheet()],
          searchQuery: 'q',
          selectedTechnology: 'Dart',
        );
        final copy = state.copyWith();
        expect(copy.searchQuery, 'q');
        expect(copy.selectedTechnology, 'Dart');
        expect(copy.sheets, hasLength(1));
      });
    });
  });
}
