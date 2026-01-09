import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Models/batsman_model.dart';

class BatsmanStatsWidget extends StatelessWidget {
  final Box<BatsmanModel> batsmanBox;
  final int strikeBatsmanIndex;
  final int nonStrikeBatsmanIndex;

  const BatsmanStatsWidget({
    Key? key,
    required this.batsmanBox,
    required this.strikeBatsmanIndex,
    required this.nonStrikeBatsmanIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Defensive check - make sure indices are different
    if (strikeBatsmanIndex == nonStrikeBatsmanIndex) {
      print('WARNING: Striker and Non-Striker are the same! Index: $strikeBatsmanIndex');
    }
    
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
          
          // Always show current striker first
          _buildBatsmanRow(strikeBatsmanIndex, true),
          
          // Show non-striker only if different from striker
          if (nonStrikeBatsmanIndex != strikeBatsmanIndex)
            _buildBatsmanRow(nonStrikeBatsmanIndex, false),
          
          // Show all out batsmen below
          ...List.generate(batsmanBox.length, (index) {
            var batsman = batsmanBox.getAt(index);
            if (batsman == null) return const SizedBox();
            
            // Skip if this is current striker or non-striker
            if (index == strikeBatsmanIndex || index == nonStrikeBatsmanIndex) {
              return const SizedBox();
            }
            
            // Only show if they are out
            if (!batsman.isOut) {
              return const SizedBox();
            }
            
            return _buildBatsmanRow(index, false);
          }),
        ],
      ),
    );
  }

  Widget _buildBatsmanRow(int index, bool isStriker) {
    var batsman = batsmanBox.getAt(index);
    if (batsman == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              batsman.name + 
              (isStriker ? '*' : '') + 
              (batsman.isOut ? ' (Out)' : ''),
              style: TextStyle(
                fontWeight: isStriker ? FontWeight.bold : FontWeight.normal,
                color: batsman.isOut ? Colors.grey : Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${batsman.runs}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: batsman.isOut ? Colors.grey : Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${batsman.balls}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: batsman.isOut ? Colors.grey : Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${batsman.fours}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: batsman.isOut ? Colors.grey : Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${batsman.sixes}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: batsman.isOut ? Colors.grey : Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              batsman.strikeRate.toStringAsFixed(1),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: batsman.isOut ? Colors.grey : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}