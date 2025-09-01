import 'package:flutter/material.dart';

class Challenge {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int targetValue;
  final int currentValue;
  final int rewardPoints;
  final ChallengeType type;
  final ChallengeStatus status;
  final DateTime? completedAt;
  final DateTime expiresAt;
  final bool isClaimed;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.targetValue,
    this.currentValue = 0,
    required this.rewardPoints,
    required this.type,
    this.status = ChallengeStatus.active,
    this.completedAt,
    required this.expiresAt,
    this.isClaimed = false,
  });

  bool get isCompleted => status == ChallengeStatus.completed;
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  double get progress => targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? targetValue,
    int? currentValue,
    int? rewardPoints,
    ChallengeType? type,
    ChallengeStatus? status,
    DateTime? completedAt,
    DateTime? expiresAt,
    bool? isClaimed,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      type: type ?? this.type,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'rewardPoints': rewardPoints,
      'type': type.toString(),
      'status': status.toString(),
      'completedAt': completedAt?.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isClaimed': isClaimed,
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      targetValue: json['targetValue'],
      currentValue: json['currentValue'] ?? 0,
      rewardPoints: json['rewardPoints'],
      type: ChallengeType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ChallengeType.viewProducts,
      ),
      status: ChallengeStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => ChallengeStatus.active,
      ),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      expiresAt: DateTime.parse(json['expiresAt']),
      isClaimed: json['isClaimed'] ?? false,
    );
  }
}

enum ChallengeType {
  viewProducts,
  addFavorites,
  searchProducts,
  shareApp,
  referFriends,
  weeklyStreak,
  monthlyGoal,
}

enum ChallengeStatus {
  active,
  completed,
  expired,
}

class GamificationBadge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final BadgeType type;
  final BadgeRarity rarity;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int requiredValue;

  GamificationBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.rarity,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.requiredValue,
  });

  Color get rarityColor {
    switch (rarity) {
      case BadgeRarity.common:
        return Colors.grey;
      case BadgeRarity.rare:
        return Colors.blue;
      case BadgeRarity.epic:
        return Colors.purple;
      case BadgeRarity.legendary:
        return Colors.orange;
    }
  }

  GamificationBadge copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    BadgeType? type,
    BadgeRarity? rarity,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? requiredValue,
  }) {
    return GamificationBadge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      requiredValue: requiredValue ?? this.requiredValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'type': type.toString(),
      'rarity': rarity.toString(),
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'requiredValue': requiredValue,
    };
  }

  factory GamificationBadge.fromJson(Map<String, dynamic> json) {
    return GamificationBadge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      type: BadgeType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => BadgeType.firstPurchase,
      ),
      rarity: BadgeRarity.values.firstWhere(
        (e) => e.toString() == json['rarity'],
        orElse: () => BadgeRarity.common,
      ),
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null,
      requiredValue: json['requiredValue'],
    );
  }
}

enum BadgeType {
  firstPurchase,
  productExplorer,
  searchMaster,
  favoriteCollector,
  weeklyStreak,
  monthlyGoal,
  referralMaster,
  socialSharer,
  bargainHunter,
}

enum BadgeRarity {
  common,
  rare,
  epic,
  legendary,
}

class UserPoints {
  final int totalPoints;
  final int currentPoints;
  final int level;
  final int pointsToNextLevel;
  final List<PointTransaction> transactions;

  UserPoints({
    required this.totalPoints,
    required this.currentPoints,
    required this.level,
    required this.pointsToNextLevel,
    required this.transactions,
  });

  double get levelProgress => pointsToNextLevel > 0 ? (currentPoints / pointsToNextLevel).clamp(0.0, 1.0) : 0.0;

