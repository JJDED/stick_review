import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  final int rating; // rating fra 0-5
  final Color color; // farve på stjernerne
  final double size; // størrelse på stjernerne

  const StarDisplay({
    super.key,
    required this.rating,
    this.color = Colors.amber,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating) {
          return Icon(Icons.star, color: color, size: size);
        } else {
          return Icon(Icons.star_border, color: Colors.grey.shade400, size: size);
        }
      }),
    );
  }
}
