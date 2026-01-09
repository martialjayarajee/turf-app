import 'package:hive/hive.dart';

part 'score_model.g.dart';

@HiveType(typeId: 2)
class ScoreModel extends HiveObject {
  @HiveField(0)
  int totalRuns;

  @HiveField(1)
  int wickets;

  @HiveField(2)
  int currentBall;

  @HiveField(3)
  double overs;

  @HiveField(4)
  double crr;

  @HiveField(5)
  double nrr;

  @HiveField(6)
  int strikeBatsmanIndex;

  @HiveField(7)
  int currentBowlerIndex;

  @HiveField(8)
  List<String> currentOver;

  @HiveField(9)
  int nonStrikeBatsmanIndex;

  @HiveField(10)
  int nextBatsmanIndex;

  ScoreModel({
    this.totalRuns = 0,
    this.wickets = 0,
    this.currentBall = 0,
    this.overs = 0.0,
    this.crr = 0.0,
    this.nrr = 7.09,
    this.strikeBatsmanIndex = 0,
    this.currentBowlerIndex = 0,
    List<String>? currentOver,
    this.nonStrikeBatsmanIndex = 1,
    this.nextBatsmanIndex = 2,
  }) : currentOver = currentOver ?? ['', '', '', '', '', ''];

  void updateScore({
    int? totalRuns,
    int? wickets,
    int? currentBall,
    double? overs,
    double? crr,
    double? nrr,
    int? strikeBatsmanIndex,
    int? currentBowlerIndex,
    List<String>? currentOver,
    int? nonStrikeBatsmanIndex,
    int? nextBatsmanIndex,
  }) {
    if (totalRuns != null) this.totalRuns = totalRuns;
    if (wickets != null) this.wickets = wickets;
    if (currentBall != null) this.currentBall = currentBall;
    if (overs != null) this.overs = overs;
    if (crr != null) this.crr = crr;
    if (nrr != null) this.nrr = nrr;
    if (strikeBatsmanIndex != null) this.strikeBatsmanIndex = strikeBatsmanIndex;
    if (currentBowlerIndex != null) this.currentBowlerIndex = currentBowlerIndex;
    if (currentOver != null) this.currentOver = List<String>.from(currentOver);
    if (nonStrikeBatsmanIndex != null) this.nonStrikeBatsmanIndex = nonStrikeBatsmanIndex;
    if (nextBatsmanIndex != null) this.nextBatsmanIndex = nextBatsmanIndex;
    save();
  }

  void resetScore() {
    totalRuns = 0;
    wickets = 0;
    currentBall = 0;
    overs = 0.0;
    crr = 0.0;
    nrr = 7.09;
    strikeBatsmanIndex = 0;
    currentBowlerIndex = 0;
    currentOver = ['', '', '', '', '', ''];
    nonStrikeBatsmanIndex = 1;
    nextBatsmanIndex = 2;
    save();
  }
}