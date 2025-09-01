import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../models/product_model.dart';
import '../models/navigation_history_model.dart';
import '../services/app_provider.dart';
import '../widgets/navigation_history_widget.dart';
import '../widgets/recommendations_widget.dart';
import '../widgets/banner_ad_widget.dart';
import '../routes.dart';

class HistoryRecommendationsScreen extends StatefulWidget {
  const HistoryRecommendationsScreen({super.key});

  @override
  State<HistoryRecommendationsScreen> createState() => _HistoryRecommendationsScreenState();
}

class _HistoryRecommendationsScreenState extends State<HistoryRecommendationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: AppConstants.fastAnimation,
      vsync: this,
    );
    _slideController = AnimationController(
      duration: AppConstants.fastAnimation,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();

    // Load history and recommendations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.loadNavigationHistoryAndRecommendations();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh recommendations when screen becomes visible again
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.refreshRecommendations();
    });
  }



  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _showCategorySelector(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final categories = provider.getAvailableCategories();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Select Category for Recommendations',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Random option
                  ListTile(
                    leading: Icon(Icons.shuffle, color: AppConstants.primaryColor),
                    title: Text(
                      'Random (All Categories)',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Discover products from all categories',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      provider.refreshRecommendations();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Showing random recommendations'),
                          backgroundColor: AppConstants.primaryColor,
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  // Category options
                  ...categories.map((category) => ListTile(
                    leading: Icon(Icons.category, color: AppConstants.primaryColor),
                    title: Text(
                      category,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Top $category picks',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      provider.generateRecommendationsForCategory(category);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Showing $category recommendations'),
                          backgroundColor: AppConstants.primaryColor,
                        ),
                      );
                    },
                  )).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          'History & Recommendations',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        backgroundColor: AppConstants.surfaceColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.category,
              color: AppConstants.primaryColor,
            ),
            onPressed: () {
              _showCategorySelector(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: AppConstants.primaryColor,
            ),
            onPressed: () {
              final provider = Provider.of<AppProvider>(context, listen: false);
              provider.loadNavigationHistoryAndRecommendations();
              // Also refresh recommendations with new random products
              provider.refreshRecommendations();
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Navigation History Section
                    NavigationHistoryWidget(
                      history: provider.navigationHistory,
                      onClearHistory: () async {
                        await provider.clearNavigationHistory();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('History cleared'),
                            backgroundColor: AppConstants.successColor,
                          ),
                        );
                      },
                      onHistoryItemTap: (historyItem) async {
                        // Find the product and navigate to detail
                        final product = provider.products.firstWhere(
                          (p) => p.productId.toString() == historyItem.productId,
                          orElse: () => provider.products.first,
                        );
                        await Navigator.of(context).pushNamed(
                          AppRoutes.productDetail,
                          arguments: product,
                        );
                        // Refresh recommendations after returning from product detail
                        provider.refreshRecommendations();
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Inline Banner Ad
                    Container(
                      height: 300, // Fixed height for banner ad
                      child: const BannerAdWidget(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Recommendations Section
                    RecommendationsWidget(
                      recommendations: provider.recommendations,
                      onRecommendationTap: (recommendation) async {
                        // Find the product and navigate to detail
                        final product = provider.products.firstWhere(
                          (p) => p.productId.toString() == recommendation.productId,
                          orElse: () => provider.products.first,
                        );
                        await Navigator.of(context).pushNamed(
                          AppRoutes.productDetail,
                          arguments: product,
                        );
                        // Refresh recommendations after returning from product detail
                        provider.refreshRecommendations();
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Statistics Section
                    _buildStatisticsSection(provider),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticsSection(AppProvider provider) {
    if (provider.navigationHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate statistics
    final totalViews = provider.navigationHistory.fold<int>(
      0, (sum, item) => sum + item.viewCount);
    
    final uniqueCategories = provider.navigationHistory
        .map((item) => item.category)
        .toSet()
        .length;
    
    final mostViewedCategory = provider.navigationHistory
        .fold<Map<String, int>>({}, (map, item) {
          map[item.category] = (map[item.category] ?? 0) + item.viewCount;
          return map;
        })
        .entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor.withOpacity(0.1),
            AppConstants.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.analytics,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Your Activity',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Views',
                  '$totalViews',
                  Icons.visibility,
                  AppConstants.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Categories',
                  '$uniqueCategories',
                  Icons.category,
                  AppConstants.successColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          _buildStatCard(
            'Favorite Category',
            mostViewedCategory,
            Icons.favorite,
            AppConstants.errorColor,
            isFullWidth: true,
          ),
        ],
      ),
    ).animate().fadeIn(
      delay: 300.ms,
      duration: AppConstants.fastAnimation,
    ).slideY(
      begin: 0.3,
      delay: 300.ms,
      duration: AppConstants.fastAnimation,
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, {bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppConstants.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
