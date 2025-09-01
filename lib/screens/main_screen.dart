import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/app_provider.dart';
import '../utils/responsive_utils.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'history_recommendations_screen.dart';
import 'gamification_screen.dart';
import 'fashion_carousel_screen.dart';
import 'placeholder_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoritesScreen(),
    const HistoryRecommendationsScreen(),
    const GamificationScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home,
      label: 'Home',
      route: '/home',
    ),
    NavigationItem(
      icon: Icons.search,
      label: 'Search',
      route: '/search',
    ),
    NavigationItem(
      icon: Icons.favorite,
      label: 'Favorites',
      route: '/favorites',
    ),
    NavigationItem(
      icon: Icons.history,
      label: 'History',
      route: '/history',
    ),
    NavigationItem(
      icon: Icons.emoji_events,
      label: 'Rewards',
      route: '/rewards',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _loadGamificationData();
  }

  void _loadGamificationData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.loadGamificationData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    
    // Track app click for analytics
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.trackAppClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (ResponsiveUtils.isDesktop(context)) {
            return _buildDesktopLayout();
          } else if (ResponsiveUtils.isTablet(context)) {
            return _buildTabletLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left sidebar navigation
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: AppConstants.surfaceColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: _buildSidebarNavigation(),
        ),
        // Main content area
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: _screens,
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        // Top navigation bar
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppConstants.surfaceColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildTopNavigation(),
        ),
        // Main content area
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: _screens,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Main content area
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: _screens,
          ),
        ),
        // Bottom navigation bar
        Container(
          decoration: BoxDecoration(
            color: AppConstants.surfaceColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: _buildBottomNavigation(),
        ),
      ],
    );
  }

  Widget _buildSidebarNavigation() {
    return Column(
      children: [
        // App header
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.shopping_cart,
                size: 48,
                color: AppConstants.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                AppConstants.appName,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
              Text(
                'Price Comparison',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppConstants.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        
        // Navigation items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: _navigationItems.length,
            itemBuilder: (context, index) {
              final item = _navigationItems[index];
              final isSelected = _currentIndex == index;
              
              return _buildSidebarNavigationItem(item, index, isSelected);
            },
          ),
        ),
        
        // Bottom section
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Divider(height: 1),
              const SizedBox(height: 16),
              _buildSidebarActionButton(
                icon: Icons.checkroom_rounded,
                label: 'Fashion Carousel',
                onTap: () => _navigateToFashionCarousel(),
              ),
              const SizedBox(height: 12),
              _buildSidebarActionButton(
                icon: Icons.settings,
                label: 'Settings',
                onTap: () => _navigateToSettings(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarNavigationItem(NavigationItem item, int index, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onTabTapped(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppConstants.primaryColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(
                color: AppConstants.primaryColor.withOpacity(0.3),
                width: 1,
              ) : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 24,
                  color: isSelected ? AppConstants.primaryColor : AppConstants.textSecondaryColor,
                ),
                const SizedBox(width: 16),
                Text(
                  item.label,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppConstants.primaryColor : AppConstants.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: AppConstants.textSecondaryColor,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Row(
      children: [
        // App logo and title
        Expanded(
          child: Row(
            children: [
              const SizedBox(width: 24),
              Icon(
                Icons.shopping_cart,
                size: 32,
                color: AppConstants.primaryColor,
              ),
              const SizedBox(width: 16),
              Text(
                AppConstants.appName,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        
        // Navigation tabs
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = _currentIndex == index;
              
              return _buildTopNavigationTab(item, index, isSelected);
            }).toList(),
          ),
        ),
        
        // Right side actions
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildTopActionButton(
                icon: Icons.checkroom_rounded,
                onTap: () => _navigateToFashionCarousel(),
              ),
              const SizedBox(width: 16),
              _buildTopActionButton(
                icon: Icons.settings,
                onTap: () => _navigateToSettings(),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopNavigationTab(NavigationItem item, int index, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onTabTapped(index),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppConstants.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isSelected ? Colors.white : AppConstants.textSecondaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  item.label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppConstants.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 24,
            color: AppConstants.textSecondaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return SafeArea(
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _navigationItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = _currentIndex == index;
            
            return _buildBottomNavigationItem(item, index, isSelected);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationItem(NavigationItem item, int index, bool isSelected) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onTabTapped(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 24,
                  color: isSelected ? AppConstants.primaryColor : AppConstants.textSecondaryColor,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppConstants.primaryColor : AppConstants.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    // Only show FAB on mobile
    if (!ResponsiveUtils.isMobile(context)) {
      return const SizedBox.shrink();
    }
    
    return FloatingActionButton(
      onPressed: () {
        // Track app click for analytics
        final provider = Provider.of<AppProvider>(context, listen: false);
        provider.trackAppClick();
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const FashionCarouselScreen(),
          ),
        );
      },
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
      elevation: 8,
      child: const Icon(
        Icons.checkroom_rounded,
        size: 28,
      ),
    );
  }

  void _navigateToFashionCarousel() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FashionCarouselScreen(),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.of(context).pushNamed('/settings');
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
