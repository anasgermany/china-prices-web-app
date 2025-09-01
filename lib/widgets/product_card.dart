import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/product_model.dart';
import '../services/app_provider.dart';
import '../routes.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool showFavoriteButton;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.product,
    this.showFavoriteButton = false,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;
  bool _isLoadingFavorite = false;
  bool _hasLoadedFavoriteStatus = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    if (widget.showFavoriteButton) {
      _loadFavoriteStatus();
    }
  }

  @override
  void didUpdateWidget(ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.productId != widget.product.productId) {
      _isFavorite = widget.isFavorite;
      _hasLoadedFavoriteStatus = false;
      if (widget.showFavoriteButton) {
        _loadFavoriteStatus();
      }
    }
  }

  Future<void> _loadFavoriteStatus() async {
    if (!widget.showFavoriteButton) return;
    
    try {
      print('ProductCard: Loading favorite status for product: ${widget.product.productDesc} (ID: ${widget.product.productId})');
      final provider = Provider.of<AppProvider>(context, listen: false);
      final isFavorite = await provider.isFavorite(widget.product.productId);
      print('ProductCard: Favorite status loaded: $isFavorite');
      if (mounted) {
        setState(() {
          _isFavorite = isFavorite;
          _hasLoadedFavoriteStatus = true;
        });
      }
    } catch (e) {
      print('ProductCard: Error loading favorite status: $e');
    }
  }

  Future<void> _handleFavoriteToggle() async {
    if (!widget.showFavoriteButton) return;

    print('ProductCard: Favorite button tapped for product: ${widget.product.productDesc} (ID: ${widget.product.productId})');

    setState(() {
      _isLoadingFavorite = true;
    });

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      
      if (_isFavorite) {
        print('ProductCard: Removing product from favorites...');
        await provider.removeFromFavorites(widget.product.productId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from favorites'),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        }
      } else {
        print('ProductCard: Adding product to favorites...');
        await provider.addToFavorites(widget.product);
        // Track favorite added for gamification
        await provider.trackFavoriteAdded();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to favorites'),
              backgroundColor: AppConstants.successColor,
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
          _isLoadingFavorite = false;
        });
      }

      // Call the callback if provided
      widget.onFavoriteToggle?.call();
    } catch (e) {
      print('Error toggling favorite: $e');
      if (mounted) {
        setState(() {
          _isLoadingFavorite = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error updating favorites'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        final isMediumScreen = constraints.maxWidth >= 400 && constraints.maxWidth < 600;
        final isLargeScreen = constraints.maxWidth >= 600;
        
        // Calculate aspect ratio based on card dimensions
        final cardAspectRatio = constraints.maxHeight / constraints.maxWidth;
        final isWideCard = cardAspectRatio < 1.5; // Card is wider than tall
        
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.productDetail,
              arguments: widget.product,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppConstants.surfaceColor,
              borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: isSmallScreen ? 8 : 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Expanded(
                  flex: isWideCard ? 4 : (isSmallScreen ? 4 : 5),
                  child: Stack(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isSmallScreen ? 12 : 16),
                          topRight: Radius.circular(isSmallScreen ? 12 : 16),
                        ),
                        child: isWideCard 
                          ? Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: CachedNetworkImage(
                                imageUrl: widget.product.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppConstants.primaryColor.withOpacity(0.1),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: isSmallScreen ? 24 : 32,
                                    color: AppConstants.primaryColor,
                                  ),
                                ),
                              ),
                            )
                          : AspectRatio(
                              aspectRatio: isSmallScreen ? 0.9 : 1.0,
                              child: CachedNetworkImage(
                                imageUrl: widget.product.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppConstants.primaryColor.withOpacity(0.1),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: isSmallScreen ? 24 : 32,
                                    color: AppConstants.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                      ),
                      
                      // Favorite Button
                      if (widget.showFavoriteButton)
                        Positioned(
                          top: isSmallScreen ? 6 : 8,
                          right: isSmallScreen ? 6 : 8,
                          child: GestureDetector(
                            onTap: _handleFavoriteToggle,
                            child: Container(
                              padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: _isLoadingFavorite
                                  ? SizedBox(
                                      width: isSmallScreen ? 18 : 20,
                                      height: isSmallScreen ? 18 : 20,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppConstants.primaryColor,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                                      size: isSmallScreen ? 18 : 20,
                                      color: _isFavorite 
                                          ? AppConstants.errorColor 
                                          : AppConstants.textSecondaryColor,
                                    ),
                            ),
                          ),
                        ),
                      
                      // Product Tags
                      Positioned(
                        top: isSmallScreen ? 6 : 8,
                        left: isSmallScreen ? 6 : 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Discount Tag
                            if (widget.product.hasDiscount && _getDiscountPercentage() >= 20)
                              _buildTag(
                                '${_getDiscountPercentage()}% OFF',
                                AppConstants.errorColor,
                                Icons.local_offer,
                                isSmallScreen,
                              ),
                            
                            SizedBox(height: isSmallScreen ? 3 : 4),
                            
                            // Hot Sale Tag
                            if (widget.product.sales180Day >= 100)
                              _buildTag(
                                'HOT SALE',
                                Colors.orange,
                                Icons.whatshot,
                                isSmallScreen,
                              ),
                            
                            SizedBox(height: isSmallScreen ? 3 : 4),
                            
                            // High Rating Tag
                            if (_getRatingPercentage() >= 95)
                              _buildTag(
                                'TOP RATED',
                                Colors.green,
                                Icons.star,
                                isSmallScreen,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Section
                Expanded(
                  flex: isWideCard ? 1 : (isSmallScreen ? 2 : 1),
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        _buildProductName(isSmallScreen),

                        SizedBox(height: isSmallScreen ? 2 : 4),

                        // Price Section
                        _buildPriceSection(isSmallScreen),

                        SizedBox(height: isSmallScreen ? 2 : 4),

                        // Additional Info
                        _buildAdditionalInfo(isSmallScreen),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductName(bool isSmallScreen) {
    return Flexible(
      child: Text(
        widget.product.productDesc,
        style: GoogleFonts.poppins(
          fontSize: isSmallScreen ? 9 : 11,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
          height: 1.1,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPriceSection(bool isSmallScreen) {
    return Row(
      children: [
        // Discount Price
        Expanded(
          child: Text(
            widget.product.discountPrice,
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 11 : 13,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(width: isSmallScreen ? 4 : 6),

        // Original Price (if different)
        if (widget.product.originPrice != widget.product.discountPrice)
          Flexible(
            child: Text(
              widget.product.originPrice,
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 9 : 11,
                decoration: TextDecoration.lineThrough,
                color: AppConstants.textSecondaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildAdditionalInfo(bool isSmallScreen) {
    return Row(
      children: [
        // Sales
        if (widget.product.sales180Day > 0) ...[
          Icon(
            Icons.shopping_cart,
            size: isSmallScreen ? 9 : 11,
            color: AppConstants.textSecondaryColor,
          ),
          SizedBox(width: isSmallScreen ? 2 : 3),
          Flexible(
            child: Text(
              _getSalesText(),
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 7 : 8,
                color: AppConstants.textSecondaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: isSmallScreen ? 4 : 6),
        ],

        // Rating
        if (widget.product.positiveFeedback.isNotEmpty) ...[
          Icon(
            Icons.star,
            size: isSmallScreen ? 9 : 11,
            color: AppConstants.warningColor,
          ),
          SizedBox(width: isSmallScreen ? 2 : 3),
          Flexible(
            child: Text(
              widget.product.positiveFeedback,
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 7 : 8,
                color: AppConstants.textSecondaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
  
  String _getSalesText() {
    final sales = widget.product.sales180Day;
    if (sales >= 1000) {
      return '${(sales / 1000).toStringAsFixed(1)}K sold';
    } else if (sales >= 100) {
      return '$sales sold';
    } else {
      return '$sales sold';
    }
  }
  
  // Helper methods for tags
  int _getDiscountPercentage() {
    try {
      final discountStr = widget.product.discount.replaceAll('%', '');
      return int.tryParse(discountStr) ?? 0;
    } catch (e) {
      return 0;
    }
  }
  
  int _getRatingPercentage() {
    try {
      final ratingStr = widget.product.positiveFeedback.replaceAll('%', '');
      return int.tryParse(ratingStr) ?? 0;
    } catch (e) {
      return 0;
    }
  }
  
  Widget _buildTag(String text, Color color, IconData icon, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 6 : 8, 
        vertical: isSmallScreen ? 2 : 3
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isSmallScreen ? 10 : 12,
            color: Colors.white,
          ),
          SizedBox(width: isSmallScreen ? 2 : 3),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 8 : 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
