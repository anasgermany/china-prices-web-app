class Product {
  final int productId;
  final String imageUrl;
  final String videoUrl;
  final String productDesc;
  final String originPrice;
  final String discountPrice;
  final String discount;
  final String currency;
  final int commissionRate;
  final String commission;
  final int sales180Day;
  final String positiveFeedback;
  final String promotionUrl;

  Product({
    required this.productId,
    required this.imageUrl,
    required this.videoUrl,
    required this.productDesc,
    required this.originPrice,
    required this.discountPrice,
    required this.discount,
    required this.currency,
    required this.commissionRate,
    required this.commission,
    required this.sales180Day,
    required this.positiveFeedback,
    required this.promotionUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: _parseInt(json['ProductId']),
      imageUrl: json['Image Url'] ?? '',
      videoUrl: json['Video Url'] ?? '',
      productDesc: json['Product Desc'] ?? '',
      originPrice: json['Origin Price'] ?? '',
      discountPrice: json['Discount Price'] ?? '',
      discount: json['Discount'] ?? '',
      currency: json['Currency'] ?? 'USD',
      commissionRate: _parseInt(json['Commission Rate']),
      commission: json['Commission'] ?? '',
      sales180Day: _parseInt(json['Sales180Day']),
      positiveFeedback: json['Positive Feedback'] ?? '',
      promotionUrl: json['Promotion Url'] ?? '',
    );
  }

  // Helper method to parse int values that might come as double from JSON
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'Image Url': imageUrl,
      'Video Url': videoUrl,
      'Product Desc': productDesc,
      'Origin Price': originPrice,
      'Discount Price': discountPrice,
      'Discount': discount,
      'Currency': currency,
      'Commission Rate': commissionRate,
      'Commission': commission,
      'Sales180Day': sales180Day,
      'Positive Feedback': positiveFeedback,
      'Promotion Url': promotionUrl,
    };
  }

  double get numericPrice {
    try {
      return double.parse(discountPrice.replaceAll(RegExp(r'[^\d.]'), ''));
    } catch (e) {
      return 0.0;
    }
  }

  bool get hasDiscount => discount.isNotEmpty && discount != '0%';
}
