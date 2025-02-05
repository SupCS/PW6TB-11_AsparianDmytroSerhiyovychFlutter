import 'package:flutter/material.dart';
import 'screens/equipment_calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practice 6',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const EquipmentCalculatorScreen(),
    );
  }
}
