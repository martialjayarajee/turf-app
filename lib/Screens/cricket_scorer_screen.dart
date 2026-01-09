import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Models/batsman_model.dart';
import '../Models/bowler_model.dart';
import '../Models/score_model.dart';
import '../services/hive_service.dart';
import '../widgets/score_card_widget.dart';
import '../widgets/batsman_stats_widget.dart';
import '../widgets/bowler_stats_widget.dart';
import '../widgets/current_over_widget.dart';
import '../widgets/run_button_widget.dart';

class CricketScorerScreen extends StatefulWidget {
  const CricketScorerScreen({Key? key}) : super(key: key);

  @override
  State<CricketScorerScreen> createState() => _CricketScorerScreenState();
}

class _CricketScorerScreenState extends State<CricketScorerScreen> {
  late Box<BatsmanModel> batsmanBox;
  late Box<BowlerModel> bowlerBox;
  late Box<ScoreModel> scoreBox;
  late ScoreModel scoreModel;
  bool isInitializing = true;

  @override
  void initState() {
    super.initState();
    batsmanBox = HiveService.getBatsmanBox();
    bowlerBox = HiveService.getBowlerBox();
    scoreBox = HiveService.getScoreBox();
    scoreModel = HiveService.getOrCreateScore();
    _initializePlayersIfNeeded();
  }

 Future<void> _initializePlayersIfNeeded() async {
  if (batsmanBox.isEmpty) {
    await batsmanBox.add(BatsmanModel.create(
      name: 'Hari',
      batsmanBox: batsmanBox,
    ));
    await batsmanBox.add(BatsmanModel.create(
      name: 'Berry',
      batsmanBox: batsmanBox,
    ));
    await batsmanBox.add(BatsmanModel.create(
      name: 'Gautham',
      batsmanBox: batsmanBox,
    ));
    await batsmanBox.add(BatsmanModel.create(
      name: 'Martial',
      batsmanBox: batsmanBox,
    ));
  }

  if (bowlerBox.isEmpty) {
    await bowlerBox.add(BowlerModel(
      name: 'Starc',
    ));
    await bowlerBox.add(BowlerModel(
      name: 'Wood',
    ));
  }

  // IMPORTANT: Initialize scoreModel with correct indices
  // Striker = 0, Non-Striker = 1, Next = 2
  if (scoreModel.strikeBatsmanIndex == scoreModel.nonStrikeBatsmanIndex) {
    scoreModel.strikeBatsmanIndex = 0;
    scoreModel.nonStrikeBatsmanIndex = 1;
    scoreModel.nextBatsmanIndex = 2;
    scoreModel.updateScore(
      strikeBatsmanIndex: 0,
      nonStrikeBatsmanIndex: 1,
      nextBatsmanIndex: 2,
    );
  }

  setState(() {
    isInitializing = false;
  });
}

  BowlerModel? get currentBowler {
    if (bowlerBox.isEmpty) return null;
    return bowlerBox.getAt(scoreModel.currentBowlerIndex);
  }

  void addRuns(int runs) {
    setState(() {
      var batsman = batsmanBox.getAt(scoreModel.strikeBatsmanIndex);
      if (batsman != null) {
        batsman.updateStats(runs);
      }

      if (currentBowler != null) {
        currentBowler!.updateStats(runs, false);
      }

      int overIndex = scoreModel.currentBall % 6;
      scoreModel.currentOver[overIndex] = runs.toString();

      _updateOverTracking();
      scoreModel.totalRuns += runs;

      double crr = scoreModel.overs > 0 ? (scoreModel.totalRuns / scoreModel.overs) : 0.0;

      if (scoreModel.currentBall % 6 == 0) {
        if (runs % 2 == 0) {
          _switchStrike();
        }
        
        _changeBowler();
        _resetCurrentOver();
      } else if (runs % 2 == 1) {
        _switchStrike();
      }

      scoreModel.updateScore(
        totalRuns: scoreModel.totalRuns,
        currentBall: scoreModel.currentBall,
        overs: scoreModel.overs,
        crr: crr,
        strikeBatsmanIndex: scoreModel.strikeBatsmanIndex,
        nonStrikeBatsmanIndex: scoreModel.nonStrikeBatsmanIndex,
        currentBowlerIndex: scoreModel.currentBowlerIndex,
        currentOver: scoreModel.currentOver,
      );
    });
  }

