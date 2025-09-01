import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/app_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';
import '../widgets/banner_ad_widget.dart';
import '../utils/responsive_utils.dart';
import '../routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _buildResponsiveLayout(constraints);
        },
      ),
    );
  }

  Widget _buildResponsiveLayout(BoxConstraints constraints) {
    if (ResponsiveUtils.isDesktop(context)) {
      return _buildDesktopLayout();
    } else if (ResponsiveUtils.isTablet(context)) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left sidebar with categories
        Expanded(
          flex: 1,
          child: _buildCategoriesSection(),
        ),
        // Right content area
        Expanded(
          flex: 2,
          child: _buildContentArea(),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        // Top categories section
        Expanded(
          flex: 2,
          child: _buildCategoriesSection(),
        ),
        // Bottom content area
        Expanded(
          flex: 1,
          child: _buildContentArea(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Categories section
        Expanded(
          flex: 3,
          child: _buildCategoriesSection(),
        ),
        // Content area
        Expanded(
          flex: 1,
          child: _buildContentArea(),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    final categories = AppConstants.getEditableCategories();
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Container(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            'Categories',
            style: GoogleFonts.poppins(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          
          // Categories grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 2 : (isTablet ? 3 : 2),
                crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context),
                mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context),
                childAspectRatio: isDesktop ? 1.2 : 0.8,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  name: category.name,
                  icon: category.icon,
                  imageUrl: category.imageUrl,
                  color: category.color,
                  onTap: () => _navigateToCategory(category.name),
                ).animate().fadeIn(
                  delay: Duration(milliseconds: index * 100),
                  duration: AppConstants.normalAnimation,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    return Container(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Text(
            'Welcome to China Prices',
            style: GoogleFonts.poppins(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                mobile: 20,
                tablet: 24,
                desktop: 28,
              ),
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) / 2),
          Text(
            'Discover the best deals across Chinese e-commerce platforms',
            style: GoogleFonts.poppins(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),
              color: AppConstants.textSecondaryColor,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          
          // Quick actions
          _buildQuickActions(),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          
          // Featured content or banner
          Expanded(
            child: _buildFeaturedContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.search, 'label': 'Search Products', 'onTap': () => _navigateToSearch()},
      {'icon': Icons.favorite, 'label': 'Favorites', 'onTap': () => _navigateToFavorites()},
      {'icon': Icons.history, 'label': 'History', 'onTap': () => _navigateToHistory()},
      {'icon': Icons.trending_up, 'label': 'Trending', 'onTap': () => _navigateToTrending()},
    ];

    return Wrap(
      spacing: ResponsiveUtils.getResponsiveSpacing(context),
      runSpacing: ResponsiveUtils.getResponsiveSpacing(context),
      children: actions.map((action) {
        return _buildQuickActionCard(
          icon: action['icon'] as IconData,
          label: action['label'] as String,
          onTap: action['onTap'] as VoidCallback,
        );
      }).toList(),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        ResponsiveUtils.getResponsiveBorderRadius(context),
      ),
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: ResponsiveUtils.getResponsiveCardElevation(context),
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: ResponsiveUtils.getResponsiveIconSize(context),
              color: AppConstants.primaryColor,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) / 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
                fontWeight: FontWeight.w500,
                color: AppConstants.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().scale(
      duration: AppConstants.fastAnimation,
      curve: Curves.easeOutBack,
    );
  }

  Widget _buildFeaturedContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppConstants.backgroundGradient,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getResponsiveBorderRadius(context),
        ),
      ),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured Deals',
              style: GoogleFonts.poppins(
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  mobile: 18,
                  tablet: 20,
                  desktop: 22,
                ),
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimaryColor,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_offer,
                      size: ResponsiveUtils.getResponsiveIconSize(context) * 2,
                      color: AppConstants.primaryColor.withOpacity(0.6),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                    Text(
                      'Discover amazing deals',
                      style: GoogleFonts.poppins(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                        color: AppConstants.textSecondaryColor,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) / 2),
                    ElevatedButton(
                      onPressed: () => _navigateToSearch(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 2,
                          vertical: ResponsiveUtils.getResponsiveSpacing(context),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.getResponsiveBorderRadius(context),
                          ),
                        ),
                      ),
                      child: Text(
                        'Start Shopping',
                        style: GoogleFonts.poppins(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 18,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(String categoryName) {
    final searchTerms = _getCategorySearchTerms(categoryName);
    final jsonUrl = AppConstants.getCategoryJsonUrl(categoryName);
    
    Navigator.of(context).pushNamed(
      AppRoutes.categoryProducts,
      arguments: {
        'categoryName': categoryName,
        'searchTerms': searchTerms,
        'jsonUrl': jsonUrl,
      },
    );
  }

  void _navigateToSearch() {
    Navigator.of(context).pushNamed(AppRoutes.advancedSearch);
  }

  void _navigateToFavorites() {
    Navigator.of(context).pushNamed(AppRoutes.favorites);
  }

  void _navigateToHistory() {
    Navigator.of(context).pushNamed(AppRoutes.historyRecommendations);
  }

  void _navigateToTrending() {
    Navigator.of(context).pushNamed(AppRoutes.fashionCarousel);
  }

  List<String> _getCategorySearchTerms(String categoryName) {
    // Define search terms for each category
    final categorySearchTerms = {
      'Electronics': ['phone', 'laptop', 'tablet', 'camera'],
      'Fashion': ['dress', 'shirt', 'shoes', 'bag'],
      'Home & Garden': ['furniture', 'decor', 'kitchen', 'garden'],
      'Sports': ['fitness', 'outdoor', 'equipment', 'clothing'],
      'Toys & Games': ['educational', 'creative', 'puzzle', 'board'],
      'Beauty': ['skincare', 'makeup', 'hair', 'fragrance'],
      'Automotive': ['car', 'motorcycle', 'accessories', 'parts'],
      'Health': ['vitamins', 'supplements', 'wellness', 'fitness'],
      'Books': ['fiction', 'non-fiction', 'educational', 'children'],
    };

    return categorySearchTerms[categoryName] ?? [categoryName.toLowerCase()];
  }
}
