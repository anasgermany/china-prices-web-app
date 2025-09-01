import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_constants.dart';
import '../models/price_comparison_model.dart';

class PriceComparisonCard extends StatelessWidget {
  final PriceComparison priceComparison;
  final Function(String, String) onStoreTap;
  final Function(String, String) onSearchTap;

  const PriceComparisonCard({
    super.key,
    required this.priceComparison,
    required this.onStoreTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Product Info
          _buildHeader(),

          // Price Comparison List
          _buildPriceComparisonList(),

          // Best Price Highlight
          if (priceComparison.lowestPrice != null)
            _buildBestPriceHighlight(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            child: SizedBox(
              width: 60,
              height: 60,
              child: CachedNetworkImage(
                imageUrl: priceComparison.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppConstants.backgroundColor,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 24,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Product Name
          Expanded(
            child: Text(
              priceComparison.name,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceComparisonList() {
    return Column(
      children: priceComparison.sortedPrices.map((storePrice) {
        final isAliExpress = storePrice.storeName.toLowerCase().contains('aliexpress');
        final hasPrice = storePrice.price > 0;
        
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: 4,
          ),
          child: _buildStorePriceRow(storePrice, isAliExpress, hasPrice),
        );
      }).toList(),
    );
  }

  Widget _buildStorePriceRow(StorePrice storePrice, bool isAliExpress, bool hasPrice) {
    final storeColor = AppConstants.storeColors[storePrice.storeName] ?? AppConstants.textSecondaryColor;
    final storeIcon = AppConstants.storeIcons[storePrice.storeName] ?? Icons.store;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAliExpress ? AppConstants.primaryColor.withOpacity(0.1) : AppConstants.backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: isAliExpress 
            ? Border.all(color: AppConstants.primaryColor.withOpacity(0.3))
            : null,
      ),
      child: Row(
        children: [
          // Store Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: storeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              storeIcon,
              color: storeColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Store Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storePrice.storeName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
                if (isAliExpress)
                  Text(
                    'Featured Store',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          // Price
          if (hasPrice) ...[
            Text(
              '\$${storePrice.price.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isAliExpress ? AppConstants.primaryColor : AppConstants.textPrimaryColor,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Action Button
          _buildActionButton(storePrice, hasPrice),
        ],
      ),
    );
  }

  Widget _buildActionButton(StorePrice storePrice, bool hasPrice) {
    if (hasPrice) {
      return ElevatedButton(
        onPressed: () => onStoreTap(storePrice.storeName, storePrice.affiliateUrl),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        child: Text(
          'View',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return OutlinedButton(
        onPressed: () => onSearchTap(storePrice.storeName, priceComparison.name),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          side: BorderSide(color: AppConstants.primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        child: Text(
          'Search',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  Widget _buildBestPriceHighlight() {
    final lowestPrice = priceComparison.lowestPrice!;
    final isAliExpressBest = priceComparison.isAliExpressBestPrice;

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: isAliExpressBest 
            ? AppConstants.successColor.withOpacity(0.1)
            : AppConstants.warningColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: isAliExpressBest 
              ? AppConstants.successColor.withOpacity(0.3)
              : AppConstants.warningColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isAliExpressBest ? Icons.thumb_up : Icons.trending_up,
            color: isAliExpressBest ? AppConstants.successColor : AppConstants.warningColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isAliExpressBest
                  ? 'Best price on AliExpress!'
                  : 'Best price on ${lowestPrice.storeName}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isAliExpressBest ? AppConstants.successColor : AppConstants.warningColor,
              ),
            ),
          ),
          Text(
            '\$${lowestPrice.price.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isAliExpressBest ? AppConstants.successColor : AppConstants.warningColor,
            ),
          ),
        ],
      ),
    );
  }
}
