import 'package:flutter/material.dart';
import 'models/stick_review.dart';
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
  // Midlertidig liste med testdata
  final List<StickReview> _reviews = [
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sticktok',
      theme: ThemeData(
        useMaterial3: true, // Material 3
        primarySwatch: Colors.teal, // Primærfarve
        scaffoldBackgroundColor: Colors.grey[100], // Lys baggrund
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: HomePage(reviews: _reviews),
    );
  }
}
