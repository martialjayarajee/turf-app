import 'package:hive_flutter/hive_flutter.dart';
import '../models/batsman_model.dart';
import '../models/bowler_model.dart';

class HiveService {
  static const String batsmanBoxName = 'batsman_box';
  static const String bowlerBoxName = 'bowler_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(BatsmanModelAdapter());
    Hive.registerAdapter(BowlerModelAdapter());

    // Open boxes
    await Hive.openBox<BatsmanModel>(batsmanBoxName);
    await Hive.openBox<BowlerModel>(bowlerBoxName);
    
    // Initialize with default data if empty
    await _initializeDefaultData();
  }

  static Box<BatsmanModel> getBatsmanBox() {
    return Hive.box<BatsmanModel>(batsmanBoxName);
  }

  static Box<BowlerModel> getBowlerBox() {
    return Hive.box<BowlerModel>(bowlerBoxName);
  }

  static Future<void> _initializeDefaultData() async {
    final batsmanBox = getBatsmanBox();
    final bowlerBox = getBowlerBox();

    // Add default batsmen if box is empty
    if (batsmanBox.isEmpty) {
      await batsmanBox.add(BatsmanModel(name: 'Virat Kohli'));
      await batsmanBox.add(BatsmanModel(name: 'Rohit Sharma'));
    }

    // Add default bowlers if box is empty
    if (bowlerBox.isEmpty) {
      await bowlerBox.add(BowlerModel(name: 'Starc'));
      await bowlerBox.add(BowlerModel(name: 'Wood'));
    }
  }

  static Future<void> resetData() async {
    final batsmanBox = getBatsmanBox();
    final bowlerBox = getBowlerBox();
    
    await batsmanBox.clear();
    await bowlerBox.clear();
    await _initializeDefaultData();
  }
}