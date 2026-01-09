import 'package:hive_flutter/hive_flutter.dart';
import '../Models/batsman_model.dart';
import '../Models/bowler_model.dart';
import '../Models/score_model.dart';

class HiveService {
  static const String batsmanBoxName = 'batsman_box';
  static const String bowlerBoxName = 'bowler_box';
  static const String scoreBoxName = 'score_box';

  // Initialize Hive and boxes
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BatsmanModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BowlerModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ScoreModelAdapter());
    }

    // Open boxes
    final batsmanBox = await Hive.openBox<BatsmanModel>(batsmanBoxName);
    await Hive.openBox<BowlerModel>(bowlerBoxName);
    await Hive.openBox<ScoreModel>(scoreBoxName);

    // ✅ Ensure all default batsmen exist
    await _ensureDefaultBatsmen(batsmanBox);
  }

  // Get boxes
  static Box<BatsmanModel> getBatsmanBox() => Hive.box<BatsmanModel>(batsmanBoxName);
  static Box<BowlerModel> getBowlerBox() => Hive.box<BowlerModel>(bowlerBoxName);
  static Box<ScoreModel> getScoreBox() => Hive.box<ScoreModel>(scoreBoxName);

  // Get or create score model
  static ScoreModel getOrCreateScore() {
    final box = Hive.box<ScoreModel>(scoreBoxName);
    if (box.isEmpty) {
      final newScore = ScoreModel();
      box.add(newScore);
      return newScore;
    }
    return box.getAt(0)!;
  }

  // Reset all data
  static Future<void> resetAllData() async {
    await getBatsmanBox().clear();
    await getBowlerBox().clear();
    final scoreBox = Hive.box<ScoreModel>(scoreBoxName);
    if (scoreBox.isNotEmpty) {
      scoreBox.getAt(0)?.resetScore();
    }
  }

  // -----------------------------
  // PRIVATE HELPER: Ensure default batsmen
  static Future<void> _ensureDefaultBatsmen(Box<BatsmanModel> box) async {
    List<String> defaultNames = ['Hari', 'Berry', 'Gautham', 'Martial'];

    for (var name in defaultNames) {
      // Check if batsman already exists
      bool exists = box.values.any((b) => b.name == name);
      if (!exists) {
        // Add new batsman safely
        await box.add(BatsmanModel.create(name: name, batsmanBox: box));
      }
    }
  }
}
