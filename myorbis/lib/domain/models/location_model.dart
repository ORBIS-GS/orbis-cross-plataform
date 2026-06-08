// Representa uma cidade retornada pela API de geocoding, com métodos de serialização.

class LocationModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;
  final String? timezone;

  LocationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
    this.timezone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
      'timezone': timezone,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] as int,
      name: map['name'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      country: map['country'] as String?,
      admin1: map['admin1'] as String?,
      timezone: map['timezone'] as String?,
    );
  }

  String get displayName {
    if (admin1 != null && admin1!.isNotEmpty) return '$name, $admin1';
    if (country != null && country!.isNotEmpty) return '$name — $country';
    return name;
  }

  String get coordsDisplay =>
      '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
}