  void addWicket() {
  setState(() {
    // Mark the current striker as out
    var outBatsman = batsmanBox.getAt(scoreModel.strikeBatsmanIndex);
    if (outBatsman != null) {
      outBatsman.markAsOut();
    }

    scoreModel.wickets++;
    
    if (currentBowler != null) {
      currentBowler!.updateStats(0, true);
    }

    int overIndex = scoreModel.currentBall % 6;
    scoreModel.currentOver[overIndex] = 'W';

    _updateOverTracking();

    // Find the next available batsman who is NOT out and NOT currently batting
    int newBatsmanIndex = -1;
    
    for (int i = 0; i < batsmanBox.length; i++) {
      var batsman = batsmanBox.getAt(i);
      if (batsman != null && 
          !batsman.isOut && 
          i != scoreModel.strikeBatsmanIndex && 
          i != scoreModel.nonStrikeBatsmanIndex) {
        newBatsmanIndex = i;
        break;
      }
    }

    if (newBatsmanIndex != -1) {
      // Replace the OUT striker with the new batsman
      // The non-striker remains the same
      scoreModel.strikeBatsmanIndex = newBatsmanIndex;
      
      // Update nextBatsmanIndex to the next available player after this one
      scoreModel.nextBatsmanIndex = newBatsmanIndex + 1;
      
      print('Wicket! New batsman at index $newBatsmanIndex');
      print('Striker: ${batsmanBox.getAt(scoreModel.strikeBatsmanIndex)?.name}');
      print('Non-Striker: ${batsmanBox.getAt(scoreModel.nonStrikeBatsmanIndex)?.name}');
    } else {
      // All out - no more batsmen
      print('All Out! No more batsmen available');
      _showAllOutDialog();
    }

    // Handle end of over
    if (scoreModel.currentBall % 6 == 0) {
      _changeBowler();
      _resetCurrentOver();
      // After over completion, swap strike between remaining batsmen
      _switchStrike();
    }

    scoreModel.updateScore(
      wickets: scoreModel.wickets,
      currentBall: scoreModel.currentBall,
      overs: scoreModel.overs,
      strikeBatsmanIndex: scoreModel.strikeBatsmanIndex,
      nonStrikeBatsmanIndex: scoreModel.nonStrikeBatsmanIndex,
      nextBatsmanIndex: scoreModel.nextBatsmanIndex,
      currentBowlerIndex: scoreModel.currentBowlerIndex,
      currentOver: scoreModel.currentOver,
    );
  });
}

