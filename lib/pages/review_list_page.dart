import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/stick_review.dart';
import 'add_review_page.dart';
import 'review_detail_page.dart';
import '../widgets/star_display.dart';

class ReviewListPage extends StatefulWidget {
  final List<StickReview> reviews;

  const ReviewListPage({super.key, required this.reviews});

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
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
        widget.reviews
          ..clear()
          ..addAll(decoded.map((e) => StickReview.fromJson(e)));
      });
    }
  }

  Future<void> _saveReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(widget.reviews.map((r) => r.toJson()).toList());
    await prefs.setString('reviews', jsonString);
  }

  void _addReview(StickReview review) {
    setState(() {
      widget.reviews.add(review);
    });
    _saveReviews();
  }

  void _deleteReview(int index) {
    setState(() {
      widget.reviews.removeAt(index);
    });
    _saveReviews();
  }

  void _editReview(int index, StickReview updated) {
    setState(() {
      widget.reviews[index] = updated;
    });
    _saveReviews();
  }

Color _ratingColor(int rating) {
  switch (rating) {
    case 1:
      return Colors.red; // eksisterende rød
    case 2:
      return Colors.orange; // orange
    case 3:
      return Colors.amber; // eksisterende gul
    case 4:
      return Colors.lightGreen; // lysegrøn
    case 5:
      return Colors.green; // eksisterende grøn
    default:
      return Colors.grey;
  }
}

  @override
  Widget build(BuildContext context) {
    final reviews = widget.reviews;

    return Scaffold(
      appBar: AppBar(title: const Text('Stick Reviews')),
      body: reviews.isEmpty
          ? const Center(child: Text('Ingen anmeldelser endnu.'))
          : ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final r = reviews[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(r.review),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            StarDisplay(rating: r.rating, color: _ratingColor(r.rating)),
                            const SizedBox(width: 8),
                            Text('${r.rating}/5', style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                        if (r.location != null && r.location!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.black54),
                                const SizedBox(width: 4),
                                Flexible(child: Text(r.location!, style: const TextStyle(color: Colors.black54))),
                              ],
                            ),
                          ),
                        if (r.imagePath != null) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(r.imagePath!), height: 100, fit: BoxFit.cover),
                          ),
                        ],
                        Align(
                          alignment: Alignment.centerRight,
                          child: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'delete') {
                                _deleteReview(index);
                              } else if (value == 'edit') {
                                final updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddReviewPage(existingReview: r),
                                  ),
                                );
                                if (updated != null && updated is StickReview) {
                                  _editReview(index, updated);
                                }
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Rediger'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Slet'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
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
