import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:myorbis/data/repositories/location-repository.dart';
import '../data/services/geocoding_service.dart';
import '../data/services/soil_service.dart';
import '../presentation/view_models/home_view_model.dart';

// Registra e conecta todas as dependências do app usando get_it.

final getIt = GetIt.instance;

void setupDependencyInjections() {
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => GeocodingService(getIt<http.Client>()));
  getIt.registerLazySingleton(() => SoilService(getIt<http.Client>()));
  getIt.registerLazySingleton(
    () => LocationRepository(getIt<GeocodingService>(), getIt<SoilService>()),
  );

  getIt.registerFactory(() => HomeViewModel(getIt<LocationRepository>()));
}
