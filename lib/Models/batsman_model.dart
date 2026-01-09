import 'package:hive/hive.dart';

part 'batsman_model.g.dart';

@HiveType(typeId: 0)
class BatsmanModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int runs;

  @HiveField(2)
  int balls;

  @HiveField(3)
  int fours;

  @HiveField(4)
  int sixes;

  @HiveField(5)
  double strikeRate;

  @HiveField(6)
  int id;

  @HiveField(7)
  String b_id;

  @HiveField(8)
  bool isOut;

  BatsmanModel({
    required this.name,
    this.runs = 0,
    this.balls = 0,
    this.fours = 0,
    this.sixes = 0,
    this.strikeRate = 0.0,
    required this.id,
    required this.b_id,
    this.isOut = false,
  });

  void updateStats(int runsScored) {
    runs += runsScored;
    balls++;
    if (runsScored == 4) fours++;
    if (runsScored == 6) sixes++;
    strikeRate = balls > 0 ? (runs * 100.0 / balls) : 0.0;
    save();
  }

  void undoStats(int runsScored) {
    runs -= runsScored;
    if (balls > 0) balls--;
    if (runsScored == 4 && fours > 0) fours--;
    if (runsScored == 6 && sixes > 0) sixes--;
    strikeRate = balls > 0 ? (runs * 100.0 / balls) : 0.0;
    save();
  }

  void markAsOut() {
    isOut = true;
    save();
  }

  void markAsNotOut() {
    isOut = false;
    save();
  }

  void resetStats() {
    runs = 0;
    balls = 0;
    fours = 0;
    sixes = 0;
    strikeRate = 0.0;
    isOut = false;
    save();
  }

  static String generateBId(int id) {
    return 'P_${id.toString().padLeft(2, '0')}';
  }

  factory BatsmanModel.create({
    required String name,
    required Box<BatsmanModel> batsmanBox,
  }) {
    int nextId = 1;
    if (batsmanBox.isNotEmpty) {
      int maxId = 0;
      for (var i = 0; i < batsmanBox.length; i++) {
        var batsman = batsmanBox.getAt(i);
        if (batsman != null && batsman.id > maxId) {
          maxId = batsman.id;
        }
      }
      nextId = maxId + 1;
    }

    return BatsmanModel(
      name: name,
      id: nextId,
      b_id: generateBId(nextId),
    );
  }

  static BatsmanModel? getByBId(Box<BatsmanModel> box, String bId) {
    for (var i = 0; i < box.length; i++) {
      var batsman = box.getAt(i);
      if (batsman != null && batsman.b_id == bId) {
        return batsman;
      }
    }
    return null;
  }

  static List<BatsmanModel> getAllSorted(Box<BatsmanModel> box) {
    List<BatsmanModel> batsmen = [];
    for (var i = 0; i < box.length; i++) {
      var batsman = box.getAt(i);
      if (batsman != null) {
        batsmen.add(batsman);
      }
    }
    batsmen.sort((a, b) => a.id.compareTo(b.id));
    return batsmen;
  }

  static Future<void> initializeDefaultBatsmen(Box<BatsmanModel> box) async {
    if (box.isEmpty) {
      await box.add(BatsmanModel.create(
        name: 'Hari',
        batsmanBox: box,
      ));
      await box.add(BatsmanModel.create(
        name: 'Berry',
        batsmanBox: box,
      ));
      await box.add(BatsmanModel.create(
        name: 'Gautham',
        batsmanBox: box,
      ));
      await box.add(BatsmanModel.create(
        name: 'Martial',
        batsmanBox: box,
      ));
    }
  }
}