import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'telas/home.dart';
import 'telas/favoritos.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFE50914),
          surface: const Color(0xFF141414),
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF141414),
        useMaterial3: true,
      ),
      home: const RootPage(),
    );
  }
}

// ─── Navegação principal com BottomNavigationBar ────────────────────────────
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _abaSelecionada = 0;

  final List<Widget> _telas = const [
    HomePage(),
    FavoritosPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_abaSelecionada],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF1F1F1F),
        indicatorColor: const Color(0xFFE50914),
        selectedIndex: _abaSelecionada,
        onDestinationSelected: (i) => setState(() => _abaSelecionada = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: 'Filmes',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
