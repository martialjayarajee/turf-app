import 'package:flutter/material.dart';

class ScoreCardWidget extends StatelessWidget {
  final int totalRuns;
  final int wickets;
  final double overs;
  final double crr;
  final double nrr;

  const ScoreCardWidget({
    Key? key,
    required this.totalRuns,
    required this.wickets,
    required this.overs,
    required this.crr,
    required this.nrr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a3e),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'IND',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'CRR : ${crr.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'NRR : ${nrr.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$totalRuns-$wickets',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '(${overs.toStringAsFixed(1)})',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}