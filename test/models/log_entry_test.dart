import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/models/log_entry.dart';

void main() {
  group('LogEntry', () {
    final date = DateTime(2024, 5, 20, 9, 0);

    final entry = LogEntry(
      id: 'log-001',
      date: date,
      content: 'Travaillé sur le provider Riverpod',
      tags: ['riverpod', 'flutter'],
    );

    test('les champs sont correctement assignés', () {
      expect(entry.id, 'log-001');
      expect(entry.date, date);
      expect(entry.content, 'Travaillé sur le provider Riverpod');
      expect(entry.tags, ['riverpod', 'flutter']);
    });

    test('toMap() sérialise correctement', () {
      final map = entry.toMap();

      expect(map['id'], 'log-001');
      expect(map['date'], date.toIso8601String());
      expect(map['content'], 'Travaillé sur le provider Riverpod');
      expect(map['tags'], ['riverpod', 'flutter']);
    });

    test('fromMap() désérialise correctement', () {
      final map = {
        'id': 'log-001',
        'date': date.toIso8601String(),
        'content': 'Travaillé sur le provider Riverpod',
        'tags': ['riverpod', 'flutter'],
      };

      final fromMap = LogEntry.fromMap(map);

      expect(fromMap.id, 'log-001');
      expect(fromMap.date, date);
      expect(fromMap.content, 'Travaillé sur le provider Riverpod');
      expect(fromMap.tags, ['riverpod', 'flutter']);
    });

    test('toMap() puis fromMap() est un roundtrip sans perte', () {
      final map = entry.toMap();
      final rebuilt = LogEntry.fromMap(map);

      expect(rebuilt.id, entry.id);
      expect(rebuilt.date, entry.date);
      expect(rebuilt.content, entry.content);
      expect(rebuilt.tags, entry.tags);
    });

    test('fromMap() accepte des tags vides', () {
      final map = {
        'id': 'log-002',
        'date': date.toIso8601String(),
        'content': 'Contenu sans tags',
        'tags': <String>[],
      };
      final e = LogEntry.fromMap(map);
      expect(e.tags, isEmpty);
    });
  });
}
