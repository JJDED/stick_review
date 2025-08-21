import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stick_review.dart';
import 'review_list_page.dart';
import 'review_detail_page.dart';
import 'location_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<StickReview> _reviews = [];
  StickReview? _randomReview;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('reviews');
    List<StickReview> loadedReviews = [];

    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      loadedReviews = decoded.map((e) => StickReview.fromJson(e)).toList();
    }

    StickReview? randomReview;
    if (loadedReviews.isNotEmpty) {
      final randomIndex = Random().nextInt(loadedReviews.length);
      randomReview = loadedReviews[randomIndex];
    }

    setState(() {
      _reviews = loadedReviews;
      _randomReview = randomReview;
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Hvis ingen reviews er tilgængelige
    if (_reviews.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Ingen anmeldelser endnu")),
      );
    }

    final pages = [
      // Single view med random review
      ReviewDetailPage(
        allReviews: _reviews,
        initialReview: _randomReview ?? _reviews.first,
      ),
      // Listevisning
      ReviewListPage(reviews: _reviews),
      // Location
      LocationPage(reviews: _reviews),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Single",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Liste",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "Location",
          ),
        ],
      ),
    );
  }
}
