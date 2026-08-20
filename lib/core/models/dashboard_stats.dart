class DashboardStats {
  final int totalUsers;
  final int activeUsers;
  final int totalRevenue;
  final double growthRate;
  final List<ChartData> userGrowthData;
  final List<ChartData> revenueData;
  final List<ActivityItem> recentActivities;

  const DashboardStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalRevenue,
    required this.growthRate,
    required this.userGrowthData,
    required this.revenueData,
    required this.recentActivities,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
    totalUsers: json['totalUsers'] as int? ?? 0,
    activeUsers: json['activeUsers'] as int? ?? 0,
    totalRevenue: json['totalRevenue'] as int? ?? 0,
    growthRate: (json['growthRate'] as num?)?.toDouble() ?? 0.0,
    userGrowthData: (json['userGrowthData'] as List<dynamic>?)
        ?.map((e) => ChartData.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    revenueData: (json['revenueData'] as List<dynamic>?)
        ?.map((e) => ChartData.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    recentActivities: (json['recentActivities'] as List<dynamic>?)
        ?.map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'totalUsers': totalUsers,
    'activeUsers': activeUsers,
    'totalRevenue': totalRevenue,
    'growthRate': growthRate,
    'userGrowthData': userGrowthData.map((e) => e.toJson()).toList(),
    'revenueData': revenueData.map((e) => e.toJson()).toList(),
    'recentActivities': recentActivities.map((e) => e.toJson()).toList(),
  };
}

class ChartData {
  final String label;
  final double value;
  final String? color;

  const ChartData({
    required this.label,
    required this.value,
    this.color,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
    label: json['label'] as String? ?? '',
    value: (json['value'] as num?)?.toDouble() ?? 0.0,
    color: json['color'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'label': label,
    'value': value,
    'color': color,
  };
}

class ActivityItem {
  final String id;
  final String description;
  final String userId;
  final String userName;
  final DateTime timestamp;
  final String type;

  const ActivityItem({
    required this.id,
    required this.description,
    required this.userId,
    required this.userName,
    required this.timestamp,
    required this.type,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) => ActivityItem(
    id: json['id'] as String? ?? '',
    description: json['description'] as String? ?? '',
    userId: json['userId'] as String? ?? '',
    userName: json['userName'] as String? ?? '',
    timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : DateTime.now(),
    type: json['type'] as String? ?? 'info',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'userId': userId,
    'userName': userName,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
  };
}