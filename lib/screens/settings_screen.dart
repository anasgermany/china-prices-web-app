import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';
import '../services/url_launcher_service.dart';
import '../routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
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
          AppConstants.settingsTitle,
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeaderSection(),
                const SizedBox(height: 32),

                // Contact Us Section
                _buildContactSection(),
                const SizedBox(height: 24),

                // Legal Section
                _buildLegalSection(),
                const SizedBox(height: 24),

                // App Rating Section
                _buildRatingSection(),
                const SizedBox(height: 24),

                // About App Section
                _buildAboutSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
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
              Icons.settings_rounded,
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
                  AppConstants.settingsTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Customize your experience',
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

  Widget _buildContactSection() {

    return _buildSectionCard(
      title: AppConstants.contactUsTitle,
      subtitle: AppConstants.contactUsSubtitle,
      icon: Icons.email_rounded,
      iconColor: AppConstants.settingsAccentColor,
      children: [
        _buildSettingTile(
          icon: Icons.email_outlined,
          title: AppConstants.sendEmailText,
          subtitle: AppConstants.supportEmail,
          onTap: () => _sendEmail(),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppConstants.settingsSubtextColor,
            size: 16,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3);
  }

  Widget _buildLegalSection() {
    return _buildSectionCard(
      title: 'Legal',
      subtitle: 'Terms and policies',
      icon: Icons.gavel_rounded,
      iconColor: AppConstants.settingsSecondaryColor,
      children: [
        _buildSettingTile(
          icon: Icons.privacy_tip_outlined,
          title: AppConstants.privacyPolicyText,
          subtitle: 'Read our privacy policy',
          onTap: () => _openPrivacyPolicy(),
          trailing: Icon(
            Icons.open_in_new,
            color: AppConstants.settingsSubtextColor,
            size: 16,
          ),
        ),
        const SizedBox(height: 8),
        _buildSettingTile(
          icon: Icons.description_outlined,
          title: AppConstants.termsOfServiceText,
          subtitle: 'Read our terms of service',
          onTap: () => _openTermsOfService(),
          trailing: Icon(
            Icons.open_in_new,
            color: AppConstants.settingsSubtextColor,
            size: 16,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3);
  }

  Widget _buildRatingSection() {
    return _buildSectionCard(
      title: AppConstants.rateAppText,
      subtitle: AppConstants.rateAppSubtitle,
      icon: Icons.star_rounded,
      iconColor: Colors.amber,
      children: [
        _buildSettingTile(
          icon: Icons.star_outline,
          title: 'Rate on Google Play',
          subtitle: 'Help us grow with 5 stars!',
          onTap: () => _rateApp(),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) => 
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3);
  }

  Widget _buildAboutSection() {
    return _buildSectionCard(
      title: AppConstants.aboutAppText,
      subtitle: AppConstants.aboutAppDescription,
      icon: Icons.info_rounded,
      iconColor: AppConstants.settingsPrimaryColor,
      children: [
                  _buildSettingTile(
            icon: Icons.notifications_outlined,
            title: 'Notification Settings',
            subtitle: 'Configure smart notifications',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.notificationSettings),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppConstants.settingsSubtextColor,
              size: 16,
            ),
          ),
          const SizedBox(height: 8),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: AppConstants.appVersionText,
            subtitle: AppConstants.appVersion,
            onTap: null,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.settingsPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AppConstants.appVersion,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.settingsPrimaryColor,
                ),
              ),
            ),
          ),
      ],
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3);
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
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
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
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
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    required Widget trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: onTap != null 
                ? AppConstants.settingsBackgroundColor 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppConstants.settingsSubtextColor.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppConstants.settingsSubtextColor,
                size: 20,
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
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppConstants.settingsSubtextColor,
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  void _sendEmail() async {
    try {
      _showSnackBar('Opening email app...');
      
      // Create subject with prefix for easy identification
      final subject = '${AppConstants.emailSubjectPrefix} ${AppConstants.emailSubjectDefault}';
      
      final success = await UrlLauncherService().sendEmail(
        AppConstants.supportEmail,
        subject: subject,
        body: AppConstants.emailBodyTemplate,
      );
      
      if (!success) {
        _showSnackBar('No email app found. Please install Gmail, Outlook, or another email app and try again.');
      }
    } catch (e) {
      print('Email error: $e');
      _showSnackBar('Email app not available. Please install an email app (Gmail, Outlook, etc.) and try again.');
    }
  }

  void _openPrivacyPolicy() async {
    await UrlLauncherService().openUrl(AppConstants.privacyPolicyUrl);
  }

  void _openTermsOfService() async {
    await UrlLauncherService().openUrl(AppConstants.termsOfServiceUrl);
  }

  void _rateApp() async {
    await UrlLauncherService().openUrl(AppConstants.appStoreUrl);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppConstants.settingsPrimaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
