import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const FieldVisitLoggerApp());
}

class FieldVisitLoggerApp extends StatelessWidget {
  const FieldVisitLoggerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Visit Logger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginScreen(),
    );
  }
}
