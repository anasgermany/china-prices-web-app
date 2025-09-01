import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/notification_service.dart';
import '../services/app_provider.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _notificationsEnabled = false;
  bool _priceDropAlerts = true;
  bool _personalizedAlerts = true;
  bool _dailyDeals = true;
  bool _isLoading = true;

  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadNotificationSettings();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: AppConstants.normalAnimation,
      vsync: this,
    );
    _slideController = AnimationController(
      duration: AppConstants.normalAnimation,
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
  }

  Future<void> _loadNotificationSettings() async {
    try {
      final enabled = await _notificationService.areNotificationsEnabled();
      setState(() {
        _notificationsEnabled = enabled;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notification settings: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.settingsBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppConstants.settingsTextColor,
          ),
        ),
        backgroundColor: AppConstants.settingsCardColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppConstants.settingsTextColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: 32),
                      _buildNotificationStatusCard(),
                      const SizedBox(height: 24),
                      _buildNotificationTypesSection(),
                      const SizedBox(height: 24),
                      _buildTestNotificationSection(),
                      const SizedBox(height: 24),
                      _buildNotificationInfoSection(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppConstants.settingsPrimaryColor),
          ).animate().scale(duration: 600.ms).then().shake(),
          const SizedBox(height: 16),
          Text(
            'Loading notification settings...',
            style: GoogleFonts.poppins(
              color: AppConstants.settingsSubtextColor,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.settingsPrimaryColor,
            AppConstants.settingsSecondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConstants.settingsPrimaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Notifications',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stay updated with price drops and deals',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3);
  }

  Widget _buildNotificationStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.settingsCardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _notificationsEnabled
                      ? AppConstants.successColor.withOpacity(0.1)
                      : AppConstants.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _notificationsEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  color: _notificationsEnabled
                      ? AppConstants.successColor
                      : AppConstants.errorColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications Status',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.settingsTextColor,
                      ),
                    ),
                    Text(
                      _notificationsEnabled
                          ? 'Notifications are enabled'
                          : 'Notifications are disabled',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppConstants.settingsSubtextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!_notificationsEnabled)
            ElevatedButton(
              onPressed: _requestNotificationPermissions,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.settingsPrimaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Enable Notifications',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3);
  }

  Widget _buildNotificationTypesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.settingsCardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.settingsAccentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.tune,
                  color: AppConstants.settingsAccentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Notification Types',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.settingsTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildNotificationTypeSwitch(
            icon: Icons.trending_down,
            title: 'Price Drop Alerts',
            subtitle: 'Get notified when products you searched for drop in price',
            value: _priceDropAlerts,
            onChanged: (value) => setState(() => _priceDropAlerts = value),
            color: AppConstants.successColor,
          ),
          const SizedBox(height: 12),
          _buildNotificationTypeSwitch(
            icon: Icons.person,
            title: 'Personalized Alerts',
            subtitle: 'Receive notifications based on your search history',
            value: _personalizedAlerts,
            onChanged: (value) => setState(() => _personalizedAlerts = value),
            color: AppConstants.settingsPrimaryColor,
          ),
          const SizedBox(height: 12),
          _buildNotificationTypeSwitch(
            icon: Icons.local_offer,
            title: 'Daily Deals',
            subtitle: 'Get daily notifications about the best deals',
            value: _dailyDeals,
            onChanged: (value) => setState(() => _dailyDeals = value),
            color: AppConstants.settingsSecondaryColor,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3);
  }

  Widget _buildNotificationTypeSwitch({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value
            ? color.withOpacity(0.05)
            : AppConstants.settingsBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? color.withOpacity(0.2) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.settingsTextColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppConstants.settingsSubtextColor,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
            activeTrackColor: color.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildTestNotificationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.settingsCardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.science,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Test Notifications',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.settingsTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Send a test notification to verify everything is working correctly.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppConstants.settingsSubtextColor,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _notificationsEnabled ? _showTestNotification : null,
                      icon: Icon(Icons.notifications),
                      label: Text(
                        'Send Test Notification',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _notificationsEnabled ? _startAutomaticNotifications : null,
                      icon: Icon(Icons.auto_awesome),
                                              label: Text(
                          'Start Auto ${AppConstants.automaticNotificationIntervalHours}h ${AppConstants.automaticNotificationIntervalMinutes}m ${AppConstants.automaticNotificationIntervalSeconds}s',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.settingsPrimaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
                               SizedBox(
                   width: double.infinity,
                   child: ElevatedButton.icon(
                     onPressed: _checkNotificationStatus,
                     icon: Icon(Icons.info),
                     label: Text(
                       'Check Notification Status',
                       style: GoogleFonts.poppins(
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                     style: ElevatedButton.styleFrom(
                       backgroundColor: AppConstants.infoColor,
                       foregroundColor: Colors.white,
                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12),
                       ),
                     ),
                   ),
                 ),
                 const SizedBox(height: 12),
                 SizedBox(
                   width: double.infinity,
                   child: ElevatedButton.icon(
                     onPressed: _checkPendingNotifications,
                     icon: Icon(Icons.list),
                     label: Text(
                       'Check Pending Notifications',
                       style: GoogleFonts.poppins(
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.orange,
                       foregroundColor: Colors.white,
                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12),
                       ),
                     ),
                   ),
                 ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3);
  }

  Widget _buildNotificationInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.settingsCardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.infoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: AppConstants.infoColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'How It Works',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.settingsTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            icon: Icons.search,
            title: 'Smart Detection',
            description: 'We analyze your search history to find relevant products',
          ),
          const SizedBox(height: 8),
          _buildInfoItem(
            icon: Icons.trending_down,
            title: 'Price Monitoring',
            description: 'We track price changes and notify you of drops',
          ),
          const SizedBox(height: 8),
          _buildInfoItem(
            icon: Icons.schedule,
            title: '6-Hour Intervals',
            description: 'Notifications are sent every 6 hours to avoid spam',
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3);
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppConstants.settingsSubtextColor,
          size: 16,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.settingsTextColor,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppConstants.settingsSubtextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _requestNotificationPermissions() async {
    try {
      final granted = await _notificationService.requestPermissions();
      setState(() {
        _notificationsEnabled = granted;
      });

      if (granted) {
        // Schedule notifications after permission is granted
        await _notificationService.scheduleRecurringNotifications();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Notifications enabled successfully!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: AppConstants.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Notification permission denied. Please enable in settings.',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: AppConstants.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Error requesting notification permissions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error enabling notifications: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppConstants.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showTestNotification() async {
    try {
      await _notificationService.showTestNotification();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Test notification sent!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppConstants.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error sending test notification: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppConstants.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

            Future<void> _scheduleTestNotification() async {
    try {
      await _notificationService.scheduleTestNotification();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Test notification scheduled for 30 seconds from now!',
            style: GoogleFonts.poppins(),
        ),
          backgroundColor: AppConstants.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error scheduling test notification: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppConstants.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _startAutomaticNotifications() async {
    try {
      await _notificationService.scheduleRecurringNotifications();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Automatic notifications started! You\'ll receive notifications every ${AppConstants.automaticNotificationIntervalHours}h ${AppConstants.automaticNotificationIntervalMinutes}m ${AppConstants.automaticNotificationIntervalSeconds}s with random product deals!',
            style: GoogleFonts.poppins(),
        ),
          backgroundColor: AppConstants.successColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error starting automatic notifications: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppConstants.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _checkNotificationStatus() async {
    try {
      await _notificationService.checkNotificationStatus();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Notification status checked! Check terminal for details.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppConstants.infoColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error checking notification status: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppConstants.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _checkPendingNotifications() async {
    try {
      await _notificationService.getPendingNotifications();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '📋 Check terminal for pending notifications list!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppConstants.infoColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error checking pending notifications: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppConstants.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
