import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  final int rating;
  final Color color; // Tilføj denne linje

  const StarDisplay({super.key, required this.rating, this.color = Colors.amber}); // default til amber

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: color,
          size: 20,
        );
      }),
    );
  }
}
