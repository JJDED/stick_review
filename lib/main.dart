import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

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

class StickReview {
  final String title;
  final String review;
  final int rating;
  final String? imagePath;

  StickReview({
    required this.title,
    required this.review,
    required this.rating,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'review': review,
        'rating': rating,
        'imagePath': imagePath,
      };

  factory StickReview.fromJson(Map<String, dynamic> json) {
    return StickReview(
      title: json['title'],
      review: json['review'],
      rating: json['rating'],
      imagePath: json['imagePath'],
    );
  }
}

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
    final jsonString =
        jsonEncode(reviews.map((r) => r.toJson()).toList());
    await prefs.setString('reviews', jsonString);
  }

  void _addReview(StickReview review) {
    setState(() {
      reviews.add(review);
    });
    _saveReviews();
  }

  Widget buildStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating) {
          return const Icon(Icons.star, color: Colors.amber, size: 20);
        } else {
          return const Icon(Icons.star_border, color: Colors.grey, size: 20);
        }
      }),
    );
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
                      buildStars(r.rating),
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

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({super.key});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _formKey = GlobalKey<FormState>();
  String title = "";
  String review = "";
  int rating = 3;
  String? imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imagePath = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tilføj anmeldelse")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Titel på pind"),
                  onSaved: (value) => title = value ?? "",
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "Indtast en titel" : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Din anmeldelse"),
                  onSaved: (value) => review = value ?? "",
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "Indtast en anmeldelse" : null,
                ),
                DropdownButtonFormField<int>(
                  value: rating,
                  decoration: const InputDecoration(labelText: "Rating"),
                  items: List.generate(5, (i) {
                    return DropdownMenuItem(
                      value: i + 1,
                      child: Text("${i + 1} stjerner"),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      rating = value ?? 3;
                    });
                  },
                ),
                const SizedBox(height: 20),
                if (imagePath != null)
                  Image.file(File(imagePath!), height: 150),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Vælg billede"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final newReview = StickReview(
                        title: title,
                        review: review,
                        rating: rating,
                        imagePath: imagePath,
                      );
                      Navigator.pop(context, newReview);
                    }
                  },
                  child: const Text("Gem"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
