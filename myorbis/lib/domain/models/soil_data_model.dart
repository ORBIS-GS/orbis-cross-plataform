// Representa os dados climáticos do solo, calculando risco e recomendações por temperatura.

enum SoilRiskLevel { low, moderate, high, critical }

class SoilDataModel {
  final double latitude;
  final double longitude;
  final String timezone;
  final List<double?> soilTemperatures;
  final List<double?> soilMoistures;
  final DateTime fetchedAt;

  SoilDataModel({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.soilTemperatures,
    required this.soilMoistures,
    required this.fetchedAt,
  });

  factory SoilDataModel.fromMap(Map<String, dynamic> map) {
    final hourly = map['hourly'] as Map<String, dynamic>;

    final rawTemps = hourly['soil_temperature_0cm'] as List?;
    final temps =
        rawTemps
            ?.map((e) => e != null ? (e as num).toDouble() : null)
            .toList() ??
        [];

    final rawMoist = hourly['soil_moisture_0_to_1cm'] as List?;
    final moists =
        rawMoist
            ?.map((e) => e != null ? (e as num).toDouble() : null)
            .toList() ??
        [];

    return SoilDataModel(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      timezone: map['timezone'] as String? ?? 'UTC',
      soilTemperatures: temps,
      soilMoistures: moists,
      fetchedAt: DateTime.now(),
    );
  }

  double? get currentTemperature {
    final hour = DateTime.now().hour;
    if (soilTemperatures.length > hour) return soilTemperatures[hour];
    for (var i = soilTemperatures.length - 1; i >= 0; i--) {
      if (soilTemperatures[i] != null) return soilTemperatures[i];
    }
    return null;
  }

  double? get currentMoisture {
    final hour = DateTime.now().hour;
    if (soilMoistures.length > hour) return soilMoistures[hour];
    for (var i = soilMoistures.length - 1; i >= 0; i--) {
      if (soilMoistures[i] != null) return soilMoistures[i];
    }
    return null;
  }

  SoilRiskLevel get riskLevel {
    final temp = currentTemperature;
    if (temp == null) return SoilRiskLevel.low;
    if (temp >= 40) return SoilRiskLevel.critical;
    if (temp >= 35) return SoilRiskLevel.high;
    if (temp >= 28) return SoilRiskLevel.moderate;
    return SoilRiskLevel.low;
  }

  double get riskFraction => (currentTemperature ?? 0).clamp(0, 50) / 50;

  String get riskLabel => switch (riskLevel) {
    SoilRiskLevel.critical => 'Crítico',
    SoilRiskLevel.high => 'Alerta',
    SoilRiskLevel.moderate => 'Moderado',
    SoilRiskLevel.low => 'Normal',
  };

  String get moistureDisplay {
    final m = currentMoisture;
    if (m == null) return '--';
    return '${(m * 100).toStringAsFixed(1)}%';
  }

  List<String> get recommendations => switch (riskLevel) {
    SoilRiskLevel.critical => [
      'Evite exposição ao sol entre 10h–16h',
      'Hidrate-se frequentemente',
      'Prefira ambientes climatizados',
      'Atenção redobrada a idosos e crianças',
      'Não pratique exercícios ao ar livre',
    ],
    SoilRiskLevel.high => [
      'Evite sol entre 10h–16h',
      'Hidrate-se frequentemente',
      'Prefira ambientes frescos',
      'Atenção a idosos e crianças',
    ],
    SoilRiskLevel.moderate => [
      'Use protetor solar ao sair',
      'Mantenha-se hidratado',
      'Use roupas leves e frescas',
    ],
    SoilRiskLevel.low => [
      'Condições normais de temperatura',
      'Continue acompanhando as atualizações',
    ],
  };
}
