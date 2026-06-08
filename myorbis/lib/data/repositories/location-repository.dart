import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/location_model.dart';
import '../services/geocoding_service.dart';
import '../services/soil_service.dart';
import '../../domain/models/soil_data_model.dart';

// Centraliza o acesso às APIs e à persistência local (favoritos, última busca).

class LocationRepository {
  final GeocodingService _geocodingService;
  final SoilService _soilService;

  LocationRepository(this._geocodingService, this._soilService);

  static const _keyFavorites = 'favorite_locations';
  static const _keyLastLocation = 'last_location';
  static const _keyLastSearch = 'last_search';

  Future<List<LocationModel>> searchLocations(String query) async {
    return _geocodingService.searchLocations(query);
  }

  Future<SoilDataModel> fetchSoilData({
    required double latitude,
    required double longitude,
    String timezone = 'America/Sao_Paulo',
  }) async {
    return _soilService.fetchSoilData(
      latitude: latitude,
      longitude: longitude,
      timezone: timezone,
    );
  }

  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyFavorites) ?? [];
    return raw
        .map(
          (e) => LocationModel.fromMap(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> saveFavorite(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getFavorites();
    if (current.any((l) => l.id == location.id)) return;
    current.add(location);
    await prefs.setStringList(
      _keyFavorites,
      current.map((l) => jsonEncode(l.toMap())).toList(),
    );
  }

  Future<void> removeFavorite(int locationId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getFavorites();
    current.removeWhere((l) => l.id == locationId);
    await prefs.setStringList(
      _keyFavorites,
      current.map((l) => jsonEncode(l.toMap())).toList(),
    );
  }

  Future<bool> isFavorite(int locationId) async =>
      (await getFavorites()).any((l) => l.id == locationId);

  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastLocation, jsonEncode(location.toMap()));
  }

  Future<LocationModel?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyLastLocation);
    if (raw == null) return null;
    return LocationModel.fromMap(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveLastSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastSearch, query);
  }

  Future<String?> getLastSearch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastSearch);
  }
}
