class AppSettings {
  final bool heroPool, woolyPool;

  AppSettings({
    this.heroPool = true,
    this.woolyPool = true,
  });

  factory AppSettings.fromJson(dynamic json) => AppSettings(
        heroPool: json['heroPool'] ?? true,
        woolyPool: json['woolyPool'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'heroPool': heroPool,
        'woolyPool': woolyPool,
      };
}
