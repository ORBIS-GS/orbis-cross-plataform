import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/location_model.dart';

// Busca cidades pelo nome na API Open-Meteo Geocoding via HTTP.
class GeocodingService {
  final http.Client _client;

  GeocodingService(this._client);

  static const String _baseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  Future<List<LocationModel>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'name': query.trim(),
        'count': '8',
        'language': 'pt',
        'format': 'json',
      },
    );

    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar localizações: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = body['results'] as List?;
    if (results == null) return [];

    return results
        .map((e) => LocationModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
