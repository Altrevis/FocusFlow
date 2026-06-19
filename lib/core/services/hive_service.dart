import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const logsBox = 'logs';
  static const bugsBox = 'bugs';
  static const refBox = 'ref';
  static const settingsBox = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(logsBox);
    await Hive.openBox(bugsBox);
    await Hive.openBox(refBox);
    await Hive.openBox(settingsBox);
  }

  static Box get logs => Hive.box(logsBox);
  static Box get bugs => Hive.box(bugsBox);
  static Box get ref => Hive.box(refBox);
  static Box get settings => Hive.box(settingsBox);
}
