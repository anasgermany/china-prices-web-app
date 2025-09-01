import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../models/filter_model.dart';

class AdvancedFilterWidget extends StatefulWidget {
  final ProductFilter currentFilter;
  final Map<String, dynamic> filterStats;
  final List<String> availableCategories;
  final Function(ProductFilter) onFilterChanged;
  final VoidCallback onClearFilters;

  const AdvancedFilterWidget({
    super.key,
    required this.currentFilter,
    required this.filterStats,
    required this.availableCategories,
    required this.onFilterChanged,
    required this.onClearFilters,
  });

  @override
  State<AdvancedFilterWidget> createState() => _AdvancedFilterWidgetState();
}

class _AdvancedFilterWidgetState extends State<AdvancedFilterWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  RangeValues _priceRange = const RangeValues(0, 100);
  RangeValues _discountRange = const RangeValues(0, 100);

  List<String> _selectedCategories = [];
  bool _hasDiscount = false;
  bool _isHotSale = false;
  bool _isTopRated = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeControllers();
    _loadCurrentFilter();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  void _initializeControllers() {
    // No search controller needed
  }

  void _loadCurrentFilter() {
    setState(() {
      _selectedCategories = List.from(widget.currentFilter.categories);
      _hasDiscount = widget.currentFilter.hasDiscount;
      _isHotSale = widget.currentFilter.isHotSale;
      _isTopRated = widget.currentFilter.isTopRated;

      if (widget.currentFilter.minPrice != null && widget.currentFilter.maxPrice != null) {
        _priceRange = RangeValues(
          widget.currentFilter.minPrice!,
          widget.currentFilter.maxPrice!,
        );
      }

      if (widget.currentFilter.minDiscount != null && widget.currentFilter.maxDiscount != null) {
        _discountRange = RangeValues(
          widget.currentFilter.minDiscount!,
          widget.currentFilter.maxDiscount!,
        );
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final filter = ProductFilter(
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      minDiscount: _discountRange.start,
      maxDiscount: _discountRange.end,
      categories: _selectedCategories,
      hasDiscount: _hasDiscount,
      isHotSale: _isHotSale,
      isTopRated: _isTopRated,
    );

    widget.onFilterChanged(filter);
  }

  void _clearFilters() {
    setState(() {
      _selectedCategories.clear();
      _hasDiscount = false;
      _isHotSale = false;
      _isTopRated = false;
      _priceRange = const RangeValues(0, 100);
      _discountRange = const RangeValues(0, 100);
    });

    widget.onClearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppConstants.surfaceColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildQuickFilters(),
                const SizedBox(height: 12),
                _buildPriceFilter(),
                const SizedBox(height: 12),
                _buildCategoryFilter(),
                const SizedBox(height: 12),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.primaryColor,
                    AppConstants.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.tune,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Advanced Filters',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimaryColor,
              ),
            ),
          ],
        ),
        if (widget.currentFilter.hasActiveFilters)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Active',
              style: GoogleFonts.poppins(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuickFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Filters',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _buildFilterChip(
              'Has Discount',
              _hasDiscount,
              Icons.local_offer,
              AppConstants.errorColor,
              (value) {
                setState(() {
                  _hasDiscount = value;
                });
                _applyFilter();
              },
            ),
            _buildFilterChip(
              'Hot Sale',
              _isHotSale,
              Icons.whatshot,
              Colors.orange,
              (value) {
                setState(() {
                  _isHotSale = value;
                });
                _applyFilter();
              },
            ),
            _buildFilterChip(
              'Top Rated',
              _isTopRated,
              Icons.star,
              Colors.amber,
              (value) {
                setState(() {
                  _isTopRated = value;
                });
                _applyFilter();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, IconData icon, Color color, Function(bool) onChanged) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isSelected ? Colors.white : color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : AppConstants.textPrimaryColor,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: onChanged,
      backgroundColor: AppConstants.backgroundColor,
      selectedColor: color,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected ? color : AppConstants.textSecondaryColor.withOpacity(0.3),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ).animate().scale(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 100,
          divisions: 100,
          activeColor: AppConstants.primaryColor,
          inactiveColor: AppConstants.textSecondaryColor.withOpacity(0.3),
          labels: RangeLabels(
            '\$${_priceRange.start.toStringAsFixed(1)}',
            '\$${_priceRange.end.toStringAsFixed(1)}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
            _applyFilter();
          },
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: widget.availableCategories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(
                category,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppConstants.textPrimaryColor,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
                _applyFilter();
              },
              backgroundColor: AppConstants.backgroundColor,
              selectedColor: AppConstants.primaryColor,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected 
                    ? AppConstants.primaryColor 
                    : AppConstants.textSecondaryColor.withOpacity(0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _clearFilters,
            icon: Icon(
              Icons.clear_all,
              color: AppConstants.textSecondaryColor,
              size: 16,
            ),
            label: Text(
              'Clear All',
              style: GoogleFonts.poppins(
                color: AppConstants.textSecondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.backgroundColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: AppConstants.textSecondaryColor.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _applyFilter,
            icon: Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
            label: Text(
              'Apply Filters',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
