import 'package:hive/hive.dart';

part 'bowler_model.g.dart';

@HiveType(typeId: 1)
class BowlerModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int runs;

  @HiveField(2)
  int wickets;

  @HiveField(3)
  double overs;

  @HiveField(4)
  double economy;

  @HiveField(5)
  int balls;

  BowlerModel({
    required this.name,
    this.runs = 0,
    this.wickets = 0,
    this.overs = 0.0,
    this.economy = 0.0,
    this.balls = 0,
  });

  void updateStats(int runsScored, bool isWicket) {
    runs += runsScored;
    if (isWicket) {
      wickets++;
    }
    balls++;
    _calculateOvers();
    _calculateEconomy();
    save();
  }

  void undoBall(int runsScored, bool wasWicket) {
    runs -= runsScored;
    if (wasWicket) {
      wickets--;
    }
    if (balls > 0) {
      balls--;
    }
    _calculateOvers();
    _calculateEconomy();
    save();
  }

  void _calculateOvers() {
    // Only count completed overs (whole numbers)
    int completedOvers = balls ~/ 6;
    overs = completedOvers.toDouble();
  }

  void _calculateEconomy() {
    economy = overs > 0 ? (runs / overs) : 0.0;
  }
}