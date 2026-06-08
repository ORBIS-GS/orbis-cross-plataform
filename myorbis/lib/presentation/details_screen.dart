import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/models/location_model.dart';
import '../domain/models/soil_data_model.dart';
import 'view_models/details_view_model.dart';

// Tela de detalhes com dados completos, nível de risco e recomendações da localização.

class DetailsScreen extends StatelessWidget {
  final LocationModel location;
  final SoilDataModel soilData;

  const DetailsScreen({
    super.key,
    required this.location,
    required this.soilData,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailsViewModel(location, soilData),
      child: Consumer<DetailsViewModel>(
        builder: (_, vm, __) => Scaffold(
          backgroundColor: const Color(0xFFF0F4F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1565C0),
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language, color: Colors.white, size: 22),
                SizedBox(width: 8),
                Text(
                  'Detalhes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(vm),
                const SizedBox(height: 12),
                _buildDataPanel(vm),
                const SizedBox(height: 12),
                _buildRiskPanel(vm),
                const SizedBox(height: 12),
                _buildRecommendations(vm),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(DetailsViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE3ED)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Color(0xFF1565C0), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.location.displayName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2740),
                  ),
                ),
                Text(
                  vm.location.coordsDisplay,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFAAB4BE),
                  ),
                ),
              ],
            ),
          ),
          _buildBadge(
            vm.soilData.riskLabel,
            vm.isAlert ? const Color(0xFFFCE4EC) : const Color(0xFFDCFCE7),
            vm.isAlert ? const Color(0xFFC62828) : const Color(0xFF166534),
          ),
        ],
      ),
    );
  }

  Widget _buildDataPanel(DetailsViewModel vm) {
    return _SectionPanel(
      title: 'Dados da consulta',
      icon: Icons.thermostat,
      children: [
        _DataRow(label: 'Local', value: vm.location.displayName),
        _DataRow(label: 'Coordenadas', value: vm.location.coordsDisplay),
        _DataRow(
          label: 'Temperatura do solo',
          value: vm.temperatureDisplay,
          valueColor: vm.isAlert ? const Color(0xFFC62828) : null,
        ),
        _DataRow(label: 'Umidade', value: vm.soilData.moistureDisplay),
        _DataRow(label: 'Atualizado em', value: vm.updatedAt),
        _DataRow(label: 'Fonte', value: 'Open-Meteo API'),
        _DataRow(
          label: 'Status',
          value: '',
          trailing: _buildBadge(
            vm.soilData.riskLabel,
            vm.isAlert ? const Color(0xFFFCE4EC) : const Color(0xFFDCFCE7),
            vm.isAlert ? const Color(0xFFC62828) : const Color(0xFF166534),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskPanel(DetailsViewModel vm) {
    final color = vm.isAlert
        ? const Color(0xFFC62828)
        : const Color(0xFF166534);
    return _SectionPanel(
      title: 'Nível de risco',
      icon: Icons.warning_amber,
      children: [
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: vm.soilData.riskFraction,
            minHeight: 8,
            backgroundColor: const Color(0xFFDDE3ED),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 4),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Baixo',
              style: TextStyle(fontSize: 10, color: Color(0xFFAAB4BE)),
            ),
            Text(
              'Moderado',
              style: TextStyle(fontSize: 10, color: Color(0xFFAAB4BE)),
            ),
            Text(
              'Alto',
              style: TextStyle(fontSize: 10, color: Color(0xFFAAB4BE)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendations(DetailsViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFF1565C0),
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                'Recomendações',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1565C0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...vm.soilData.recommendations.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(color: Color(0xFF1565C0), fontSize: 11),
                  ),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(
                        color: Color(0xFF1565C0),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _SectionPanel extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionPanel({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE3ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1565C0), size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2740),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final Widget? trailing;

  const _DataRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFDDE3ED), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF5A6A7E)),
          ),
          trailing ??
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? const Color(0xFF1A2740),
                ),
              ),
        ],
      ),
    );
  }
}