  UserPoints copyWith({
    int? totalPoints,
    int? currentPoints,
    int? level,
    int? pointsToNextLevel,
    List<PointTransaction>? transactions,
  }) {
    return UserPoints(
      totalPoints: totalPoints ?? this.totalPoints,
      currentPoints: currentPoints ?? this.currentPoints,
      level: level ?? this.level,
      pointsToNextLevel: pointsToNextLevel ?? this.pointsToNextLevel,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'currentPoints': currentPoints,
      'level': level,
      'pointsToNextLevel': pointsToNextLevel,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      totalPoints: json['totalPoints'] ?? 0,
      currentPoints: json['currentPoints'] ?? 0,
      level: json['level'] ?? 1,
      pointsToNextLevel: json['pointsToNextLevel'] ?? 100,
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((t) => PointTransaction.fromJson(t))
          .toList() ?? [],
    );
  }
}

class PointTransaction {
  final String id;
  final int points;
  final PointType type;
  final String description;
  final DateTime timestamp;

  PointTransaction({
    required this.id,
    required this.points,
    required this.type,
    required this.description,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'type': type.toString(),
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      id: json['id'],
      points: json['points'],
      type: PointType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => PointType.challenge,
      ),
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

enum PointType {
  challenge,
  badge,
  referral,
  purchase,
  socialShare,
}

class ReferralSystem {
  final String referralCode;
  final int totalReferrals;
  final int successfulReferrals;
  final int totalEarnings;
  final List<Referral> referrals;
  final DateTime createdAt;

  ReferralSystem({
    required this.referralCode,
    this.totalReferrals = 0,
    this.successfulReferrals = 0,
    this.totalEarnings = 0,
    required this.referrals,
    required this.createdAt,
  });

  ReferralSystem copyWith({
    String? referralCode,
    int? totalReferrals,
    int? successfulReferrals,
    int? totalEarnings,
    List<Referral>? referrals,
    DateTime? createdAt,
  }) {
    return ReferralSystem(
      referralCode: referralCode ?? this.referralCode,
      totalReferrals: totalReferrals ?? this.totalReferrals,
      successfulReferrals: successfulReferrals ?? this.successfulReferrals,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      referrals: referrals ?? this.referrals,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referralCode': referralCode,
      'totalReferrals': totalReferrals,
      'successfulReferrals': successfulReferrals,
      'totalEarnings': totalEarnings,
      'referrals': referrals.map((r) => r.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReferralSystem.fromJson(Map<String, dynamic> json) {
    return ReferralSystem(
      referralCode: json['referralCode'],
      totalReferrals: json['totalReferrals'] ?? 0,
      successfulReferrals: json['successfulReferrals'] ?? 0,
      totalEarnings: json['totalEarnings'] ?? 0,
      referrals: (json['referrals'] as List<dynamic>?)
          ?.map((r) => Referral.fromJson(r))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Referral {
  final String id;
  final String referredUserId;
  final String referredUserName;
  final ReferralStatus status;
  final int earnings;
  final DateTime referredAt;
  final DateTime? completedAt;

  Referral({
    required this.id,
    required this.referredUserId,
    required this.referredUserName,
    this.status = ReferralStatus.pending,
    this.earnings = 0,
    required this.referredAt,
    this.completedAt,
  });

  Referral copyWith({
    String? id,
    String? referredUserId,
    String? referredUserName,
    ReferralStatus? status,
    int? earnings,
    DateTime? referredAt,
    DateTime? completedAt,
  }) {
    return Referral(
      id: id ?? this.id,
      referredUserId: referredUserId ?? this.referredUserId,
      referredUserName: referredUserName ?? this.referredUserName,
      status: status ?? this.status,
      earnings: earnings ?? this.earnings,
      referredAt: referredAt ?? this.referredAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referredUserId': referredUserId,
      'referredUserName': referredUserName,
      'status': status.toString(),
      'earnings': earnings,
      'referredAt': referredAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['id'],
      referredUserId: json['referredUserId'],
      referredUserName: json['referredUserName'],
      status: ReferralStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => ReferralStatus.pending,
      ),
      earnings: json['earnings'] ?? 0,
      referredAt: DateTime.parse(json['referredAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }
}

enum ReferralStatus {
  pending,
  completed,
  expired,
}
