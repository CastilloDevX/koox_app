class BusStation {
  final int id;
  final String name;
  final List<String> routes;
  final double latitude;
  final double longitude;

  BusStation({
    required this.id,
    required this.name,
    required this.routes,
    required this.latitude,
    required this.longitude,
  });

  factory BusStation.fromJson(Map<String, dynamic> json) {
    return BusStation(
      id: json['id'],
      name: json['stop_name'] ?? 'Sin nombre', 
      routes: List<String>.from(json['routes'] ?? []),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}