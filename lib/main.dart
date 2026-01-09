import 'package:flutter/material.dart';
import 'services/hive_service.dart';
import 'Screens/cricket_scorer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive through service
  await HiveService.init();
  final box = HiveService.getBatsmanBox();
print('Stored batsmen count: ${box.length}');
for (var i = 0; i < box.length; i++) {
  print('Batsman ${i + 1}: ${box.getAt(i)?.name}');
}
  
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