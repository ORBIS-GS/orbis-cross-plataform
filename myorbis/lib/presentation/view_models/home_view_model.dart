import 'package:flutter/material.dart';
import 'package:myorbis/data/repositories/location-repository.dart';
import '../../domain/models/location_model.dart';
import '../../domain/models/soil_data_model.dart';

//Gerencia o estado e a lógica da tela Home, sem regras de negócio na tela.

enum HomeState { idle, loadingSearch, loadingSoil, success, error }

class HomeViewModel extends ChangeNotifier {
  final LocationRepository _locationRepository;

  HomeViewModel(this._locationRepository);

  HomeState _state = HomeState.idle;
  bool get isLoading =>
      _state == HomeState.loadingSearch || _state == HomeState.loadingSoil;

  List<LocationModel> _searchResults = [];
  SoilDataModel? _soilData;
  LocationModel? _selectedLocation;
  String _errorMessage = '';
  bool _isFavorite = false;
  List<LocationModel> _favorites = [];

  HomeState get state => _state;
  List<LocationModel> get searchResults => _searchResults;
  SoilDataModel? get soilData => _soilData;
  LocationModel? get selectedLocation => _selectedLocation;
  String get errorMessage => _errorMessage;
  bool get isFavorite => _isFavorite;
  List<LocationModel> get favorites => _favorites;

  Future<void> searchLocations(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _state = HomeState.idle;
      notifyListeners();
      return;
    }

    _state = HomeState.loadingSearch;
    notifyListeners();

    try {
      _searchResults = await _locationRepository.searchLocations(query);
      _state = HomeState.success;
      await _locationRepository.saveLastSearch(query);
      debugPrint('Busca realizada: $query');
    } catch (e) {
      _errorMessage = 'Não foi possível buscar localizações.';
      _state = HomeState.error;
      debugPrint('Falha na busca: $e');
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> selectLocation(LocationModel location) async {
    _selectedLocation = location;
    _searchResults = [];
    _state = HomeState.loadingSoil;
    notifyListeners();

    try {
      _soilData = await _locationRepository.fetchSoilData(
        latitude: location.latitude,
        longitude: location.longitude,
        timezone: location.timezone ?? 'America/Sao_Paulo',
      );
      _state = HomeState.success;
      await _locationRepository.saveLastLocation(location);
      _isFavorite = await _locationRepository.isFavorite(location.id);
      debugPrint('Dados carregados para: ${location.displayName}');
    } catch (e) {
      _errorMessage = 'Não foi possível obter os dados climáticos.';
      _state = HomeState.error;
      debugPrint('Falha ao carregar dados: $e');
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    if (_selectedLocation != null) await selectLocation(_selectedLocation!);
  }

  Future<void> toggleFavorite() async {
    if (_selectedLocation == null) return;
    if (_isFavorite) {
      await _locationRepository.removeFavorite(_selectedLocation!.id);
    } else {
      await _locationRepository.saveFavorite(_selectedLocation!);
    }
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    _favorites = await _locationRepository.getFavorites();
    notifyListeners();
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
}
