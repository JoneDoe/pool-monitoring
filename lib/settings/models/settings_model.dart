class AppSettings {
  final bool heroPool, woolyPool;
  final List<dynamic> cyrrency;

  AppSettings({
    required this.heroPool,
    required this.woolyPool,
    required this.cyrrency,
  });

  static AppSettings init() => AppSettings(
        heroPool: true,
        woolyPool: true,
        cyrrency: [],
      );

  factory AppSettings.fromJson(dynamic json) => AppSettings(
        heroPool: json['heroPool'] ?? true,
        woolyPool: json['woolyPool'] ?? true,
        cyrrency: json['cyrrency'] ?? [],
      );

  Map<String, dynamic> toJson() => {
        'heroPool': heroPool,
        'woolyPool': woolyPool,
        'cyrrency': cyrrency,
      };
}
