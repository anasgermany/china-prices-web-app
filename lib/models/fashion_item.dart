class FashionItem {
  final String imageUrl;
  final String title;
  final String? description;
  final String? category;
  final double? price;
  final String? productUrl;

  FashionItem({
    required this.imageUrl,
    required this.title,
    this.description,
    this.category,
    this.price,
    this.productUrl,
  });

  // Constructor for simple image URLs (new format)
  factory FashionItem.fromImageUrl(String imageUrl) {
    return FashionItem(
      imageUrl: imageUrl,
      title: 'Fashion Item',
      description: 'Beautiful fashion item',
      category: 'Fashion',
    );
  }

  factory FashionItem.fromJson(Map<String, dynamic> json) {
    return FashionItem(
      imageUrl: json['Image Url'] ?? json['imageUrl'] ?? json['image'] ?? '',
      title: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? json['desc'] ?? '',
      category: json['category'] ?? '',
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      productUrl: json['productUrl'] ?? json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'productUrl': productUrl,
    };
  }

  @override
  String toString() {
    return 'FashionItem(imageUrl: $imageUrl, title: $title, description: $description, category: $category, price: $price, productUrl: $productUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FashionItem && other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => imageUrl.hashCode;
}
