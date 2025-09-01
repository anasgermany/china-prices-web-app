import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../constants/app_constants.dart';
import '../models/gamification_model.dart';
import '../services/app_provider.dart';
import '../widgets/challenge_card_widget.dart';
import '../widgets/banner_ad_widget.dart';
import '../routes.dart';

class GamificationScreen extends StatefulWidget {
  const GamificationScreen({super.key});

  @override
  State<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends State<GamificationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadGamificationData();
  }

  void _initializeControllers() {
    _tabController = TabController(length: 4, vsync: this);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  void _loadGamificationData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.loadGamificationData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          '🎯 Rewards & Challenges',
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
            icon: const Icon(Icons.refresh, color: AppConstants.textPrimaryColor),
            onPressed: () async {
              final provider = Provider.of<AppProvider>(context, listen: false);
              await provider.loadGamificationData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.bug_report, color: AppConstants.textPrimaryColor),
            onPressed: () {
              final provider = Provider.of<AppProvider>(context, listen: false);
              _showDebugInfo(context, provider);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppConstants.primaryColor,
          labelColor: AppConstants.primaryColor,
          unselectedLabelColor: AppConstants.textSecondaryColor,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.emoji_events), text: 'Challenges'),
            // Tab(icon: Icon(Icons.workspace_premium), text: 'Badges'),
            Tab(icon: Icon(Icons.stars), text: 'Points'),
            Tab(icon: Icon(Icons.people), text: 'Referrals'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildChallengesTab(),
            // _buildBadgesTab(),
            _buildPointsTab(),
            _buildReferralsTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengesTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final challenges = provider.challenges;
        
        if (challenges.isEmpty) {
          return _buildEmptyState(
            'No Challenges Available',
            'Complete daily tasks to earn points and unlock rewards!',
            Icons.emoji_events,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await provider.loadGamificationData();
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _buildChallengesHeader(provider),
              const SizedBox(height: 16),
              ...challenges.map((challenge) => ChallengeCardWidget(
                challenge: challenge,
                onTap: () => _showChallengeDetails(challenge),
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChallengesHeader(AppProvider provider) {
    final completedChallenges = provider.challenges.where((c) => c.status == ChallengeStatus.completed).length;
    final totalChallenges = provider.challenges.length;
    final completionRate = totalChallenges > 0 ? (completedChallenges / totalChallenges) : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Progress',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completedChallenges of $totalChallenges completed',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${(completionRate * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: completionRate,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
            minHeight: 8,
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    ).slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildBadgesTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final badges = provider.badges;
        
        if (badges.isEmpty) {
          return _buildEmptyState(
            'No Badges Yet',
            'Complete challenges to unlock amazing badges!',
            Icons.workspace_premium,
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildBadgesHeader(provider),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: badges.length,
              itemBuilder: (context, index) {
                final badge = badges[index];
                return _buildBadgeCard(badge, index);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBadgesHeader(AppProvider provider) {
    final unlockedBadges = provider.badges.where((b) => b.isUnlocked).length;
    final totalBadges = provider.badges.length;
    final unlockRate = totalBadges > 0 ? (unlockedBadges / totalBadges) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Badge Collection',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$unlockedBadges of $totalBadges unlocked',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: unlockRate,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            minHeight: 8,
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    ).slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildBadgeCard(GamificationBadge badge, int index) {
    return GestureDetector(
      onTap: () => _showBadgeDetails(badge),
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: badge.isUnlocked 
              ? Border.all(color: badge.rarityColor, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: badge.isUnlocked 
                    ? badge.rarityColor.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getBadgeIcon(badge.type),
                size: 48,
                color: badge.isUnlocked 
                    ? badge.rarityColor
                    : Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              badge.name,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: badge.isUnlocked 
                    ? AppConstants.textPrimaryColor
                    : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              badge.description,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: AppConstants.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badge.isUnlocked 
                    ? badge.rarityColor.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge.rarity.name.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: badge.isUnlocked 
                      ? badge.rarityColor
                      : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (badge.isUnlocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 12,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'UNLOCKED',
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'LOCKED',
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ).animate().fadeIn(
        duration: const Duration(milliseconds: 300),
        delay: Duration(milliseconds: index * 100),
        curve: Curves.easeInOut,
      ).scale(
        begin: const Offset(0.8, 0.8),
        duration: const Duration(milliseconds: 300),
        delay: Duration(milliseconds: index * 100),
        curve: Curves.easeOutBack,
      ),
    );
  }

  Widget _buildPointsTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final userPoints = provider.userPoints;
        
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildPointsHeader(userPoints),
            const SizedBox(height: 24),
            _buildPointsStats(userPoints),
            const SizedBox(height: 24),
            _buildRecentTransactions(userPoints),
          ],
        );
      },
    );
  }

  Widget _buildPointsHeader(UserPoints userPoints) {
    final progressToNextLevel = userPoints.currentPoints / userPoints.pointsToNextLevel;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purple.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${userPoints.level}',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${userPoints.currentPoints} / ${userPoints.pointsToNextLevel} XP',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.stars,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress to Level ${userPoints.level + 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textPrimaryColor,
                    ),
                  ),
                  Text(
                    '${(progressToNextLevel * 100).toInt()}%',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progressToNextLevel,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                minHeight: 10,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    ).slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildPointsStats(UserPoints userPoints) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Points',
                  '${userPoints.totalPoints}',
                  Icons.stars,
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  'Current Points',
                  '${userPoints.currentPoints}',
                  Icons.point_of_sale,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppConstants.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(UserPoints userPoints) {
    final recentTransactions = userPoints.transactions.take(5).toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          if (recentTransactions.isEmpty)
            _buildEmptyState(
              'No Recent Activity',
              'Complete challenges to see your activity here!',
              Icons.history,
            )
          else
            ...recentTransactions.map((transaction) => _buildTransactionItem(transaction)).toList(),
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildTransactionItem(PointTransaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getTransactionColor(transaction.type).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getTransactionIcon(transaction.type),
              color: _getTransactionColor(transaction.type),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(transaction.timestamp),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${transaction.points}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralsTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final referralSystem = provider.referralSystem;
        
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildReferralsHeader(referralSystem),
                  const SizedBox(height: 24),
                  _buildReferralCode(referralSystem),
                  const SizedBox(height: 24),
                  _buildReferralStats(referralSystem),
                  const SizedBox(height: 24),
                  _buildRecentReferrals(referralSystem),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReferralsHeader(ReferralSystem referralSystem) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.teal.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Referral Program',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Earn rewards by inviting friends!',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildReferralStat(
                  'Total Referrals',
                  '${referralSystem.totalReferrals}',
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReferralStat(
                  'Successful',
                  '${referralSystem.successfulReferrals}',
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReferralStat(
                  'Earnings',
                  '\$${referralSystem.totalEarnings}',
                  Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    ).slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildReferralStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 9,
            color: AppConstants.textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showBadgeDetails(GamificationBadge badge) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                badge.isUnlocked 
                    ? badge.rarityColor.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                AppConstants.surfaceColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Badge Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: badge.isUnlocked 
                      ? badge.rarityColor.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: badge.isUnlocked 
                        ? badge.rarityColor.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getBadgeIcon(badge.type),
                  size: 64,
                  color: badge.isUnlocked 
                      ? badge.rarityColor
                      : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              
              // Badge Name
              Text(
                badge.name,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: badge.isUnlocked 
                      ? AppConstants.textPrimaryColor
                      : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // Badge Description
              Text(
                badge.description,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppConstants.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Rarity Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: badge.isUnlocked 
                      ? badge.rarityColor.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: badge.isUnlocked 
                        ? badge.rarityColor.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${badge.rarity.name.toUpperCase()} BADGE',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: badge.isUnlocked 
                        ? badge.rarityColor
                        : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: badge.isUnlocked 
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: badge.isUnlocked 
                        ? Colors.green.withOpacity(0.3)
                        : Colors.orange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      badge.isUnlocked ? Icons.check_circle : Icons.lock,
                      size: 16,
                      color: badge.isUnlocked ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      badge.isUnlocked ? 'UNLOCKED' : 'LOCKED',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: badge.isUnlocked ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              
              if (badge.isUnlocked && badge.unlockedAt != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Unlocked on ${_formatDate(badge.unlockedAt!)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Close Button
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReferralCode(ReferralSystem referralSystem) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Referral Code',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    referralSystem.referralCode,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primaryColor,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Implement copy to clipboard
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Referral code copied!'),
                        backgroundColor: AppConstants.successColor,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.copy,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildReferralStats(ReferralSystem referralSystem) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Referral Rewards',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildRewardItem(
            'For each successful referral',
            'Earn \$10 + 50 points',
            Icons.monetization_on,
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildRewardItem(
            'Referral milestone (10 friends)',
            'Earn \$100 + 500 points',
            Icons.emoji_events,
            Colors.amber,
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildRewardItem(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
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
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReferrals(ReferralSystem referralSystem) {
    final recentReferrals = referralSystem.referrals.take(5).toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Referrals',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          if (recentReferrals.isEmpty)
            _buildEmptyState(
              'No Referrals Yet',
              'Share your referral code to see referrals here!',
              Icons.people_outline,
            )
          else
            ...recentReferrals.map((referral) => _buildReferralItem(referral)).toList(),
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildReferralItem(Referral referral) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _getReferralStatusColor(referral.status).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getReferralStatusIcon(referral.status),
              color: _getReferralStatusColor(referral.status),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  referral.referredUserName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(referral.referredAt),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: BoxDecoration(
              color: _getReferralStatusColor(referral.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _getReferralStatusText(referral.status),
              style: GoogleFonts.poppins(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: _getReferralStatusColor(referral.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppConstants.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showChallengeDetails(Challenge challenge) {
    final isCompleted = challenge.status == ChallengeStatus.completed;
    final canClaim = isCompleted && !challenge.isClaimed;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getChallengeColor(challenge.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getChallengeIcon(challenge.type),
                color: _getChallengeColor(challenge.type),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                challenge.title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppConstants.textSecondaryColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            
            // Progress Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppConstants.textPrimaryColor,
                        ),
                      ),
                      Text(
                        '${challenge.currentValue}/${challenge.targetValue}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isCompleted ? Colors.green : AppConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: challenge.targetValue > 0 
                        ? challenge.currentValue / challenge.targetValue 
                        : 0.0,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? Colors.green : AppConstants.primaryColor,
                    ),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Reward Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.1),
                    Colors.green.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.stars,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reward',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppConstants.textSecondaryColor,
                          ),
                        ),
                        Text(
                          '${challenge.rewardPoints} Points',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: AppConstants.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (canClaim)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _claimReward(challenge);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Claim Reward',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getBadgeIcon(BadgeType type) {
    switch (type) {
      case BadgeType.firstPurchase:
        return Icons.shopping_cart;
      case BadgeType.productExplorer:
        return Icons.explore;
      case BadgeType.searchMaster:
        return Icons.search;
      case BadgeType.favoriteCollector:
        return Icons.favorite;

      case BadgeType.referralMaster:
        return Icons.people;
      case BadgeType.weeklyStreak:
        return Icons.local_fire_department;
      case BadgeType.monthlyGoal:
        return Icons.flag;
      case BadgeType.socialSharer:
        return Icons.share;
      case BadgeType.bargainHunter:
        return Icons.local_offer;
    }
  }

  IconData _getChallengeIcon(ChallengeType type) {
    switch (type) {
      case ChallengeType.viewProducts:
        return Icons.visibility;
      case ChallengeType.addFavorites:
        return Icons.favorite;
      case ChallengeType.searchProducts:
        return Icons.search;
      case ChallengeType.shareApp:
        return Icons.share;
      case ChallengeType.referFriends:
        return Icons.people;
      case ChallengeType.weeklyStreak:
        return Icons.local_fire_department;
      case ChallengeType.monthlyGoal:
        return Icons.flag;
    }
  }

  Color _getChallengeColor(ChallengeType type) {
    switch (type) {
      case ChallengeType.viewProducts:
        return Colors.blue;
      case ChallengeType.addFavorites:
        return Colors.red;
      case ChallengeType.searchProducts:
        return Colors.green;
      case ChallengeType.shareApp:
        return Colors.purple;
      case ChallengeType.referFriends:
        return Colors.orange;
      case ChallengeType.weeklyStreak:
        return Colors.orange;
      case ChallengeType.monthlyGoal:
        return Colors.indigo;
    }
  }

  void _claimReward(Challenge challenge) {
    // Mark challenge as claimed
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.claimChallenge(challenge.id);
    
    // Show confetti animation and reward dialog
    _showRewardDialog(challenge);
  }

  void _showRewardDialog(Challenge challenge) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ConfettiDialog(
        challenge: challenge,
        onClose: () {
          Navigator.of(context).pop();
          // Navigate to home screen
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        },
      ),
    );
  }

  Color _getTransactionColor(PointType type) {
    switch (type) {
      case PointType.challenge:
        return Colors.blue;
      case PointType.badge:
        return Colors.amber;
      case PointType.referral:
        return Colors.green;
      case PointType.purchase:
        return Colors.purple;

      case PointType.socialShare:
        return Colors.pink;
    }
  }

  IconData _getTransactionIcon(PointType type) {
    switch (type) {
      case PointType.challenge:
        return Icons.emoji_events;
      case PointType.badge:
        return Icons.workspace_premium;
      case PointType.referral:
        return Icons.people;
      case PointType.purchase:
        return Icons.shopping_cart;

      case PointType.socialShare:
        return Icons.share;
    }
  }

  Color _getReferralStatusColor(ReferralStatus status) {
    switch (status) {
      case ReferralStatus.pending:
        return Colors.orange;
      case ReferralStatus.completed:
        return Colors.green;
      case ReferralStatus.expired:
        return Colors.red;
    }
  }

  IconData _getReferralStatusIcon(ReferralStatus status) {
    switch (status) {
      case ReferralStatus.pending:
        return Icons.pending;
      case ReferralStatus.completed:
        return Icons.check_circle;
      case ReferralStatus.expired:
        return Icons.cancel;
    }
  }

  String _getReferralStatusText(ReferralStatus status) {
    switch (status) {
      case ReferralStatus.pending:
        return 'PEND';
      case ReferralStatus.completed:
        return 'DONE';
      case ReferralStatus.expired:
        return 'EXP';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showDebugInfo(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Debug Information',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Challenges (${provider.challenges.length}):',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...provider.challenges.map((challenge) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• ${challenge.title}: ${challenge.currentValue}/${challenge.targetValue} (${challenge.status})',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              )),
              const SizedBox(height: 16),
              Text(
                'Points: ${provider.userPoints.currentPoints}/${provider.userPoints.totalPoints} (Level ${provider.userPoints.level})',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(
                'Badges: ${provider.badges.where((b) => b.isUnlocked).length}/${provider.badges.length} unlocked',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Test tracking methods
              await provider.trackProductView();
              await provider.trackFavoriteAdded();
              await provider.trackSearchPerformed();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Test actions performed!')),
              );
            },
            child: Text('Test Actions'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Settings Header
          Container(
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
                        'App Settings',
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
          ),
          const SizedBox(height: 24),

          // Settings Options
          _buildSettingsOption(
            icon: Icons.email_rounded,
            title: 'Contact Us',
            subtitle: 'Send us an email',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
            color: AppConstants.settingsAccentColor,
          ),
          const SizedBox(height: 12),
          _buildSettingsOption(
            icon: Icons.privacy_tip_rounded,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
            color: AppConstants.settingsSecondaryColor,
          ),
          const SizedBox(height: 12),
          _buildSettingsOption(
            icon: Icons.notifications_rounded,
            title: 'Notification Settings',
            subtitle: 'Configure smart notifications',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.notificationSettings),
            color: AppConstants.settingsAccentColor,
          ),
          const SizedBox(height: 12),
          _buildSettingsOption(
            icon: Icons.star_rounded,
            title: 'Rate App',
            subtitle: 'Help us with 5 stars!',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
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
              Icon(
                Icons.arrow_forward_ios,
                color: AppConstants.settingsSubtextColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfettiDialog extends StatefulWidget {
  final Challenge challenge;
  final VoidCallback onClose;

  const _ConfettiDialog({
    required this.challenge,
    required this.onClose,
  });

  @override
  State<_ConfettiDialog> createState() => _ConfettiDialogState();
}

class _ConfettiDialogState extends State<_ConfettiDialog>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  List<_ConfettiPiece> _confettiPieces = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _createConfettiPieces();
  }

  void _initializeAnimations() {
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _scaleController.forward();
    _confettiController.forward();
  }

  void _createConfettiPieces() {
    _confettiPieces = List.generate(50, (index) {
      return _ConfettiPiece(
        color: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
          Colors.pink,
          Colors.cyan,
        ][index % 8],
        size: math.Random().nextDouble() * 8 + 4,
        left: math.Random().nextDouble() * 400,
        animationDuration: Duration(milliseconds: 2000 + math.Random().nextInt(1000)),
        delay: Duration(milliseconds: math.Random().nextInt(500)),
      );
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti background
        ..._confettiPieces.map((piece) => _buildConfettiPiece(piece)),
        
        // Main dialog
        Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxHeight: 600),
              decoration: BoxDecoration(
                color: AppConstants.surfaceColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with celebration
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.1),
                          Colors.yellow.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Celebration icon
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.celebration,
                            color: Colors.white,
                            size: 32,
                          ),
                        ).animate().scale(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.elasticOut,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        Text(
                          '🎉 Congratulations! 🎉',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          'Challenge Completed!',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppConstants.textSecondaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Challenge info
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppConstants.backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _getChallengeColor(widget.challenge.type).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getChallengeIcon(widget.challenge.type),
                                  color: _getChallengeColor(widget.challenge.type),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.challenge.title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppConstants.textPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.challenge.description,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: AppConstants.textSecondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Reward section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.withOpacity(0.1),
                                Colors.green.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.stars,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${widget.challenge.rewardPoints} Points Earned!',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Special reward based on challenge type
                              _buildSpecialReward(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: widget.onClose,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'Claim & Continue',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfettiPiece(_ConfettiPiece piece) {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        final progress = _confettiController.value;
        final delayProgress = piece.delay.inMilliseconds / 500.0;
        final adjustedProgress = math.max(0, (progress - delayProgress) / (1 - delayProgress));
        
        if (adjustedProgress <= 0) return const SizedBox.shrink();
        
        final top = 200 + (adjustedProgress * 600);
        final rotation = adjustedProgress * 720;
        
        return Positioned(
          left: piece.left,
          top: top.toDouble(),
          child: Transform.rotate(
            angle: rotation * math.pi / 180,
            child: Container(
              width: piece.size,
              height: piece.size,
              decoration: BoxDecoration(
                color: piece.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpecialReward() {
    switch (widget.challenge.type) {
      case ChallengeType.addFavorites:
        return _buildCouponReward('FAVORITE30', '30% OFF', 'First Purchase');
      case ChallengeType.viewProducts:
        return _buildCouponReward('EXPLORE25', '25% OFF', 'Any Product');
      case ChallengeType.searchProducts:
        return _buildCouponReward('SEARCH20', '20% OFF', 'Search Results');
      case ChallengeType.shareApp:
        return _buildCouponReward('SHARE40', '40% OFF', 'Shared Products');
      default:
        return _buildCouponReward('REWARD15', '15% OFF', 'Any Purchase');
    }
  }

  Widget _buildCouponReward(String code, String discount, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '🎫 Special Coupon',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$discount on $description',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppConstants.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getChallengeIcon(ChallengeType type) {
    switch (type) {
      case ChallengeType.viewProducts:
        return Icons.visibility;
      case ChallengeType.addFavorites:
        return Icons.favorite;
      case ChallengeType.searchProducts:
        return Icons.search;
      case ChallengeType.shareApp:
        return Icons.share;
      case ChallengeType.referFriends:
        return Icons.people;
      case ChallengeType.weeklyStreak:
        return Icons.local_fire_department;
      case ChallengeType.monthlyGoal:
        return Icons.flag;
    }
  }

  Color _getChallengeColor(ChallengeType type) {
    switch (type) {
      case ChallengeType.viewProducts:
        return Colors.blue;
      case ChallengeType.addFavorites:
        return Colors.red;
      case ChallengeType.searchProducts:
        return Colors.green;
      case ChallengeType.shareApp:
        return Colors.purple;
      case ChallengeType.referFriends:
        return Colors.orange;
      case ChallengeType.weeklyStreak:
        return Colors.orange;
      case ChallengeType.monthlyGoal:
        return Colors.indigo;
    }
  }

}

class _ConfettiPiece {
  final Color color;
  final double size;
  final double left;
  final Duration animationDuration;
  final Duration delay;

  _ConfettiPiece({
    required this.color,
    required this.size,
    required this.left,
    required this.animationDuration,
    required this.delay,
  });
}
