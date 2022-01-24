import 'package:flutter/material.dart';
import 'package:flutter_mentor_quiz_app_tut/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz  App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.compact,
        bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.transparent),    
        ),
      home: Home(),
    );
  }
}
