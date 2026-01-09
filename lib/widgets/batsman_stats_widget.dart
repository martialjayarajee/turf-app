import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/batsman_model.dart';

class BatsmanStatsWidget extends StatelessWidget {
  final Box<BatsmanModel> batsmanBox;
  final int strikeBatsmanIndex;

  const BatsmanStatsWidget({
    Key? key,
    required this.batsmanBox,
    required this.strikeBatsmanIndex,
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
                  'Batsman',
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
                  'B',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '4s',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '6s',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  'SR',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey),
          ...List.generate(batsmanBox.length, (index) {
            var batsman = batsmanBox.getAt(index);
            if (batsman == null) return const SizedBox();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      batsman.name + (index == strikeBatsmanIndex ? '*' : ''),
                      style: TextStyle(
                        fontWeight: index == strikeBatsmanIndex
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${batsman.runs}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${batsman.balls}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${batsman.fours}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${batsman.sixes}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      batsman.strikeRate.toStringAsFixed(1),
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