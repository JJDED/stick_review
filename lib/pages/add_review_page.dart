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

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      title = widget.existingReview!.title;
      review = widget.existingReview!.review;
      rating = widget.existingReview!.rating;
      imagePath = widget.existingReview!.imagePath;
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
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "Indtast en titel" : null,
                ),
                TextFormField(
                  initialValue: review,
                  decoration: const InputDecoration(labelText: "Din anmeldelse"),
                  onSaved: (value) => review = value ?? "",
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "Indtast en anmeldelse" : null,
                ),
                DropdownButtonFormField<int>(
                  initialValue: rating,
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
                      final reviewObj = StickReview(
                        title: title,
                        review: review,
                        rating: rating,
                        imagePath: imagePath,
                      );
                      Navigator.pop(context, reviewObj);
                    }
                  },
                  child: Text(isEditing ? "Opdater" : "Gem"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
