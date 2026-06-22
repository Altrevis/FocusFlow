import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/models/cheat_sheet.dart';

void main() {
  group('CheatSheet', () {
    const sheet = CheatSheet(
      id: 'cs-01',
      title: 'Commandes Git de base',
      technology: 'Git',
      tags: ['git', 'vcs'],
      content: '## git add\n`git add .` pour tout stager',
      isFavorite: false,
    );

    test('les champs sont correctement assignés', () {
      expect(sheet.id, 'cs-01');
      expect(sheet.title, 'Commandes Git de base');
      expect(sheet.technology, 'Git');
      expect(sheet.tags, ['git', 'vcs']);
      expect(sheet.content, '## git add\n`git add .` pour tout stager');
      expect(sheet.isFavorite, false);
    });

    test('isFavorite vaut false par défaut', () {
      const s = CheatSheet(
        id: 'x',
        title: 'T',
        technology: 'T',
        tags: [],
        content: 'C',
      );
      expect(s.isFavorite, false);
    });

    test('toMap() sérialise correctement', () {
      final map = sheet.toMap();

      expect(map['id'], 'cs-01');
      expect(map['title'], 'Commandes Git de base');
      expect(map['technology'], 'Git');
      expect(map['tags'], ['git', 'vcs']);
      expect(map['content'], '## git add\n`git add .` pour tout stager');
      expect(map['isFavorite'], false);
    });

    test('fromMap() désérialise correctement', () {
      final map = {
        'id': 'cs-01',
        'title': 'Commandes Git de base',
        'technology': 'Git',
        'tags': ['git', 'vcs'],
        'content': '## git add\n`git add .` pour tout stager',
        'isFavorite': false,
      };

      final fromMap = CheatSheet.fromMap(map);

      expect(fromMap.id, 'cs-01');
      expect(fromMap.title, 'Commandes Git de base');
      expect(fromMap.technology, 'Git');
      expect(fromMap.tags, ['git', 'vcs']);
      expect(fromMap.content, '## git add\n`git add .` pour tout stager');
      expect(fromMap.isFavorite, false);
    });

    test('fromMap() utilise false si isFavorite est absent', () {
      final map = {
        'id': 'cs-02',
        'title': 'T',
        'technology': 'T',
        'tags': <String>[],
        'content': 'C',
        // isFavorite absent → doit valoir false
      };
      final s = CheatSheet.fromMap(map);
      expect(s.isFavorite, false);
    });

    test('toMap() puis fromMap() est un roundtrip sans perte', () {
      final map = sheet.toMap();
      final rebuilt = CheatSheet.fromMap(map);

      expect(rebuilt.id, sheet.id);
      expect(rebuilt.title, sheet.title);
      expect(rebuilt.technology, sheet.technology);
      expect(rebuilt.tags, sheet.tags);
      expect(rebuilt.content, sheet.content);
      expect(rebuilt.isFavorite, sheet.isFavorite);
    });

    group('copyWith()', () {
      test('change isFavorite à true', () {
        final updated = sheet.copyWith(isFavorite: true);
        expect(updated.isFavorite, true);
        // Les autres champs sont inchangés
        expect(updated.id, sheet.id);
        expect(updated.title, sheet.title);
        expect(updated.technology, sheet.technology);
        expect(updated.tags, sheet.tags);
        expect(updated.content, sheet.content);
      });

      test('sans argument ne modifie rien', () {
        final copy = sheet.copyWith();
        expect(copy.isFavorite, sheet.isFavorite);
        expect(copy.id, sheet.id);
      });
    });
  });
}
