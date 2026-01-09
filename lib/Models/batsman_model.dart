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

  BatsmanModel({
    required this.name,
    this.runs = 0,
    this.balls = 0,
    this.fours = 0,
    this.sixes = 0,
    this.strikeRate = 0.0,
  });

  void updateStats(int runsScored) {
    runs += runsScored;
    balls++;
    if (runsScored == 4) fours++;
    if (runsScored == 6) sixes++;
    strikeRate = balls > 0 ? (runs * 100.0 / balls) : 0.0;
    save();
  }
}