  void _showAllOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Out!'),
        content: Text('Team is all out for ${scoreModel.totalRuns} runs in ${scoreModel.overs} overs'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void addExtras() {
    setState(() {
      scoreModel.totalRuns += 1;
      
      double crr = scoreModel.overs > 0 ? (scoreModel.totalRuns / scoreModel.overs) : 0.0;
      
      scoreModel.updateScore(
        totalRuns: scoreModel.totalRuns,
        crr: crr,
      );
    });
  }

  void swapPlayers() {
    setState(() {
      _switchStrike();
      scoreModel.updateScore(
        strikeBatsmanIndex: scoreModel.strikeBatsmanIndex,
        nonStrikeBatsmanIndex: scoreModel.nonStrikeBatsmanIndex,
      );
    });
  }

  void undoLastBall() {
  setState(() {
    if (scoreModel.currentBall > 0) {
      bool wasFirstBallOfOver = scoreModel.currentBall % 6 == 0;
      
      int overIndex = (scoreModel.currentBall - 1) % 6;
      String lastBallValue = scoreModel.currentOver[overIndex];
      
      if (currentBowler != null) {
        if (lastBallValue == 'W') {
          currentBowler!.undoBall(0, true);
          scoreModel.wickets--;
          
          // Find the most recently added batsman and restore the previous striker
          if (scoreModel.nextBatsmanIndex > 2) {
            int restoredBatsmanIndex = scoreModel.nextBatsmanIndex - 1;
            
            // The current striker is the one who just came in - remove them from batting
            // Find the batsman who was out and restore them as striker
            for (int i = batsmanBox.length - 1; i >= 0; i--) {
              var batsman = batsmanBox.getAt(i);
              if (batsman != null && batsman.isOut) {
                batsman.markAsNotOut();
                scoreModel.strikeBatsmanIndex = i;
                scoreModel.nextBatsmanIndex = restoredBatsmanIndex;
                print('Undo wicket: Restored ${batsman.name} as striker');
                break;
              }
            }
          }
        } else if (lastBallValue.isNotEmpty && int.tryParse(lastBallValue) != null) {
          int lastRuns = int.parse(lastBallValue);
          currentBowler!.undoBall(lastRuns, false);
          scoreModel.totalRuns -= lastRuns;
          
          // Undo batsman stats
          var batsman = batsmanBox.getAt(scoreModel.strikeBatsmanIndex);
          if (batsman != null) {
            batsman.undoStats(lastRuns);
          }
        }
      }
      
      scoreModel.currentBall--;
      
      int completedOvers = scoreModel.currentBall ~/ 6;
      int ballsInCurrentOver = scoreModel.currentBall % 6;
      scoreModel.overs = completedOvers + (ballsInCurrentOver / 10.0);
      
      overIndex = scoreModel.currentBall % 6;
      scoreModel.currentOver[overIndex] = '';

      if (wasFirstBallOfOver) {
        if (lastBallValue.isNotEmpty && 
            lastBallValue != 'W' && 
            int.tryParse(lastBallValue) != null) {
          int lastRuns = int.parse(lastBallValue);
          if (lastRuns % 2 == 0) {
            _switchStrike();
          }
        }
        _changeBowlerBack();
      } else if (lastBallValue.isNotEmpty && 
                 lastBallValue != 'W' && 
                 int.tryParse(lastBallValue) != null) {
        int lastRuns = int.parse(lastBallValue);
        if (lastRuns % 2 == 1) {
          _switchStrike();
        }
      }
      
      double crr = scoreModel.overs > 0 ? (scoreModel.totalRuns / scoreModel.overs) : 0.0;
      
      scoreModel.updateScore(
        totalRuns: scoreModel.totalRuns,
        wickets: scoreModel.wickets,
        currentBall: scoreModel.currentBall,
        overs: scoreModel.overs,
        crr: crr,
        strikeBatsmanIndex: scoreModel.strikeBatsmanIndex,
        nonStrikeBatsmanIndex: scoreModel.nonStrikeBatsmanIndex,
        nextBatsmanIndex: scoreModel.nextBatsmanIndex,
        currentBowlerIndex: scoreModel.currentBowlerIndex,
        currentOver: scoreModel.currentOver,
      );
    }
  });
}

  void _updateOverTracking() {
    scoreModel.currentBall++;
    int completedOvers = scoreModel.currentBall ~/ 6;
    int ballsInCurrentOver = scoreModel.currentBall % 6;
    scoreModel.overs = completedOvers + (ballsInCurrentOver / 10.0);
  }

  void _switchStrike() {
    int temp = scoreModel.strikeBatsmanIndex;
    scoreModel.strikeBatsmanIndex = scoreModel.nonStrikeBatsmanIndex;
    scoreModel.nonStrikeBatsmanIndex = temp;
  }

  void _changeBowler() {
    if (bowlerBox.isNotEmpty) {
      scoreModel.currentBowlerIndex = (scoreModel.currentBowlerIndex + 1) % bowlerBox.length;
      print('Bowler changed to: ${currentBowler?.name}');
    }
  }

  void _changeBowlerBack() {
    if (bowlerBox.isNotEmpty) {
      scoreModel.currentBowlerIndex = (scoreModel.currentBowlerIndex - 1 + bowlerBox.length) % bowlerBox.length;
      print('Bowler changed back to: ${currentBowler?.name}');
    }
  }

  void _resetCurrentOver() {
    scoreModel.currentOver = ['', '', '', '', '', ''];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: _buildAppBar(),
      body: ValueListenableBuilder(
        valueListenable: scoreBox.listenable(),
        builder: (context, Box<ScoreModel> box, _) {
          final score = box.isNotEmpty ? box.getAt(0)! : scoreModel;
          
          return ValueListenableBuilder(
            valueListenable: batsmanBox.listenable(),
            builder: (context, Box<BatsmanModel> bBox, _) {
              return ValueListenableBuilder(
                valueListenable: bowlerBox.listenable(),
                builder: (context, Box<BowlerModel> bowBox, _) {
                  if (isInitializing) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1a8b8b),
                      ),
                    );
                  }

                  if (bBox.isEmpty || bowBox.isEmpty) {
                    return const Center(
                      child: Text(
                        'No players found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Score Board',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          ScoreCardWidget(
                            totalRuns: score.totalRuns,
                            wickets: score.wickets,
                            overs: score.overs,
                            crr: score.crr,
                            nrr: score.nrr,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          BatsmanStatsWidget(
                            batsmanBox: bBox,
                            strikeBatsmanIndex: score.strikeBatsmanIndex,
                            nonStrikeBatsmanIndex: score.nonStrikeBatsmanIndex,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          BowlerStatsWidget(
                            bowlerBox: bowBox,
                            currentBowlerIndex: score.currentBowlerIndex,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          CurrentOverWidget(currentOver: score.currentOver),
                          
                          const SizedBox(height: 24),
                          
                          _buildRunButtons(),
                          
                          const SizedBox(height: 16),
                          
                          _buildWicketButton(),
                          
                          const SizedBox(height: 16),
                          
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0f0f1e),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Score Board',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Row(
            children: const [
              Text(
                'Cricket ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Scorer',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.history), onPressed: () {}),
              IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRunButtons() {
    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RunButton(run: '4', height: 80, onPressed: () => addRuns(4)),
          RunButton(run: '3', height: 100, onPressed: () => addRuns(3)),
          RunButton(run: '1', height: 120, onPressed: () => addRuns(1)),
          RunButton(run: '0', height: 140, onPressed: () => addRuns(0)),
          RunButton(run: '2', height: 110, onPressed: () => addRuns(2)),
          RunButton(run: '5', height: 90, onPressed: () => addRuns(5)),
          RunButton(run: '6', height: 70, onPressed: () => addRuns(6)),
        ],
      ),
    );
  }

  Widget _buildWicketButton() {
    return ElevatedButton(
      onPressed: addWicket,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1a8b8b),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: const Text('Wicket', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: addExtras,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1a8b8b),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text('Extras'),
        ),
        ElevatedButton(
          onPressed: swapPlayers,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1a8b8b),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text('Swap Player'),
        ),
        ElevatedButton(
          onPressed: undoLastBall,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1a8b8b),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text('Undo'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}