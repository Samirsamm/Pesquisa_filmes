import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models.dart';
import '../servico.dart';
import 'detalhes.dart';

// ─── Tela inicial ────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ── Estado ──────────────────────────────────────────────────────────────
  List<Filme> _filmes = [];
  List<Filme> _resultadosBusca = [];
  bool _carregando = true;
  bool _buscando = false;
  String? _erro;
  int _pagina = 1;
  bool _temMais = true;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _carregarPopulares();
    // Detecta quando o usuário chegou no fim da lista para carregar mais
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _carregarMais();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Carregamento inicial ─────────────────────────────────────────────────
  Future<void> _carregarPopulares() async {
    setState(() { _carregando = true; _erro = null; });
    try {
      final filmes = await FilmeServico.buscarPopulares();
      setState(() { _filmes = filmes; _pagina = 1; _temMais = true; });
    } catch (e) {
      setState(() { _erro = 'Erro ao carregar filmes. Verifique sua conexão.'; });
    } finally {
      setState(() { _carregando = false; });
    }
  }

  // ── Paginação ────────────────────────────────────────────────────────────
  Future<void> _carregarMais() async {
    if (!_temMais || _buscando || _controller.text.isNotEmpty) return;
    setState(() { _buscando = true; });
    try {
      final mais = await FilmeServico.buscarPopulares(pagina: _pagina + 1);
      if (mais.isEmpty) {
        setState(() { _temMais = false; });
      } else {
        setState(() { _filmes.addAll(mais); _pagina++; });
      }
    } catch (_) {} finally {
      setState(() { _buscando = false; });
    }
  }

  // ── Busca ────────────────────────────────────────────────────────────────
  Future<void> _buscar(String query) async {
    if (query.trim().isEmpty) {
      setState(() { _resultadosBusca = []; });
      return;
    }
    setState(() { _buscando = true; });
    try {
      final resultados = await FilmeServico.buscar(query);
      setState(() { _resultadosBusca = resultados; });
    } catch (_) {} finally {
      setState(() { _buscando = false; });
    }
  }

  // ── Navegação para detalhes ──────────────────────────────────────────────
  void _abrirDetalhes(Filme filme) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalhesPage(filme: filme)),
    );
  }

  // ── Interface ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final filmesExibidos = _controller.text.isNotEmpty
        ? _resultadosBusca
        : _filmes;

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCabecalho(),
            _buildBusca(),
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFE50914)))
                  : _erro != null
                      ? _buildErro()
                      : _buildGrid(filmesExibidos),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCabecalho() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          const Text(
            'CineApp',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE50914),
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          if (_buscando)
            const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFE50914),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBusca() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller: _controller,
        onChanged: _buscar,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar filmes...',
          hintStyle: TextStyle(color: Colors.white38),
          prefixIcon: const Icon(Icons.search, color: Colors.white38),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white38),
                  onPressed: () {
                    _controller.clear();
                    setState(() { _resultadosBusca = []; });
                  },
                )
              : null,
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(List<Filme> filmes) {
    if (filmes.isEmpty) {
      return const Center(
        child: Text('Nenhum filme encontrado.', style: TextStyle(color: Colors.white54)),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filmes.length + (_temMais && _controller.text.isEmpty ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == filmes.length) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE50914)),
          );
        }
        return _buildCard(filmes[i]);
      },
    );
  }

  Widget _buildCard(Filme filme) {
    return GestureDetector(
      onTap: () => _abrirDetalhes(filme),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Poster
            filme.urlPoster.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: filme.urlPoster,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: const Color(0xFF2A2A2A)),
                    errorWidget: (_, __, ___) => Container(
                      color: const Color(0xFF2A2A2A),
                      child: const Icon(Icons.movie, color: Colors.white24, size: 48),
                    ),
                  )
                : Container(
                    color: const Color(0xFF2A2A2A),
                    child: const Icon(Icons.movie, color: Colors.white24, size: 48),
                  ),

            // Gradiente e informações na parte inferior
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      filme.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          filme.notaFormatada,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const Spacer(),
                        Text(
                          filme.ano,
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErro() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white38, size: 64),
          const SizedBox(height: 16),
          Text(_erro!, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _carregarPopulares,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914)),
          ),
        ],
      ),
    );
  }
}
