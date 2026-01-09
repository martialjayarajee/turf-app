import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/batsman_model.dart';
import '../models/bowler_model.dart';
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
  
  // Match state
  int totalRuns = 0;
  int wickets = 0;
  double overs = 0.0;
  double crr = 0.0;
  double nrr = 7.09;

  // Current bowling bowler index
  int currentBowlerIndex = 0;

  List<String> currentOver = ['', '', '', '', '', ''];
  int strikeBatsmanIndex = 0;
  int currentBall = 0;

  @override
  void initState() {
    super.initState();
    batsmanBox = HiveService.getBatsmanBox();
    bowlerBox = HiveService.getBowlerBox();
  }

  // Get the current bowler
  BowlerModel? get currentBowler {
    if (bowlerBox.isEmpty) return null;
    return bowlerBox.getAt(currentBowlerIndex);
  }

  void addRuns(int runs) {
    setState(() {
      totalRuns += runs;

      // Update batsman stats
      var batsman = batsmanBox.getAt(strikeBatsmanIndex);
      if (batsman != null) {
        batsman.updateStats(runs);
      }

      // Update current bowler stats
      if (currentBowler != null) {
        currentBowler!.updateStats(runs, false);
      }

      // Update current over display BEFORE updating ball count
      int overIndex = currentBall % 6;
      currentOver[overIndex] = runs.toString();

      // Update over tracking
      _updateOverTracking();

      // Calculate CRR
      crr = overs > 0 ? (totalRuns / overs) : 0.0;

      // Check if over is completed (6 balls)
      if (currentBall % 6 == 0) {
        // Over completed
        if (runs % 2 == 0) {
          // Even runs - swap strike for next over
          _switchStrike();
        }
        
        _changeBowler();
        _resetCurrentOver();
      } else if (runs % 2 == 1) {
        // Odd runs mid-over - swap strike
        _switchStrike();
      }
    });
  }

  void addWicket() {
    setState(() {
      wickets++;
      
      if (currentBowler != null) {
        currentBowler!.updateStats(0, true);
      }

      int overIndex = currentBall % 6;
      currentOver[overIndex] = 'W';

      // Update over tracking
      _updateOverTracking();

      // Check if over is completed after wicket
      if (currentBall % 6 == 0) {
        _changeBowler();
        _resetCurrentOver();
      }
    });
  }

  void addExtras() {
    setState(() {
      totalRuns += 1;
      
      // Extras don't count as a ball, so don't update over tracking
      // Just recalculate CRR
      crr = overs > 0 ? (totalRuns / overs) : 0.0;
    });
  }

  void swapPlayers() {
    setState(() {
      _switchStrike();
    });
  }

  void undoLastBall() {
    setState(() {
      if (currentBall > 0) {
        bool wasFirstBallOfOver = currentBall % 6 == 0;
        
        int overIndex = (currentBall - 1) % 6;
        String lastBallValue = currentOver[overIndex];
        
        // Undo bowler stats
        if (currentBowler != null) {
          if (lastBallValue == 'W') {
            currentBowler!.undoBall(0, true);
            wickets--;
          } else if (lastBallValue.isNotEmpty && int.tryParse(lastBallValue) != null) {
            int lastRuns = int.parse(lastBallValue);
            currentBowler!.undoBall(lastRuns, false);
            totalRuns -= lastRuns;
          }
        }
        
        currentBall--;
        
        // Recalculate overs based on current ball count
        int completedOvers = currentBall ~/ 6;
        int ballsInCurrentOver = currentBall % 6;
        overs = completedOvers + (ballsInCurrentOver / 10.0);
        
        overIndex = currentBall % 6;
        currentOver[overIndex] = '';

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
        
        // Recalculate CRR
        crr = overs > 0 ? (totalRuns / overs) : 0.0;
      }
    });
  }

  void _updateOverTracking() {
    currentBall++;
    int completedOvers = currentBall ~/ 6;
    int ballsInCurrentOver = currentBall % 6;
    overs = completedOvers + (ballsInCurrentOver / 10.0);
  }

  void _switchStrike() {
    strikeBatsmanIndex = strikeBatsmanIndex == 0 ? 1 : 0;
  }

  void _changeBowler() {
    // Rotate to next bowler
    if (bowlerBox.isNotEmpty) {
      currentBowlerIndex = (currentBowlerIndex + 1) % bowlerBox.length;
      print('Bowler changed to: ${currentBowler?.name}');
    }
  }

  void _changeBowlerBack() {
    // Go back to previous bowler (for undo functionality)
    if (bowlerBox.isNotEmpty) {
      currentBowlerIndex = (currentBowlerIndex - 1 + bowlerBox.length) % bowlerBox.length;
      print('Bowler changed back to: ${currentBowler?.name}');
    }
  }

  void _resetCurrentOver() {
    currentOver = ['', '', '', '', '', ''];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: _buildAppBar(),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<BatsmanModel>(HiveService.batsmanBoxName).listenable(),
        builder: (context, Box<BatsmanModel> batsmanBox, _) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<BowlerModel>(HiveService.bowlerBoxName).listenable(),
            builder: (context, Box<BowlerModel> bowlerBox, _) {
              if (batsmanBox.isEmpty || bowlerBox.isEmpty) {
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
                        totalRuns: totalRuns,
                        wickets: wickets,
                        overs: overs,
                        crr: crr,
                        nrr: nrr,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      BatsmanStatsWidget(
                        batsmanBox: batsmanBox,
                        strikeBatsmanIndex: strikeBatsmanIndex,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      BowlerStatsWidget(
                        bowlerBox: bowlerBox,
                        currentBowlerIndex: currentBowlerIndex,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      CurrentOverWidget(currentOver: currentOver),
                      
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