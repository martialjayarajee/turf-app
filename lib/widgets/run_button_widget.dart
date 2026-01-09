import 'package:flutter/material.dart';

class RunButton extends StatelessWidget {
  final String run;
  final double height;
  final VoidCallback onPressed;

  const RunButton({
    Key? key,
    required this.run,
    required this.height,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4a5fc9), Color(0xFF6b7fd9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            run,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}