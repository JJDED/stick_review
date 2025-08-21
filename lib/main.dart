import 'package:flutter/material.dart';
import 'pages/review_list_page.dart';

void main() {
  runApp(const StickReviewApp());
}

class StickReviewApp extends StatelessWidget {
  const StickReviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stick Review',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const ReviewListPage(),
    );
  }
}