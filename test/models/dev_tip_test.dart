import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/models/dev_tip.dart';

void main() {
  group('DevTip', () {
    const tip = DevTip(
      content: 'Utilise const dès que possible pour optimiser Flutter.',
      author: 'Équipe Flutter',
      category: 'Performance',
    );

    test('les champs sont correctement assignés', () {
      expect(tip.content, 'Utilise const dès que possible pour optimiser Flutter.');
      expect(tip.author, 'Équipe Flutter');
      expect(tip.category, 'Performance');
    });

    test('toMap() sérialise correctement', () {
      final map = tip.toMap();

      expect(map['content'], 'Utilise const dès que possible pour optimiser Flutter.');
      expect(map['author'], 'Équipe Flutter');
      expect(map['category'], 'Performance');
    });

    test('fromMap() désérialise correctement', () {
      final map = {
        'content': 'Utilise const dès que possible pour optimiser Flutter.',
        'author': 'Équipe Flutter',
        'category': 'Performance',
      };

      final fromMap = DevTip.fromMap(map);

      expect(fromMap.content, tip.content);
      expect(fromMap.author, tip.author);
      expect(fromMap.category, tip.category);
    });

    test('toMap() puis fromMap() est un roundtrip sans perte', () {
      final map = tip.toMap();
      final rebuilt = DevTip.fromMap(map);

      expect(rebuilt.content, tip.content);
      expect(rebuilt.author, tip.author);
      expect(rebuilt.category, tip.category);
    });
  });
}
