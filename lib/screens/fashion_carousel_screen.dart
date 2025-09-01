 import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';
import '../models/fashion_item.dart';
import '../services/app_provider.dart';

class FashionCarouselScreen extends StatefulWidget {
  const FashionCarouselScreen({super.key});

  @override
  State<FashionCarouselScreen> createState() => _FashionCarouselScreenState();
}

class _FashionCarouselScreenState extends State<FashionCarouselScreen>
    with TickerProviderStateMixin {
  List<FashionItem> _fashionItems = [];
  bool _isLoading = true;
  String _errorMessage = '';
  late PageController _pageController;
  int _currentIndex = 0;
  bool _hasShuffled = false;
  
  // Vibrant background colors for modern carousel
  final List<Color> _vibrantColors = [
    const Color(0xFFFF69B4), // Hot Pink
    const Color(0xFF00BFFF), // Deep Sky Blue
    const Color(0xFF9370DB), // Medium Purple
    const Color(0xFFFFA500), // Orange
    const Color(0xFF32CD32), // Lime Green
    const Color(0xFFFF6347), // Tomato Red
    const Color(0xFF00FFFF), // Cyan
    const Color(0xFFFF00FF), // Magenta
    const Color(0xFFFFD700), // Gold
    const Color(0xFF20B2AA), // Light Sea Green
    const Color(0xFFFF1493), // Deep Pink
    const Color(0xFF1E90FF), // Dodger Blue
    const Color(0xFF8A2BE2), // Blue Violet
    const Color(0xFFFF8C00), // Dark Orange
    const Color(0xFF00FA9A), // Medium Spring Green
    const Color(0xFFFF4500), // Orange Red
    const Color(0xFF00CED1), // Dark Turquoise
    const Color(0xFFDA70D6), // Orchid
    const Color(0xFFFFB6C1), // Light Pink
    const Color(0xFF87CEEB), // Sky Blue
  ];
  
  Color _currentBackgroundColor = const Color(0xFFFF69B4); // Default color
  


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _loadFashionItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Shuffle items when screen becomes visible again (only once)
    if (_fashionItems.isNotEmpty && !_hasShuffled) {
      _shuffleItems();
      _hasShuffled = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Reset shuffle flag when leaving the screen
    _hasShuffled = false;
    super.dispose();
  }

  Future<void> _loadFashionItems() async {
    print('🔄 Starting to load fashion items from JSON...');
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print('📦 Loading from: ${AppConstants.fashionJsonUrl}');
      final response = await http.get(Uri.parse(AppConstants.fashionJsonUrl));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> imagesList = jsonData['images'] ?? [];
        print('✅ Successfully loaded ${imagesList.length} images from JSON');
        
        final fashionItems = imagesList.map((imageUrl) => FashionItem.fromImageUrl(imageUrl.toString())).toList();
        
        // Shuffle the fashion items to show different photos each time
        fashionItems.shuffle();
        
        setState(() {
          _fashionItems = fashionItems;
          _isLoading = false;
        });
        
        // Initialize background color
        _changeBackgroundColor();
        
        print('✅ Successfully loaded ${_fashionItems.length} fashion items (shuffled)');
        if (_fashionItems.isNotEmpty) {
          print('📸 Initial first item: ${_fashionItems.first.imageUrl}');
          print('📝 First item title: ${_fashionItems.first.title}');
          print('📍 Current index: $_currentIndex');
        } else {
          print('⚠️ Warning: No fashion items loaded!');
        }
      } else {
        throw Exception('Failed to load fashion items: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('❌ Error loading fashion items: $e');
      print('📚 Stack trace: $stackTrace');
      setState(() {
        _errorMessage = 'Error loading fashion items: $e';
        _isLoading = false;
      });
    }
  }

  void _shuffleItems() {
    if (_fashionItems.isNotEmpty) {
      setState(() {
        _fashionItems.shuffle();
        _currentIndex = 0;
        _changeBackgroundColor();
      });
      
      // Verificar que el PageController esté listo antes de usarlo
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      
      print('Fashion items shuffled - new order applied');
      if (_fashionItems.isNotEmpty) {
        print('First item after shuffle: ${_fashionItems.first.imageUrl}');
      }
    }
  }

  void _changeBackgroundColor() {
    final random = Random();
    Color newColor;
    do {
      newColor = _vibrantColors[random.nextInt(_vibrantColors.length)];
    } while (newColor == _currentBackgroundColor && _vibrantColors.length > 1);
    
    setState(() {
      _currentBackgroundColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      extendBodyBehindAppBar: true,
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    print('🏗️ Building content...');
    print('   - isLoading: $_isLoading');
    print('   - errorMessage: $_errorMessage');
    print('   - fashionItems.length: ${_fashionItems.length}');
    
    if (_isLoading) {
      print('⏳ Showing loading state...');
      return _buildLoadingState();
    }

    if (_errorMessage.isNotEmpty) {
      print('❌ Showing error state: $_errorMessage');
      return _buildErrorState();
    }

    if (_fashionItems.isEmpty) {
      print('📭 Showing empty state...');
      return _buildEmptyState();
    }

    print('🎠 Building carousel...');
    return _buildCarousel();
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F0F23),
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading Fashion Items...',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F0F23),
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE74C3C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE74C3C),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Color(0xFFE74C3C),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Error Loading Fashion Items',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage,
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadFashionItems,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F0F23),
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.image_not_supported_rounded,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Fashion Items Available',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Try again later or check your connection',
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    print('🎠 Building carousel with ${_fashionItems.length} items');
    
    if (_fashionItems.isEmpty) {
      print('⚠️ Warning: Trying to build carousel with empty items list!');
      return _buildEmptyState();
    }
    
    try {
      return Stack(
        children: [
          // Full screen PageView with PhotoView for high-quality image viewing
          PageView.builder(
            key: const PageStorageKey('fashion_carousel'),
            controller: _pageController,
            onPageChanged: (index) {
              print('Page changed to index: $index');
              if (index < _fashionItems.length) {
                setState(() {
                  _currentIndex = index;
                });
                _changeBackgroundColor();
              }
            },
            itemCount: _fashionItems.length,
            itemBuilder: (context, index) {
              if (index >= _fashionItems.length) {
                return Container(color: Colors.black);
              }
              final fashionItem = _fashionItems[index];
              print('Building item $index: ${fashionItem.title} - ${fashionItem.imageUrl}');
              return _buildHighQualityImage(fashionItem, index);
            },
          ),
          
          // Top app bar with gradient background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppConstants.primaryColor,
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  // Back button
                  Container(
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Shuffle button
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFF6B35),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () => _shuffleItems(),
                      icon: const Icon(
                        Icons.shuffle,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Share button
                  Container(
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () => _shareImage(),
                      icon: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3),

          // Bottom info panel with gradient background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppConstants.primaryColor,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fashion item title
                  Text(
                    _fashionItems[_currentIndex].title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action buttons row
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () => _downloadImage(),
                            icon: const Icon(Icons.download),
                            label: const Text('Download'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () => _shareImage(),
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Description
                  if (_fashionItems[_currentIndex].description != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _fashionItems[_currentIndex].description!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
        ],
      );
    } catch (e, stackTrace) {
      print('❌ Error building carousel: $e');
      print('📚 Stack trace: $stackTrace');
      return _buildErrorState();
    }
  }

  Widget _buildHighQualityImage(FashionItem fashionItem, int index) {
    print('🖼️ Building high quality image for index $index: ${fashionItem.title}');
    
    try {
      return PhotoView(
        imageProvider: CachedNetworkImageProvider(fashionItem.imageUrl),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        backgroundDecoration: const BoxDecoration(
          color: AppConstants.primaryColor,
        ),
        loadingBuilder: (context, event) => Container(
          color: AppConstants.primaryColor,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppConstants.primaryColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading image',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('❌ Error building high quality image: $e');
      print('📚 Stack trace: $stackTrace');
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: AppConstants.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading image',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }



  Future<void> _downloadImage() async {
    if (_fashionItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No images available to download'),
          backgroundColor: Colors.grey[600],
        ),
      );
      return;
    }
    
    try {
      final fashionItem = _fashionItems[_currentIndex];
      
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );

      // Download image
      final dio = Dio();
      final response = await dio.get(
        fashionItem.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/fashion_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(response.data);

      // Close loading dialog
      Navigator.of(context).pop();

      // Share the downloaded file
      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text: AppConstants.appPromotionText,
        subject: 'Fashion from China Prices App',
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      _showErrorDialog('Error downloading image: $e');
    }
  }

  Future<void> _shareImage() async {
    if (_fashionItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No images available to share'),
          backgroundColor: Colors.grey[600],
        ),
      );
      return;
    }
    
    try {
      final fashionItem = _fashionItems[_currentIndex];
      
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );

      // Download image
      final dio = Dio();
      final response = await dio.get(
        fashionItem.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/share_image.jpg');
      await tempFile.writeAsBytes(response.data);

      // Close loading dialog
      Navigator.of(context).pop();

      // Share image with app promotion text
      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text: AppConstants.appPromotionText,
        subject: 'Amazing Fashion from China Prices App',
      );
      
      // Track the share for gamification
      try {
        final provider = Provider.of<AppProvider>(context, listen: false);
        await provider.trackAppShare();
      } catch (e) {
        print('Error tracking app share: $e');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      _showErrorDialog('Error sharing image: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Error',
          style: GoogleFonts.poppins(
            color: const Color(0xFFE74C3C),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.grey[300],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: const Color(0xFFFF6B35),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }




}