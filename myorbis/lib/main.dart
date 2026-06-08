import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/dependency_injections.dart';
import 'presentation/view_models/home_view_model.dart';
import 'presentation/home_screen.dart';

// Ponto de entrada: inicializa as dependências e sobe o app.

void main() {
  setupDependencyInjections();
  runApp(const OrbisApp());
}

class OrbisApp extends StatelessWidget {
  const OrbisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<HomeViewModel>()),
      ],
      child: MaterialApp(
        title: 'ORBIS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
