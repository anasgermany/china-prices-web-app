import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../models/gamification_model.dart';

class ChallengeCardWidget extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback? onTap;
  final bool showProgress;

  const ChallengeCardWidget({
    super.key,
    required this.challenge,
    this.onTap,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    final progress = challenge.targetValue > 0 
        ? challenge.currentValue / challenge.targetValue 
        : 0.0;
    final isCompleted = challenge.status == ChallengeStatus.completed;
    final isActive = challenge.status == ChallengeStatus.active;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
          border: isCompleted 
              ? Border.all(color: Colors.green, width: 2)
              : isActive && progress > 0.5
                  ? Border.all(color: Colors.orange, width: 1.5)
                  : null,
        ),
        child: Column(
          children: [
            _buildHeader(),
            if (showProgress) _buildProgress(progress, isCompleted),
            _buildReward(),
          ],
        ),
      ).animate().fadeIn(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ).slideX(
        begin: 0.3,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  challenge.description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppConstants.textSecondaryColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color iconColor;
    Color backgroundColor;

    switch (challenge.type) {
      case ChallengeType.viewProducts:
        iconData = Icons.visibility;
        iconColor = Colors.blue;
        backgroundColor = Colors.blue.withOpacity(0.1);
        break;
      case ChallengeType.addFavorites:
        iconData = Icons.favorite;
        iconColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.1);
        break;
      case ChallengeType.searchProducts:
        iconData = Icons.search;
        iconColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
        break;
      case ChallengeType.shareApp:
        iconData = Icons.share;
        iconColor = Colors.purple;
        backgroundColor = Colors.purple.withOpacity(0.1);
        break;
      case ChallengeType.referFriends:
        iconData = Icons.people;
        iconColor = Colors.orange;
        backgroundColor = Colors.orange.withOpacity(0.1);
        break;

      case ChallengeType.weeklyStreak:
        iconData = Icons.local_fire_department;
        iconColor = Colors.orange;
        backgroundColor = Colors.orange.withOpacity(0.1);
        break;
      case ChallengeType.monthlyGoal:
        iconData = Icons.flag;
        iconColor = Colors.indigo;
        backgroundColor = Colors.indigo.withOpacity(0.1);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Icon(
        iconData,
        size: 28,
        color: iconColor,
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    Color textColor;
    String text;
    IconData icon;

    switch (challenge.status) {
      case ChallengeStatus.active:
        final progress = challenge.targetValue > 0 
            ? challenge.currentValue / challenge.targetValue 
            : 0.0;
        if (progress >= 0.8) {
          badgeColor = Colors.orange;
          textColor = Colors.white;
          text = 'NEARLY DONE';
          icon = Icons.trending_up;
        } else if (progress >= 0.5) {
          badgeColor = Colors.blue;
          textColor = Colors.white;
          text = 'IN PROGRESS';
          icon = Icons.play_arrow;
        } else {
          badgeColor = Colors.grey;
          textColor = Colors.white;
          text = 'STARTED';
          icon = Icons.fiber_manual_record;
        }
        break;
      case ChallengeStatus.completed:
        badgeColor = Colors.green;
        textColor = Colors.white;
        text = 'COMPLETED';
        icon = Icons.check_circle;
        break;
      case ChallengeStatus.expired:
        badgeColor = Colors.red;
        textColor = Colors.white;
        text = 'EXPIRED';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(double progress, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                height: 12,
                width: 200 * progress, // Fixed width calculation
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCompleted 
                        ? [Colors.green, Colors.green.shade400]
                        : progress > 0.8
                            ? [Colors.orange, Colors.orange.shade400]
                            : [AppConstants.primaryColor, AppConstants.primaryColor.withOpacity(0.7)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: (isCompleted ? Colors.green : AppConstants.primaryColor).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Positioned(
                  right: 0,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% Complete',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isCompleted ? Colors.green : AppConstants.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReward() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.green.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.stars,
                  size: 20,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Column(
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (challenge.status == ChallengeStatus.completed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'CLAIMED',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                'PENDING',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
