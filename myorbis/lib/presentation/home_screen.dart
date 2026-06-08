import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/models/location_model.dart';
import '../domain/models/soil_data_model.dart';
import 'view_models/home_view_model.dart';
import 'details_screen.dart';

// Tela principal com busca de cidades e exibição dos dados climáticos do solo.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadFavorites();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    context.read<HomeViewModel>().searchLocations(_searchController.text);
  }

  void _selectLocation(LocationModel loc) {
    _searchController.text = loc.displayName;
    context.read<HomeViewModel>().selectLocation(loc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchArea(),
            const SizedBox(height: 8),
            Consumer<HomeViewModel>(
              builder: (_, vm, __) => switch (vm.state) {
                HomeState.idle => _buildEmptyState(),
                HomeState.loadingSearch => _buildEmptyState(),
                HomeState.loadingSoil => _buildLoading(),
                HomeState.error => _buildError(vm),
                HomeState.success when vm.soilData != null => _buildResult(vm),
                _ => _buildEmptyState(),
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1565C0),
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language, color: Colors.white, size: 22),
          SizedBox(width: 8),
          Text(
            'ORBIS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          tooltip: 'Favoritos',
          onPressed: () => _showFavorites(context.read<HomeViewModel>()),
        ),
      ],
    );
  }

  Widget _buildSearchArea() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Consultar localização',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF5A6A7E),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Consumer<HomeViewModel>(
            builder: (_, vm, __) => Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) {
                      setState(() {});
                      if (v.isEmpty) vm.clearSearch();
                    },
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      hintText: 'Digite uma cidade ou bairro...',
                      hintStyle: const TextStyle(
                        color: Color(0xFFAAB4BE),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF1565C0),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Color(0xFFAAB4BE),
                                size: 18,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                vm.clearSearch();
                                setState(() {});
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF1565C0),
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1A2740),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: vm.state == HomeState.loadingSearch
                      ? null
                      : _search,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: vm.state == HomeState.loadingSearch
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          children: [
                            Icon(Icons.search, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Buscar',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          Consumer<HomeViewModel>(
            builder: (_, vm, __) {
              if (vm.searchResults.isEmpty) return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDDE3ED)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    children: vm.searchResults
                        .map((loc) => _buildLocationTile(loc))
                        .toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTile(LocationModel loc) {
    return InkWell(
      onTap: () => _selectLocation(loc),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFDDE3ED), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 18,
              color: Color(0xFF5A6A7E),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A2740),
                    ),
                  ),
                  if (loc.admin1 != null || loc.country != null)
                    Text(
                      [
                        loc.admin1,
                        loc.country,
                      ].where((s) => s != null && s.isNotEmpty).join(', '),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFFAAB4BE),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              loc.coordsDisplay,
              style: const TextStyle(fontSize: 10, color: Color(0xFFAAB4BE)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: const Column(
        children: [
          Icon(Icons.search, size: 52, color: Color(0xFFDDE3ED)),
          SizedBox(height: 12),
          Text(
            'Informe uma localização para consultar\na temperatura do solo',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFFAAB4BE)),
          ),
          SizedBox(height: 4),
          Text(
            'Dados fornecidos pela API Open-Meteo',
            style: TextStyle(fontSize: 12, color: Color(0xFFDDE3ED)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: const Column(
        children: [
          CircularProgressIndicator(color: Color(0xFF1565C0)),
          SizedBox(height: 16),
          Text(
            'Consultando dados climáticos...',
            style: TextStyle(color: Color(0xFF5A6A7E), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildError(HomeViewModel vm) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 40, color: Color(0xFFC62828)),
          const SizedBox(height: 12),
          Text(
            vm.errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFF5A6A7E)),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: vm.refresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(HomeViewModel vm) {
    final data = vm.soilData!;
    final loc = vm.selectedLocation!;
    final temp = data.currentTemperature;
    final now = DateTime.now();
    final isAlert =
        data.riskLevel == SoilRiskLevel.high ||
        data.riskLevel == SoilRiskLevel.critical;

    return Column(
      children: [
        Container(
          color: const Color(0xFFF4F7FC),
          padding: const EdgeInsets.all(16),
          child: Container(
            color: const Color(0xFFF4F7FC),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        label: 'Temperatura do solo',
                        value: temp != null
                            ? '${temp.toStringAsFixed(1)}°C'
                            : '--',
                        valueColor: isAlert ? const Color(0xFFC62828) : null,
                        badge: _buildBadge(
                          data.riskLabel,
                          isAlert
                              ? const Color(0xFFFCE4EC)
                              : const Color(0xFFDCFCE7),
                          isAlert
                              ? const Color(0xFFC62828)
                              : const Color(0xFF166534),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        label: 'Umidade do solo',
                        value: data.moistureDisplay,
                        badge: _buildBadge(
                          'Normal',
                          const Color(0xFFDBEAFE),
                          const Color(0xFF1565C0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        label: 'Última atualização',
                        value:
                            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                        subtitle:
                            '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        label: 'Coordenadas',
                        value: loc.latitude.toStringAsFixed(2),
                        subtitle: loc.longitude.toStringAsFixed(2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: vm.toggleFavorite,
                icon: Icon(
                  vm.isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 16,
                  color: vm.isFavorite
                      ? const Color(0xFFC62828)
                      : const Color(0xFF1565C0),
                ),
                label: Text(
                  vm.isFavorite ? 'Salvo' : 'Salvar',
                  style: TextStyle(
                    color: vm.isFavorite
                        ? const Color(0xFFC62828)
                        : const Color(0xFF1565C0),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: vm.isFavorite
                        ? const Color(0xFFC62828)
                        : const Color(0xFF1565C0),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DetailsScreen(location: loc, soilData: data),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Ver detalhes completos'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    String? subtitle,
    Color? valueColor,
    Widget? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE3ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF5A6A7E),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: valueColor ?? const Color(0xFF1A2740),
              height: 1.1,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Color(0xFFAAB4BE)),
            ),
          ],
          if (badge != null) ...[const SizedBox(height: 5), badge],
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

  void _showFavorites(HomeViewModel vm) {
    vm.loadFavorites();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Consumer<HomeViewModel>(
        builder: (_, v, __) {
          if (v.favorites.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 40,
                    color: Color(0xFFAAB4BE),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Nenhum local salvo ainda.',
                    style: TextStyle(color: Color(0xFF5A6A7E)),
                  ),
                ],
              ),
            );
          }
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Locais salvos',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2740),
                ),
              ),
              const SizedBox(height: 8),
              ...v.favorites.map((loc) => _buildLocationTile(loc)).toList(),
            ],
          );
        },
      ),
    );
  }
}
