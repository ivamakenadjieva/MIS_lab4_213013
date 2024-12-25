import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/exam_calendar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Calendar',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ExamCalendarScreen(),
    );
  }
}




