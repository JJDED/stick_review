import 'package:flutter/material.dart';
import 'review_list_page.dart';
import 'review_detail_page.dart';
import 'location_page.dart';
import '../models/stick_review.dart';

class HomePage extends StatefulWidget {
  final List<StickReview> reviews;

  const HomePage({super.key, required this.reviews});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      // Single view (viser første review eller tekst hvis ingen)
      widget.reviews.isNotEmpty
          ? ReviewDetailPage(
              allReviews: widget.reviews,
              initialReview: widget.reviews.first,
            )
          : const Center(child: Text("Ingen anmeldelser endnu")),
      // Listevisning
      ReviewListPage(reviews: widget.reviews),
      // Location
      LocationPage(reviews: widget.reviews),
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
