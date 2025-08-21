import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import '../models/stick_review.dart';
import '../widgets/star_display.dart';

class ReviewDetailPage extends StatefulWidget {
  final List<StickReview> allReviews;
  final StickReview initialReview;

  const ReviewDetailPage({
    super.key,
    required this.allReviews,
    required this.initialReview,
  });

  @override
  State<ReviewDetailPage> createState() => _ReviewDetailPageState();
}

class _ReviewDetailPageState extends State<ReviewDetailPage> {
  late StickReview currentReview;
  ShakeDetector? detector;

  @override
  void initState() {
    super.initState();
    currentReview = widget.initialReview;

    // Start shake detection (opdateret til Shake 3.0.0)
    detector = ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent event) {
        _showRandomReview();
      },
    );
  }

  void _showRandomReview() {
    if (widget.allReviews.isEmpty) return;
    final random = Random();
    StickReview newReview;

    do {
      newReview = widget.allReviews[random.nextInt(widget.allReviews.length)];
    } while (newReview == currentReview && widget.allReviews.length > 1);

    setState(() {
      currentReview = newReview;
    });
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stick Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currentReview.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                StarDisplay(rating: currentReview.rating),
                const SizedBox(height: 12),
                Text(
                  currentReview.review,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (currentReview.imagePath != null)
                  Image.file(File(currentReview.imagePath!), height: 250),
                const SizedBox(height: 40),
                const Text(
                  "Ryst telefonen for at se en tilfældig anmeldelse 🎲",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
