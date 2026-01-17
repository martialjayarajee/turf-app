import 'package:TURF_TOWN_/src/models/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'objectbox_helper.dart';

@Entity()
class MatchHistory {
  @Id()
  int id; // Auto-incremented by ObjectBox

  @Unique()
  String matchId; // Foreign key to match

  String teamAId; // Foreign key to team A
  String teamBId; // Foreign key to team B

  @Property(type: PropertyType.date) // FIXED: Explicitly define date type
  DateTime matchDate;
  
  String matchType; // e.g., 'CRICKET'

  int team1Runs;
  int team1Wickets;
  double team1Overs;

  int team2Runs;
  int team2Wickets;
  double team2Overs;

  String result; // e.g., 'Team A won by 5 wickets'
  bool isCompleted;

  MatchHistory({
    this.id = 0,
    required this.matchId,
    required this.teamAId,
    required this.teamBId,
    required this.matchDate,
    required this.matchType,
    required this.team1Runs,
    required this.team1Wickets,
    required this.team1Overs,
    required this.team2Runs,
    required this.team2Wickets,
    required this.team2Overs,
    required this.result,
    required this.isCompleted,
  });

  // Static methods for database operations

  /// Create a new match history
  static MatchHistory create({
    required String matchId,
    required String teamAId,
    required String teamBId,
    required DateTime matchDate,
    required String matchType,
    required int team1Runs,
    required int team1Wickets,
    required double team1Overs,
    required int team2Runs,
    required int team2Wickets,
    required double team2Overs,
    required String result,
    required bool isCompleted,
  }) {
    final matchHistory = MatchHistory(
      matchId: matchId,
      teamAId: teamAId,
      teamBId: teamBId,
      matchDate: matchDate,
      matchType: matchType,
      team1Runs: team1Runs,
      team1Wickets: team1Wickets,
      team1Overs: team1Overs,
      team2Runs: team2Runs,
      team2Wickets: team2Wickets,
      team2Overs: team2Overs,
      result: result,
      isCompleted: isCompleted,
    );

    ObjectBoxHelper.matchHistoryBox.put(matchHistory);
    return matchHistory;
  }

  /// Get all match histories
  static List<MatchHistory> getAll() {
    return ObjectBoxHelper.matchHistoryBox.getAll();
  }

  /// Get match history by matchId
  static MatchHistory? getByMatchId(String matchId) {
    final query = ObjectBoxHelper.matchHistoryBox
        .query(MatchHistory_.matchId.equals(matchId))
        .build();
    final matchHistory = query.findFirst();
    query.close();
    return matchHistory;
  }

  /// Get completed matches - ADDED: This method was missing
  static List<MatchHistory> getAllCompleted() {
    final query = ObjectBoxHelper.matchHistoryBox
        .query(MatchHistory_.isCompleted.equals(true))
        .order(MatchHistory_.matchDate, flags: Order.descending)
        .build();
    final matches = query.find();
    query.close();
    return matches;
  }

  /// Get completed matches (alias for backward compatibility)
  static List<MatchHistory> getCompletedMatches() {
    return getAllCompleted();
  }

  /// Get matches by team
  static List<MatchHistory> getMatchesByTeam(String teamId) {
    final query = ObjectBoxHelper.matchHistoryBox
        .query(MatchHistory_.teamAId.equals(teamId).or(MatchHistory_.teamBId.equals(teamId)))
        .build();
    final matches = query.find();
    query.close();
    return matches;
  }

  // Instance methods

  /// Save the current match history
  void save() {
    ObjectBoxHelper.matchHistoryBox.put(this);
  }

  /// Delete the current match history
  void delete() {
    ObjectBoxHelper.matchHistoryBox.remove(id);
  }
}