import 'package:flutter/material.dart';

class CurrentOverWidget extends StatelessWidget {
  final List<String> currentOver;

  const CurrentOverWidget({
    Key? key,
    required this.currentOver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'This Over',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: currentOver.map((ball) {
            Color ballColor = _getBallColor(ball);

            return Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: ballColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  ball,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getBallColor(String ball) {
    if (ball == 'W') {
      return Colors.red;
    } else if (ball == '4' || ball == '6') {
      return Colors.green;
    } else if (ball == '0') {
      return const Color(0xFF3a3a4e);
    } else if (ball.isEmpty) {
      return Colors.grey.shade700;
    } else {
      return Colors.grey.shade600;
    }
  }
}