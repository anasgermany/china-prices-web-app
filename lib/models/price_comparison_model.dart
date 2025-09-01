class StorePrice {
  final String storeName;
  final double price;
  final String affiliateUrl;

  StorePrice({
    required this.storeName,
    required this.price,
    required this.affiliateUrl,
  });

  factory StorePrice.fromJson(Map<String, dynamic> json) {
    return StorePrice(
      storeName: json['store_name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      affiliateUrl: json['affiliate_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
      'price': price,
      'affiliate_url': affiliateUrl,
    };
  }
}

class PriceComparison {
  final String name;
  final String imageUrl;
  final List<StorePrice> prices;

  PriceComparison({
    required this.name,
    required this.imageUrl,
    required this.prices,
  });

  factory PriceComparison.fromJson(Map<String, dynamic> json) {
    List<StorePrice> pricesList = [];
    if (json['prices'] != null) {
      pricesList = (json['prices'] as List)
          .map((price) => StorePrice.fromJson(price))
          .toList();
    }

    return PriceComparison(
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      prices: pricesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image_url': imageUrl,
      'prices': prices.map((price) => price.toJson()).toList(),
    };
  }

  // Get sorted prices with AliExpress always first
  List<StorePrice> get sortedPrices {
    List<StorePrice> sorted = List.from(prices);
    
    // Find AliExpress and remove it temporarily
    StorePrice? aliExpress;
    sorted.removeWhere((price) {
      if (price.storeName.toLowerCase().contains('aliexpress')) {
        aliExpress = price;
        return true;
      }
      return false;
    });
    
    // Sort remaining prices by price
    sorted.sort((a, b) => a.price.compareTo(b.price));
    
    // Add AliExpress at the beginning if found
    if (aliExpress != null) {
      sorted.insert(0, aliExpress!);
    }
    
    return sorted;
  }

  // Get the lowest price (excluding AliExpress if it's not the lowest)
  StorePrice? get lowestPrice {
    if (prices.isEmpty) return null;
    
    List<StorePrice> sorted = sortedPrices;
    return sorted.isNotEmpty ? sorted.first : null;
  }

  // Check if AliExpress has the best price
  bool get isAliExpressBestPrice {
    if (prices.isEmpty) return false;
    
    StorePrice? aliExpress = prices.firstWhere(
      (price) => price.storeName.toLowerCase().contains('aliexpress'),
      orElse: () => StorePrice(storeName: '', price: double.infinity, affiliateUrl: ''),
    );
    
    if (aliExpress.storeName.isEmpty) return false;
    
    return aliExpress.price <= prices.map((p) => p.price).reduce((a, b) => a < b ? a : b);
  }
}
