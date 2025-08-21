import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/stick_review.dart';

class AddReviewPage extends StatefulWidget {
  final StickReview? existingReview;

  const AddReviewPage({super.key, this.existingReview});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _formKey = GlobalKey<FormState>();
  String title = "";
  String review = "";
  int rating = 3;
  String? imagePath;
  String? location; // NYT

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      final r = widget.existingReview!;
      title = r.title;
      review = r.review;
      rating = r.rating;
      imagePath = r.imagePath;
      location = r.location; // NYT
    }
  }

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
    final isEditing = widget.existingReview != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Rediger anmeldelse" : "Tilføj anmeldelse")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: title,
                  decoration: const InputDecoration(labelText: "Titel på pind"),
                  onSaved: (value) => title = value ?? "",
                  validator: (value) => (value == null || value.isEmpty) ? "Indtast en titel" : null,
                ),
                TextFormField(
                  initialValue: review,
                  decoration: const InputDecoration(labelText: "Din anmeldelse"),
                  onSaved: (value) => review = value ?? "",
                  validator: (value) => (value == null || value.isEmpty) ? "Indtast en anmeldelse" : null,
                ),
                DropdownButtonFormField<int>(
                  value: rating,
                  decoration: const InputDecoration(labelText: "Rating"),
                  items: List.generate(5, (i) => DropdownMenuItem(value: i + 1, child: Text("${i + 1} stjerner"))),
                  onChanged: (value) => setState(() => rating = value ?? 3),
                ),
                TextFormField(
                  initialValue: location,
                  decoration: const InputDecoration(
                    labelText: "Lokation (f.eks. 'Skoven, Aarhus')",
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  onSaved: (value) => location = value?.trim().isEmpty == true ? null : value?.trim(),
                ),
                const SizedBox(height: 20),
                if (imagePath != null) Image.file(File(imagePath!), height: 150),
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
                      final reviewObj = StickReview(
                        title: title,
                        review: review,
                        rating: rating,
                        imagePath: imagePath,
                        location: location, // NYT
                      );
                      Navigator.pop(context, reviewObj);
                    }
                  },
                  child: Text(isEditing ? "Opdater" : "Gem"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
