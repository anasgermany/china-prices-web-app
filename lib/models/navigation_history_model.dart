class NavigationHistory {
  final String productId;
  final String productName;
  final String imageUrl;
  final String category;
  final DateTime viewedAt;
  final int viewCount;

  NavigationHistory({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.category,
    required this.viewedAt,
    this.viewCount = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'category': category,
      'viewedAt': viewedAt.toIso8601String(),
      'viewCount': viewCount,
    };
  }

  factory NavigationHistory.fromJson(Map<String, dynamic> json) {
    return NavigationHistory(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      viewedAt: DateTime.parse(json['viewedAt'] ?? DateTime.now().toIso8601String()),
      viewCount: json['viewCount'] ?? 1,
    );
  }

  NavigationHistory copyWith({
    String? productId,
    String? productName,
    String? imageUrl,
    String? category,
    DateTime? viewedAt,
    int? viewCount,
  }) {
    return NavigationHistory(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      viewedAt: viewedAt ?? this.viewedAt,
      viewCount: viewCount ?? this.viewCount,
    );
  }
}

class ProductRecommendation {
  final String productId;
  final String productName;
  final String imageUrl;
  final String category;
  final double score;
  final String reason;

  ProductRecommendation({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.category,
    required this.score,
    required this.reason,
  });
}
