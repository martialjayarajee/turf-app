import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Models/bowler_model.dart';

class BowlerStatsWidget extends StatelessWidget {
  final Box<BowlerModel> bowlerBox;
  final int currentBowlerIndex;

  const BowlerStatsWidget({
    Key? key,
    required this.bowlerBox,
    required this.currentBowlerIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a3e),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Bowler',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  'O',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  'R',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  'W',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  'ER',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey),
          ...List.generate(bowlerBox.length, (index) {
            var bowler = bowlerBox.getAt(index);
            if (bowler == null) return const SizedBox();

            bool isCurrentBowler = index == currentBowlerIndex;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      bowler.name + (isCurrentBowler ? ' *' : ''),
                      style: TextStyle(
                        fontWeight: isCurrentBowler
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCurrentBowler ? Colors.greenAccent : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${bowler.overs.toInt()}', // Display as whole number
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${bowler.runs}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${bowler.wickets}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      bowler.economy.toStringAsFixed(1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}