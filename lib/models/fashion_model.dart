class FashionItem {
  final String name;
  final String imageUrl;
  final String category;
  final List<String> colors;

  FashionItem({
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.colors,
  });

  factory FashionItem.fromJson(Map<String, dynamic> json) {
    return FashionItem(
      name: json['name'] ?? '',
      imageUrl: json['Image Url'] ?? '',
      category: json['category'] ?? '',
      colors: List<String>.from(json['colors'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'Image Url': imageUrl,
      'category': category,
      'colors': colors,
    };
  }
}

