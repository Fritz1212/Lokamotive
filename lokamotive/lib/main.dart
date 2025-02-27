import 'package:flutter/material.dart';
import 'pages/schedule1.dart';
import 'pages/schedule2.dart';
import 'pages/schedule3.dart';
import 'pages/schedule4.dart';
import 'pages/schedule5.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Schedule5(),
    );
  }
}



