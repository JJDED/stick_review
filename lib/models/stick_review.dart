class StickReview {
  String title;
  String review;
  int rating;
  String? location;
  String? imagePath;
  double? latitude;  // NY
  double? longitude; // NY

  StickReview({
    required this.title,
    required this.review,
    required this.rating,
    this.location,
    this.imagePath,
    this.latitude,
    this.longitude,
  });

  factory StickReview.fromJson(Map<String, dynamic> json) => StickReview(
        title: json['title'],
        review: json['review'],
        rating: json['rating'],
        location: json['location'],
        imagePath: json['imagePath'],
        latitude: json['latitude']?.toDouble(),
        longitude: json['longitude']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'review': review,
        'rating': rating,
        'location': location,
        'imagePath': imagePath,
        'latitude': latitude,
        'longitude': longitude,
      };
}
