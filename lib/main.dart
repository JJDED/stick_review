import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const StickReviewApp());
}

class StickReviewApp extends StatefulWidget {
  const StickReviewApp({super.key});

  @override
  State<StickReviewApp> createState() => _StickReviewAppState();
}

class _StickReviewAppState extends State<StickReviewApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sticktok',
      theme: ThemeData(
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orangeAccent,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      ),
      home: const HomePage(), // <--- her er parameteren fjernet
    );
  }
}
