import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../constants/app_constants.dart';
import '../services/web_url_service.dart';
import '../services/app_provider_web.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with WidgetsBindingObserver {
  String _selectedColor = 'Pink';
  String _selectedSize = 'S';
  int _quantity = 1;

  final List<String> _colors = [
    'Pink',
    'White',
    'Black',
    'Green',
    'Red',
    'Orange'
  ];
  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      print(
          'ProductDetailScreen: App resumed, products will be refreshed when returning home...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black87),
            onPressed: () => _addToFavorites(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Image Gallery
            _buildImageGallery(),

            // Product Details
            _buildProductDetails(),

            // Service Commitments
            _buildServiceCommitments(),

            // Recommended Products
            _buildRecommendedProducts(),

            // Bottom Navigation Tabs
            _buildBottomTabs(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade100,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: widget.product.imageUrl.isNotEmpty
              ? Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                )
              : Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                ),
        ),
      ),
    );
  }

  Color _getColorByName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'pink':
        return Colors.pink;
      case 'white':
        return Colors.white;
      case 'black':
        return Colors.black;
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildProductDetails() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Title
          Text(
            widget.product.productDesc,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.3,
            ),
          ),

          SizedBox(height: 8),

          // Sales Count
          Text(
            '9 sold',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          SizedBox(height: 16),

          // Promotional Banner
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'ChoiceDay - Ends: Sep 5, 23:59 CET',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 24),

          // Pricing Information
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '21,59€',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Save 11,12€',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          SizedBox(height: 4),

          Text(
            '32,71€',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey.shade600,
              decoration: TextDecoration.lineThrough,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Price includes VAT',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),

          SizedBox(height: 16),

          // Additional Discount
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '2,00€ off on 19,00€',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),

          SizedBox(height: 24),

          // Color Selection
          Text(
            'Color: $_selectedColor',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 12),

          Row(
            children: _colors.map((color) {
              final isSelected = _selectedColor == color;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: Container(
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 40,
                      height: 40,
                      color: _getColorByName(color),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 24),

          // Size Selection
          Text(
            'Size: $_selectedSize',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 12),

          Row(
            children: _sizes.map((size) {
              final isSelected = _selectedSize == size;
              return GestureDetector(
                onTap: () => setState(() => _selectedSize = size),
                child: Container(
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                  child: Text(
                    size,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 24),

          // Quantity Selector
          Text(
            'Quantity',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 12),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() => _quantity--);
                        }
                      },
                      icon: Icon(Icons.remove, size: 20),
                      padding: EdgeInsets.all(8),
                    ),
                    Container(
                      width: 60,
                      child: Text(
                        '$_quantity',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _quantity++),
                      icon: Icon(Icons.add, size: 20),
                      padding: EdgeInsets.all(8),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Text(
                '1686 available',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      _launchProductUrl(context, widget.product.promotionUrl),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Buy now',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.black87),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Add to cart',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Share and Wishlist
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.share, size: 20),
                  label: Text(
                    'Share',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _addToFavorites(context),
                  icon: Icon(Icons.favorite_border, size: 20),
                  label: Text(
                    '316',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Google Play Download Button
          _buildGooglePlayButton(),

          SizedBox(height: 24),

          // Seller & Shipping
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sold by GLINDADA Offici... (Trader)',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey.shade600),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: Colors.grey.shade600),
                        SizedBox(width: 8),
                        Text(
                          'Ship to Frankfurt am Main, Hesse...',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey.shade600),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCommitments() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          _buildServiceItem(
            icon: Icons.local_shipping,
            title: 'Free shipping',
            subtitle: 'Delivery: Sep 08 - 14',
            color: Colors.green,
          ),
          SizedBox(height: 16),
          _buildServiceItem(
            icon: Icons.access_time,
            title: 'Fast delivery',
            subtitle:
                '1,00€ coupon code if delayed, Refund if package lost, Refund if items damaged, Refund if no delivery in 40 days',
            color: Colors.green,
          ),
          SizedBox(height: 16),
          _buildServiceItem(
            icon: Icons.swap_horiz,
            title: 'Free returns within 15 days',
            subtitle: '',
            color: Colors.green,
          ),
          SizedBox(height: 16),
          _buildServiceItem(
            icon: Icons.security,
            title: 'Security & Privacy Safe payments...',
            subtitle: '',
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
      ],
    );
  }

  Widget _buildRecommendedProducts() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended for you',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              // Get 5 random products from the provider
              final recommendedProducts = provider.getRandomProducts(5);

              if (recommendedProducts.isEmpty) {
                return Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.recommend,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading recommendations...',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recommendedProducts.length,
                itemBuilder: (context, index) {
                  final product = recommendedProducts[index];
                  return _buildRecommendedProductCard(product);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedProductCard(Product product) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToProductDetail(product),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: product.imageUrl.isNotEmpty
                        ? Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 32,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image_not_supported,
                              size: 32,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productDesc,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '\$${product.numericPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                          if (product.hasDiscount) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                product.discount,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red[700],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${product.sales180Day} sold • ${product.positiveFeedback}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProductDetail(Product product) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  Widget _buildBottomTabs() {
    return Container(
      margin: EdgeInsets.only(top: 24),
      child: Column(
        children: [
          // Tab Headers
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                _buildTab('Customer Reviews', true),
                _buildTab('Specifications', false),
                _buildTab('Description', false),
                _buildTab('Store', false),
                _buildTab('More to love', false),
              ],
            ),
          ),

          // Tab Content
          Container(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reviews',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'No reviews yet. Be the first to review this product!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  void _launchProductUrl(BuildContext context, String url) async {
    if (url.isNotEmpty) {
      try {
        final success = await WebUrlService.openUrlInNewTab(url);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening AliExpress affiliate link in new tab...'),
              backgroundColor: AppConstants.primaryColor,
              duration: const Duration(seconds: 2),
            ),
          );

          print('Successfully opened affiliate URL: $url');
        } else {
          throw Exception('Failed to open URL');
        }
      } catch (e) {
        print('Error opening affiliate URL: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening affiliate link: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No affiliate link available for this product'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _addToFavorites(BuildContext context) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.addToFavorites(widget.product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${widget.product.productDesc} to favorites'),
        backgroundColor: AppConstants.primaryColor,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () async {
            await provider.removeFromFavorites(widget.product.productId);
          },
        ),
      ),
    );
  }

  Widget _buildGooglePlayButton() {
    return Container(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _launchGooglePlayStore(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 28,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GET IT ON',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Google Play',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchGooglePlayStore() {
    final googlePlayUrl =
        'https://play.google.com/store/apps/details?id=com.marconlineshopping.humanhairwigs';

    // For web, we'll use the WebUrlService to open in new tab
    WebUrlService.openUrlInNewTab(googlePlayUrl).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening Google Play Store...'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening Google Play Store'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
}
