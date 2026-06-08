import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/soil_data_model.dart';

// Busca temperatura e umidade do solo na API Open-Meteo Forecast via HTTP.

class SoilService {
  final http.Client _client;

  SoilService(this._client);

  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<SoilDataModel> fetchSoilData({
    required double latitude,
    required double longitude,
    String timezone = 'America/Sao_Paulo',
  }) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'hourly': 'soil_temperature_0cm,soil_moisture_0_to_1cm',
        'timezone': timezone,
        'forecast_days': '1',
      },
    );

    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar dados do solo: ${response.statusCode}');
    }

    return SoilDataModel.fromMap(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
