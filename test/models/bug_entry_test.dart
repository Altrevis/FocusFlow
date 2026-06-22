import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/models/bug_entry.dart';

void main() {
  group('BugEntry', () {
    final date = DateTime(2024, 6, 15, 10, 30);

    final entry = BugEntry(
      id: 'abc-123',
      title: 'Null pointer sur ListView',
      context: 'Le widget plante au démarrage',
      solution: 'Ajouter une vérification null avant accès',
      tags: ['flutter', 'null-safety'],
      technology: 'Flutter',
      date: date,
    );

    test('les champs sont correctement assignés', () {
      expect(entry.id, 'abc-123');
      expect(entry.title, 'Null pointer sur ListView');
      expect(entry.context, 'Le widget plante au démarrage');
      expect(entry.solution, 'Ajouter une vérification null avant accès');
      expect(entry.tags, ['flutter', 'null-safety']);
      expect(entry.technology, 'Flutter');
      expect(entry.date, date);
    });

    test('toMap() sérialise correctement', () {
      final map = entry.toMap();

      expect(map['id'], 'abc-123');
      expect(map['title'], 'Null pointer sur ListView');
      expect(map['context'], 'Le widget plante au démarrage');
      expect(map['solution'], 'Ajouter une vérification null avant accès');
      expect(map['tags'], ['flutter', 'null-safety']);
      expect(map['technology'], 'Flutter');
      expect(map['date'], date.toIso8601String());
    });

    test('fromMap() désérialise correctement', () {
      final map = {
        'id': 'abc-123',
        'title': 'Null pointer sur ListView',
        'context': 'Le widget plante au démarrage',
        'solution': 'Ajouter une vérification null avant accès',
        'tags': ['flutter', 'null-safety'],
        'technology': 'Flutter',
        'date': date.toIso8601String(),
      };

      final fromMap = BugEntry.fromMap(map);

      expect(fromMap.id, 'abc-123');
      expect(fromMap.title, 'Null pointer sur ListView');
      expect(fromMap.context, 'Le widget plante au démarrage');
      expect(fromMap.solution, 'Ajouter une vérification null avant accès');
      expect(fromMap.tags, ['flutter', 'null-safety']);
      expect(fromMap.technology, 'Flutter');
      expect(fromMap.date, date);
    });

    test('toMap() puis fromMap() est un roundtrip sans perte', () {
      final map = entry.toMap();
      final rebuilt = BugEntry.fromMap(map);

      expect(rebuilt.id, entry.id);
      expect(rebuilt.title, entry.title);
      expect(rebuilt.context, entry.context);
      expect(rebuilt.solution, entry.solution);
      expect(rebuilt.tags, entry.tags);
      expect(rebuilt.technology, entry.technology);
      expect(rebuilt.date, entry.date);
    });

    test('fromMap() accepte une liste de tags vide', () {
      final map = {
        'id': 'x',
        'title': 'T',
        'context': 'C',
        'solution': 'S',
        'tags': <String>[],
        'technology': 'Dart',
        'date': date.toIso8601String(),
      };
      final e = BugEntry.fromMap(map);
      expect(e.tags, isEmpty);
    });
  });
}
