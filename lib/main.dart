import 'package:flutter/material.dart';
import 'services/hive_service.dart';
import 'screens/cricket_scorer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive through service
  await HiveService.init();
  
  runApp(const CricketScorerApp());
}

class CricketScorerApp extends StatelessWidget {
  const CricketScorerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket Scorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const CricketScorerScreen(),
    );
  }
}