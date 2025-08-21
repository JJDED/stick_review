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
