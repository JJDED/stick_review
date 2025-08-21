import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stick_review.dart';
import 'add_review_page.dart';
import '../widgets/star_display.dart';

class ReviewListPage extends StatefulWidget {
  const ReviewListPage({super.key});

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  List<StickReview> reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('reviews');
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      setState(() {
        reviews = decoded.map((e) => StickReview.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(reviews.map((r) => r.toJson()).toList());
    await prefs.setString('reviews', jsonString);
  }

  void _addReview(StickReview review) {
    setState(() {
      reviews.add(review);
    });
    _saveReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stick Reviews')),
      body: reviews.isEmpty
          ? const Center(child: Text('Ingen anmeldelser endnu.'))
          : ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final r = reviews[index];
                return ListTile(
                  title: Text(r.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.review),
                      StarDisplay(rating: r.rating),
                      if (r.imagePath != null) ...[
                        const SizedBox(height: 8),
                        Image.file(File(r.imagePath!), height: 100),
                      ],
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newReview = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddReviewPage(),
            ),
          );

          if (newReview != null && newReview is StickReview) {
            _addReview(newReview);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
