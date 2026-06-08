import 'package:flutter/material.dart';
import '../../domain/models/location_model.dart';
import '../../domain/models/soil_data_model.dart';

// Formata e expõe os dados do solo para exibição na tela de detalhes.

class DetailsViewModel extends ChangeNotifier {
  final LocationModel location;
  final SoilDataModel soilData;

  DetailsViewModel(this.location, this.soilData);

  String get temperatureDisplay {
    final temp = soilData.currentTemperature;
    if (temp == null) return '--';
    return '${temp.toStringAsFixed(1)}°C';
  }

  String get updatedAt {
    final t = soilData.fetchedAt;
    final h  = t.hour.toString().padLeft(2, '0');
    final mi = t.minute.toString().padLeft(2, '0');
    final d  = t.day.toString().padLeft(2, '0');
    final mo = t.month.toString().padLeft(2, '0');
    return '$h:$mi · $d/$mo/${t.year}';
  }

  bool get isAlert =>
      soilData.riskLevel == SoilRiskLevel.high ||
      soilData.riskLevel == SoilRiskLevel.critical;
}