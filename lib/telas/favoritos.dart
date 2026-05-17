import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models.dart';
import '../servico.dart';
import 'detalhes.dart';

// ─── Tela de favoritos ────────────────────────────────────────────────────────
class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  List<Filme> _favoritos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarFavoritos();
  }

  // Recarrega sempre que a tela fica visível (usuário volta da tela de detalhes)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregarFavoritos();
  }

  Future<void> _carregarFavoritos() async {
    final lista = await FilmeServico.carregarFavoritos();
    setState(() { _favoritos = lista; _carregando = false; });
  }

  Future<void> _remover(Filme filme) async {
    await FilmeServico.removerFavorito(filme.id);
    setState(() { _favoritos.removeWhere((f) => f.id == filme.id); });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removido dos favoritos.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                'Favoritos',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFE50914)))
                  : _favoritos.isEmpty
                      ? _buildVazio()
                      : _buildLista(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline, size: 72, color: Colors.white12),
          const SizedBox(height: 16),
          const Text(
            'Nenhum favorito ainda.',
            style: TextStyle(color: Colors.white38, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toque no ♥ em um filme para salvar.',
            style: TextStyle(color: Colors.white24, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildLista() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _favoritos.length,
      itemBuilder: (context, i) => _buildItem(_favoritos[i]),
    );
  }

  Widget _buildItem(Filme filme) {
    return Dismissible(
      // Deslizar para a esquerda remove o favorito
      key: Key(filme.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _remover(filme),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE50914),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetalhesPage(filme: filme)),
        ).then((_) => _carregarFavoritos()),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Poster
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                child: filme.urlPoster.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: filme.urlPoster,
                        width: 80,
                        height: 110,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 80,
                        height: 110,
                        color: const Color(0xFF1F1F1F),
                        child: const Icon(Icons.movie, color: Colors.white24),
                      ),
              ),

              // Informações
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        filme.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            filme.notaFormatada,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            filme.ano,
                            style: const TextStyle(color: Colors.white38, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        filme.sinopse,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              // Indicador de swipe
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.chevron_right, color: Colors.white24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
