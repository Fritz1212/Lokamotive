import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyScreen(),
    );
  }
}

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int? _selectedValue = 1; // Default selected value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListTile(
          leading: Radio<int>(
            value: 1,
            groupValue: _selectedValue,
            onChanged: (int? value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
          title: Text(
            '1 Hari ini',
            style: TextStyle(fontSize: 18), // Adjust font size
          ),
          onTap: () {
            setState(() {
              _selectedValue = 1;
            });
          },
        ),
      ),
    );
  }
}
