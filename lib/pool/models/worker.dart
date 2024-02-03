class Worker {
  String name;
  double hashrate;
  bool offline;

  Worker({required this.name, required this.hashrate, this.offline = false});

  factory Worker.fromMapHm(Map<String, dynamic> map) {
    return Worker(
      name: map['name'],
      hashrate: map['hashrate'].toDouble() / 1000000000,
    );
  }

  factory Worker.fromMapWp(Map<String, dynamic> map) {
    return Worker(
      name: map['worker'],
      hashrate: map['hr'].toDouble() / 1000000000,
      offline: map['offline'],
    );
  }
}
