import 'package:flutter/material.dart';

class ProductFilter {
  final double? minPrice;
  final double? maxPrice;
  final double? minDiscount;
  final double? maxDiscount;
  final double? minCommission;
  final double? maxCommission;
  final int? minSales;
  final int? maxSales;
  final double? minFeedback;
  final double? maxFeedback;
  final List<String> categories;
  final String? searchQuery;
  final bool hasDiscount;
  final bool isHotSale;
  final bool isTopRated;

  ProductFilter({
    this.minPrice,
    this.maxPrice,
    this.minDiscount,
    this.maxDiscount,
    this.minCommission,
    this.maxCommission,
    this.minSales,
    this.maxSales,
    this.minFeedback,
    this.maxFeedback,
    this.categories = const [],
    this.searchQuery,
    this.hasDiscount = false,
    this.isHotSale = false,
    this.isTopRated = false,
  });

  ProductFilter copyWith({
    double? minPrice,
    double? maxPrice,
    double? minDiscount,
    double? maxDiscount,
    double? minCommission,
    double? maxCommission,
    int? minSales,
    int? maxSales,
    double? minFeedback,
    double? maxFeedback,
    List<String>? categories,
    String? searchQuery,
    bool? hasDiscount,
    bool? isHotSale,
    bool? isTopRated,
  }) {
    return ProductFilter(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minDiscount: minDiscount ?? this.minDiscount,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      minCommission: minCommission ?? this.minCommission,
      maxCommission: maxCommission ?? this.maxCommission,
      minSales: minSales ?? this.minSales,
      maxSales: maxSales ?? this.maxSales,
      minFeedback: minFeedback ?? this.minFeedback,
      maxFeedback: maxFeedback ?? this.maxFeedback,
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
      hasDiscount: hasDiscount ?? this.hasDiscount,
      isHotSale: isHotSale ?? this.isHotSale,
      isTopRated: isTopRated ?? this.isTopRated,
    );
  }

  bool get hasActiveFilters {
    return minPrice != null ||
           maxPrice != null ||
           minDiscount != null ||
           maxDiscount != null ||
           minCommission != null ||
           maxCommission != null ||
           minSales != null ||
           maxSales != null ||
           minFeedback != null ||
           maxFeedback != null ||
           categories.isNotEmpty ||
           searchQuery != null ||
           hasDiscount ||
           isHotSale ||
           isTopRated;
  }

  ProductFilter clear() {
    return ProductFilter();
  }
}

class FilterOption {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  FilterOption({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

